local cn = require("lib/complex")
local Bitmap = require("lib/lua-bitmap")
local cli = require("lib/cli-command")

local path = "./"

local command = cli.buildCommandString({...})

if (cli.getSwitch(command, "?", "help")) then
    print("Usage: lua main.lua [options]")
    print("Options:")
    print("  -w, --width <width>       Width of the image                 [Default: 900]")
    print("  -h, --height <height>     Height of the image                [Default: 600]")
    print("  -R, --real <real>         Real part of the center point      [Default: -0.5]")
    print("  -I, --imag <imag>         Imaginary part of the center point [Default: 0]")
    print("  -z, --zoom <zoom>         Zoom level                         [Default: 0]")
    print("  -i, --iterations <iter>   Maximum number of iterations       [Default: 255]")
    print("  -o, --output <file>       Output file path                   [Default: "..path.."mandel-<width>x<height>.bmp]")
    print("  -x, --interactive         Interactive mode")
    print("  -b, --black               Black inside the set")
    print("  -v, --verbose             Verbose output")
    print("  -p, --progress            Show progress")
    print("  -?, --help                Show this help")
    return
end
local width = tonumber(cli.getArgument(command, "w", "width") or 900)
local height = tonumber(cli.getArgument(command, "h", "height") or 600)
local maxIterations = tonumber(cli.getArgument(command, "i", "iterations") or 255)
local realCenter = tonumber(cli.getArgument(command, "R", "real") or -0.5)
local imaginaryCenter = tonumber(cli.getArgument(command, "I", "imag") or 0)
local zoom = tonumber(cli.getArgument(command, "z", "zoom") or 0)
local filePath = cli.getArgument(command, "o", "output") or path.."mandel-"..width.."x"..height..".bmp"
local interactive = cli.getSwitch(command, "x", "interactive") and true
local blackInside = cli.getSwitch(command, "b", "black") and true
local verbose = cli.getSwitch(command, "v", "verbose")
local progressReporting = cli.getSwitch(command, "p", "progress")


local keepInsideWhite


function easingFunction(x)
    if x >= 1 then
        return 1 * keepInsideWhite
    else
        return 1 - math.exp(-(maxIterations / 40 / math.max(zoom, 1)) * x)
    end
end


local bmp = Bitmap.empty_bitmap(width, height, false)
local running = true
while running do
    if verbose then
        print("Generating Mandelbrot set with parameters:")
        print("Width: "..width)
        print("Height: "..height)
        print("Center Point: "..realCenter.." + "..imaginaryCenter.."i")
        print("Zoom: e^"..zoom.." = "..math.exp(zoom))
        print("Max iterations: "..maxIterations)
        print("Black inside: "..tostring(blackInside))
        print("Location command: -R "..realCenter.." -I "..imaginaryCenter.." -z "..zoom)
    end
    if blackInside then
        keepInsideWhite = 0
    else
        keepInsideWhite = 1
    end
    local center = cn.new(realCenter, imaginaryCenter)
    local aspectRatio = width / height
    zoomE = math.exp(zoom)
    local topLeft = cn.new(center.r - (aspectRatio / zoomE), center.i + (1 / zoomE))
    local bottomRight = cn.new(center.r + (aspectRatio / zoomE), center.i - (1 / zoomE))
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
        print("Total time: "..string.format("%.2f", os.clock()).."s")
    end
    io.open(filePath, "w"):write(bmp:tostring())
    print("Done writing image to "..filePath)

    while interactive do
        print("Enter 'wasd+-erv' to generate another image or enter 'q' to quit")
        local input = io.read(1)
        if input == "q" then
            running = false
            break
        elseif input == "+" then
            zoom = zoom + 0.1
        elseif input == "-" then
            zoom = zoom - 0.1
        elseif input == "w" then
            imaginaryCenter = imaginaryCenter + imaginaryHeight/10
        elseif input == "s" then
            imaginaryCenter = imaginaryCenter - imaginaryHeight/10
        elseif input == "a" then
            realCenter = realCenter - realWidth/10
        elseif input == "d" then
            realCenter = realCenter + realWidth/10
        elseif input == "b" then
            blackInside = not blackInside
        elseif input == "e" then
            maxIterations = maxIterations * 1.1
        elseif input == "r" then
            maxIterations = maxIterations / 1.1
        elseif input == "v" then
            print("Toggled verbose option")
            verbose = not verbose
        elseif input == "\n" then
            break
        end
    end

    if not interactive then
        running = false
    end
end
