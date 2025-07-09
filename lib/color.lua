-- Color utility functions for Mandelbrot renderer
-- Supports RGB hex parsing and gradient interpolation

local color = {}

-- Parse RGB hex color string (e.g., "FF0000" for red)
function color.parseHex(hexColor)
    assert(type(hexColor) == "string", "Expected string, got "..type(hexColor))
    
    -- Remove optional # prefix
    local hex = hexColor:gsub("^#", "")
    
    -- Validate hex format (6 characters)
    if #hex ~= 6 then
        error("Invalid hex color format: expected 6 characters, got "..#hex)
    end
    
    -- Parse RGB components
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    
    if not r or not g or not b then
        error("Invalid hex color: "..hexColor)
    end
    
    return {r = r, g = g, b = b}
end

-- Linear interpolation between two values
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Interpolate between two RGB colors
function color.interpolate(color1, color2, t)
    t = math.max(0, math.min(1, t)) -- Clamp t to [0, 1]
    
    return {
        r = math.floor(lerp(color1.r, color2.r, t)),
        g = math.floor(lerp(color1.g, color2.g, t)),
        b = math.floor(lerp(color1.b, color2.b, t))
    }
end

-- Get color from 3-point gradient based on position t [0, 1]
function color.getGradientColor(colors, t)
    assert(type(colors) == "table" and #colors == 3, "Expected table with 3 colors")
    t = math.max(0, math.min(1, t)) -- Clamp t to [0, 1]
    
    if t <= 0.5 then
        -- Interpolate between first and second color
        local localT = t * 2 -- Map [0, 0.5] to [0, 1]
        return color.interpolate(colors[1], colors[2], localT)
    else
        -- Interpolate between second and third color  
        local localT = (t - 0.5) * 2 -- Map [0.5, 1] to [0, 1]
        return color.interpolate(colors[2], colors[3], localT)
    end
end

-- Interpolate between two 3-point gradients
function color.interpolateGradients(gradient1, gradient2, t)
    assert(type(gradient1) == "table" and #gradient1 == 3, "Expected gradient1 with 3 colors")
    assert(type(gradient2) == "table" and #gradient2 == 3, "Expected gradient2 with 3 colors") 
    t = math.max(0, math.min(1, t)) -- Clamp t to [0, 1]
    
    local interpolatedGradient = {}
    for i = 1, 3 do
        interpolatedGradient[i] = color.interpolate(gradient1[i], gradient2[i], t)
    end
    
    return interpolatedGradient
end

return color