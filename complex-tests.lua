require("complex")

local tests = {
    add = function ()
        local c1 = complex.new(1, 2)
        local c2 = complex.new(3, 4)
        local c3 = complex.add(c1, c2)
        assert(c3.r == 4 and c3.i == 6, "Expected 4 + 6i, got "..c3.r.." + "..c3.i.."i")
    end,
    sub = function ()
        local c1 = complex.new(1, 2)
        local c2 = complex.new(3, 4)
        local c3 = complex.sub(c1, c2)
        assert(c3.r == -2 and c3.i == -2, "Expected -2 - 2i, got "..c3.r.." + "..c3.i.."i")
    end,
    mul = function ()
        local c1 = complex.new(1, 2)
        local c2 = complex.new(3, 4)
        local c3 = complex.mul(c1, c2)
        assert(c3.r == -5 and c3.i == 10, "Expected -5 + 10i, got "..c3.r.." + "..c3.i.."i")
    end,
    inv = function ()
        local c = complex.new(1, 2)
        local c2 = complex.inv(c)
        assert(c2.r == 0.2 and c2.i == -0.4, "Expected 0.2 - 0.4i, got "..c2.r.." + "..c2.i.."i")
    end,
    pow1 = function ()
        local c = complex.new(1, 2)
        local c2 = complex.pow(c, 2)
        assert(c2.r == -3 and c2.i == 4, "Expected -3 + 4i, got "..c2.r.." + "..c2.i.."i")
    end,
    pow2 = function ()
        local c3 = complex.new(5, 8)
        local c4 = complex.pow(c3, 3)
        assert(c4.r == -835 and c4.i == 88, "Expected -835 + 88i, got "..c4.r.." + "..c4.i.."i")
    end,
    mag = function ()
        local c = complex.new(3, 4)
        local m = complex.mag(c)
        assert(m == 5, "Expected 5, got "..m)
    end
}

return tests