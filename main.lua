local cn = require("lib/complex")
local Bitmap = require("lib/lua-bitmap")
local cli = require("lib/cli-command")

local path = "docs/images/"

local command = cli.buildCommandString({...})

if (cli.getSwitch(command, "?", "help")) then
    print("Usage: lua main.lua [options]")
    print("Options:")
    print("  -w, --width <width>       Width of the image           [Default: 900]")
    print("  -h, --height <height>     Height of the image          [Default: 600]")
    print("  -i, --iterations <iter>   Maximum number of iterations [Default: 255]")
    print("  -o, --output <file>       Output file path             [Default: "..path.."mandel-<width>x<height>.bmp]")
    print("  -b, --black               Black inside the set")
    print("  -v, --verbose             Verbose output")
    print("  -p, --progress            Show progress")
    print("  -?, --help                Show this help")
    return
end
local width = tonumber(cli.getArgument(command, "w", "width") or 900)
local height = tonumber(cli.getArgument(command, "h", "height") or 600)
local maxIterations = tonumber(cli.getArgument(command, "i", "iterations") or 255)
local filePath = cli.getArgument(command, "o", "output") or path.."mandel-"..width.."x"..height..".bmp"
local blackInside = cli.getSwitch(command, "b", "black") and true
local verbose = cli.getSwitch(command, "v", "verbose")
local progressReporting = cli.getSwitch(command, "p", "progress")

local keepInsideWhite = 1
if blackInside then
    keepInsideWhite = 0
end

if verbose then
    print("Generating Mandelbrot set with parameters:")
    print("Width: "..width)
    print("Height: "..height)
    print("Max iterations: "..maxIterations)
    print("Black inside: "..tostring(blackInside))
end
--complex range to sample
local topLeft = cn.new(-2, 1)
local bottomRight = cn.new(1, -1)

function easingFunction(x)
    if x >= 1 then
        return 1 * keepInsideWhite
    else
        return 1 - 2 ^ (-(maxIterations / 40) * x)
    end
end

local bmp = Bitmap.empty_bitmap(width, height, false)
local realWidth = bottomRight.r - topLeft.r
local imaginaryHeight = topLeft.i - bottomRight.i

for y = 0, height-1 do
    local imaginaryCoordinate = topLeft.i - y/height * imaginaryHeight
    for x = 0, width-1 do
        local realCoordinate = topLeft.r + x/width * realWidth
        local c = cn.new(realCoordinate, imaginaryCoordinate)
        local z = cn.new(0, 0)
        local i = 0
        while i < maxIterations and cn.mag(z) < 1000000000000 do
            z = cn.add(cn.pow(z, 2), c)
            i = i + 1
        end

        local ni = i/maxIterations

        local grayScaleValue = easingFunction(ni) * 255
        bmp:set_pixel(x, y, grayScaleValue, grayScaleValue, grayScaleValue)
    end
    if progressReporting then
        print("Progress: "..(math.floor(y/height*10000)/100).."%\r")
    end
end

if verbose then
    print("Calculations done, writing to file...")
    io.open(filePath, "w"):write(bmp:tostring())
    print("Total time: "..string.format("%.2f", os.clock()).."s")
end
print("Done writing image to "..filePath)
