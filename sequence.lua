local cli = require("lib/cli-command")

local lua_command = io.popen("echo -n ${LUA_COMMAND:-lua}"):read("*a")
print("LUA_COMMAND: "..lua_command)

local command = cli.buildCommandString({...})

if cli.getSwitch(command, "?", "help") then
    print("Usage: "..lua_command.." sequence.lua [options]")
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
    print("  -f, --gif                 Use ffmpeg to create a gif")
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

os.execute("mkdir -p frames")
os.execute("rm -f frames/*")

print("Render sequence with "..sequence.." frames")
print("Center: "..realCenter.."+"..imaginaryCenter.."i >> "..realCenter2.."+"..imaginaryCenter2.."i")
print("Zoom: "..zoom.." > "..zoom2)
print("Iterations: "..maxIterations.." > "..maxIterations2)

--exponential ease out function
function easeOut(x)
    return 1-2^(-10*x)
end

for i = 1, sequence do
    local t = (i-1) / sequence
    local real = realCenter + (realCenter2 - realCenter) * easeOut(t)
    local imag = imaginaryCenter + (imaginaryCenter2 - imaginaryCenter) * easeOut(t)
    local z = zoom + (zoom2 - zoom) * t
    local n = maxIterations + (maxIterations2 - maxIterations) * t

    local command = lua_path.." main.lua -w "..width.." -h "..height.." -r "..real.." -i "..imag.." -z "..z.." -n "..n.." -o frames/frame-"..string.format("%04d", i)..".bmp"
    print(command)
    io.popen(command):read("*a")
end

if genGif then
    os.execute("ffmpeg -y -framerate 30 -i frames/frame-%04d.bmp -vf \"fps=30,scale="..width..":-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse\" -loop 0 output.gif")
end
