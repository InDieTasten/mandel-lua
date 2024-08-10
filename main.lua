local cn = require("lib/complex")
local Bitmap = require("lib/lua-bitmap")

local path = "docs/images/"

local args = {...}

--output dimensions
local width = tonumber(args[1] or 900)
local height = tonumber(args[2] or 600)

--complex range to sample
local topLeft = cn.new(-2, 1)
local bottomRight = cn.new(1, -1)

local maxIterations = 255

function easingFunction(x)
    if x >= 1 then
        return 1
    else
        return 1 - 2 ^ (-(maxIterations / 40) * x)
    end
end

local filePath = path.."mandel-"..width.."x"..height..".bmp"
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
    print("Progress: "..(math.floor(y/height*10000)/100).."%")
end

print("Calculations done, writing to file...")
io.open(filePath, "w"):write(bmp:tostring())
print("Done writing image to "..filePath)
print("Total time: "..string.format("%.2f", os.clock()).."s")
