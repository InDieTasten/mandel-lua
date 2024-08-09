local cn = require("complex")

width = 90
height = 60

for y = 1, height do
    for x = 1, width do
        local c = cn.new((x - width/2)/(width/4), (y - height/2)/(height/4))
        local z = cn.new(0, 0)
        local i = 0
        while i < 100 and (z.r*z.r + z.i*z.i) < 4 do
            z = cn.add(cn.mul(z, z), c)
            i = i + 1
        end
        if i == 100 then
            io.write(" ")
        else
            io.write("#")
        end
    end
    io.write("\n")
end
