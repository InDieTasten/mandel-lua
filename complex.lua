complex = {}
    
function complex.new (r, i) return {r=r, i=i} end

-- defines a constant 'i'
complex.i = complex.new(0, 1)

function complex.add (c1, c2)
    return complex.new(c1.r + c2.r, c1.i + c2.i)
end

function complex.sub (c1, c2)
    return complex.new(c1.r - c2.r, c1.i - c2.i)
end

function complex.mul (c1, c2)
    return complex.new(c1.r*c2.r - c1.i*c2.i,
                        c1.r*c2.i + c1.i*c2.r)
end

function complex.inv (c)
    local n = c.r^2 + c.i^2
    return complex.new(c.r/n, -c.i/n)
end

function complex.pow(c, n)
    assert(math.floor(n) == n, "Expected integer for second argument, got "..n..".")
    
    if n < 0 then
        local val = c.r^2 + c.i^2
        c = complex.new(c.r/val ,-c.i/val)
        n = -n
     end
     local r,i = c.r,c.i
     for it = 2,n do
        r,i = r*c.r - i*c.i,r*c.i + i*c.r
     end
     return complex.new(r, i)
end

return complex