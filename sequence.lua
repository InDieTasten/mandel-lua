local cli = require("lib/cli-command")
local color = require("lib/color")

local lua_command = io.popen("echo -n ${LUA_COMMAND:-lua}"):read("*a")
print("LUA_COMMAND: " .. lua_command)

local command = cli.buildCommandString({ ... })

if cli.getSwitch(command, "?", "help") then
    print("Usage: " .. lua_command .. " sequence.lua [options]")
    print("Options:")
    print("  -w, --width <width>       Width of the image                 [Default: 900]")
    print("  -h, --height <height>     Height of the image                [Default: 600]")
    print("")
    print("  -r, --real <real>         Real part of the center point      [Default: -0.5]")
    print("  -i, --imag <imag>         Imaginary part of the center point [Default: 0]")
    print("  -z, --zoom <zoom>         Zoom level                         [Default: 0]")
    print("  -n, --iterations <iter>   Maximum number of iterations       [Default: 255]")
    print("")
    print("  -R, --real2 <real>        Target -r for sequence             [Default: -0.5]")
    print("  -I, --imag2 <imag>        Target -i for sequence             [Default: 0]")
    print("  -Z, --zoom2 <zoom>        Target -z for sequence             [Default: 0]")
    print("  -N, --iterations2 <iter>  Target -n for sequence             [Default: 255]")
    print("  -s, --sequence <frames>   Number of frames in the sequence   [Default: 10]")
    print("  -b, --black               Black inside the set")
    print("")
    print("  --color1 <hex>            Initial first gradient color       [Default: 000000]")
    print("  --color2 <hex>            Initial second gradient color      [Default: 808080]")
    print("  --color3 <hex>            Initial third gradient color       [Default: FFFFFF]")
    print("  --targetcolor1 <hex>      Target first gradient color        [Default: same as --color1]")
    print("  --targetcolor2 <hex>      Target second gradient color       [Default: same as --color2]")
    print("  --targetcolor3 <hex>      Target third gradient color        [Default: same as --color3]")
    print("")
    print("  -g, --gif                 Use ffmpeg to create a gif")
    return
end

local width = tonumber(cli.getArgument(command, "w", "width") or 900)
local height = tonumber(cli.getArgument(command, "h", "height") or 600)
local realCenter = tonumber(cli.getArgument(command, "r", "real") or -0.5)
local imaginaryCenter = tonumber(cli.getArgument(command, "i", "imag") or 0)
local zoom = tonumber(cli.getArgument(command, "z", "zoom") or 0)
local maxIterations = tonumber(cli.getArgument(command, "n", "iterations2") or 255)
local realCenter2 = tonumber(cli.getArgument(command, "R", "real2") or -0.5)
local imaginaryCenter2 = tonumber(cli.getArgument(command, "I", "imag2") or 0)
local zoom2 = tonumber(cli.getArgument(command, "Z", "zoom") or 0)
local maxIterations2 = tonumber(cli.getArgument(command, "N", "iterations2") or 255)
local sequence = tonumber(cli.getArgument(command, "s", "sequence") or 10)
local blackInside = cli.getSwitch(command, "b", "black") and true
local genGif = cli.getSwitch(command, "g", "gif") and true

-- Parse color arguments
local color1Hex = cli.getArgument(command, "1", "color1") or "000000"
local color2Hex = cli.getArgument(command, "2", "color2") or "808080"
local color3Hex = cli.getArgument(command, "3", "color3") or "FFFFFF"
local targetColor1Hex = cli.getArgument(command, "4", "targetcolor1") or color1Hex
local targetColor2Hex = cli.getArgument(command, "5", "targetcolor2") or color2Hex
local targetColor3Hex = cli.getArgument(command, "6", "targetcolor3") or color3Hex

local initialGradient = {
    color.parseHex(color1Hex),
    color.parseHex(color2Hex),
    color.parseHex(color3Hex)
}

local targetGradient = {
    color.parseHex(targetColor1Hex),
    color.parseHex(targetColor2Hex),
    color.parseHex(targetColor3Hex)
}

os.execute("mkdir -p frames")
os.execute("rm -f frames/*")

print("Render sequence with " .. sequence .. " frames")
print("Center: " .. realCenter .. "+" .. imaginaryCenter .. "i >> " .. realCenter2 .. "+" .. imaginaryCenter2 .. "i")
print("Zoom: " .. zoom .. " > " .. zoom2)
print("Iterations: " .. maxIterations .. " > " .. maxIterations2)

--exponential ease out function
function easeOut(x)
    return 1 - 2 ^ (-10 * x)
end

local blackOption = ""
if blackInside then
    blackOption = "-b "
end

for i = 1, sequence do
    local t = (i - 1) / (sequence - 1) -- Fix: use sequence-1 to ensure last frame gets t=1
    local real = realCenter + (realCenter2 - realCenter) * easeOut(t)
    local imag = imaginaryCenter + (imaginaryCenter2 - imaginaryCenter) * easeOut(t)
    local z = zoom + (zoom2 - zoom) * t
    local n = maxIterations + (maxIterations2 - maxIterations) * t

    -- Interpolate gradient colors for this frame
    local frameGradient = color.interpolateGradients(initialGradient, targetGradient, t)
    local colorOptions = string.format("--color1 %02X%02X%02X --color2 %02X%02X%02X --color3 %02X%02X%02X",
        frameGradient[1].r, frameGradient[1].g, frameGradient[1].b,
        frameGradient[2].r, frameGradient[2].g, frameGradient[2].b,
        frameGradient[3].r, frameGradient[3].g, frameGradient[3].b)

    local command = lua_command ..
    " main.lua " ..
    blackOption ..
    "-w " ..
    width ..
    " -h " ..
    height ..
    " -r " ..
    real .. " -i " ..
    imag .. " -z " .. z .. " -n " .. n .. " " .. colorOptions .. " -o frames/frame-" .. string.format("%04d", i) ..
    ".bmp"
    print(command)
    io.popen(command):read("*a")
end

if genGif then
    os.execute("ffmpeg -y -framerate 30 -i frames/frame-%04d.bmp -vf \"fps=30,scale=" ..
    width .. ":-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse\" -loop 0 output.gif")
end
