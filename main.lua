local cn = require("complex")
local Bitmap = require("lua-bitmap")

local path = "docs/images/"

--output dimensions
local width = 9000
local height = 6000

--complex range to sample
local topLeft = cn.new(-2, 1)
local bottomRight = cn.new(1, -1)


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
        while i < 100 and cn.mag(z) < 4 do
            z = cn.add(cn.mul(z, z), c)
            i = i + 1
        end

        local grayScaleValue = math.floor(i/100*255)
        bmp:set_pixel(x, y, grayScaleValue, grayScaleValue, grayScaleValue)
    end
    print("Progress: "..(math.floor(y/height*10000)/100).."%")
end
print("Calculations done, writing to file...")
io.open(filePath, "w"):write(bmp:tostring())
print("Done writing image to "..filePath)
print("Total time: "..string.format("%.2f", os.clock()).."s")
