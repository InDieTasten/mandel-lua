local color = require("lib/color")

local tests = {}

function tests.parseHex()
    local red = color.parseHex("FF0000")
    assert(red.r == 255 and red.g == 0 and red.b == 0, "Red parsing failed")
    
    local green = color.parseHex("00FF00")
    assert(green.r == 0 and green.g == 255 and green.b == 0, "Green parsing failed")
    
    local blue = color.parseHex("0000FF")
    assert(blue.r == 0 and blue.g == 0 and blue.b == 255, "Blue parsing failed")
    
    local white = color.parseHex("#FFFFFF")
    assert(white.r == 255 and white.g == 255 and white.b == 255, "White parsing failed")
    
    local black = color.parseHex("000000")
    assert(black.r == 0 and black.g == 0 and black.b == 0, "Black parsing failed")
end

function tests.interpolate()
    local red = {r = 255, g = 0, b = 0}
    local blue = {r = 0, g = 0, b = 255}
    
    local mid = color.interpolate(red, blue, 0.5)
    assert(mid.r == 127 and mid.g == 0 and mid.b == 127, "Mid interpolation failed")
    
    local start = color.interpolate(red, blue, 0)
    assert(start.r == 255 and start.g == 0 and start.b == 0, "Start interpolation failed")
    
    local end_color = color.interpolate(red, blue, 1)
    assert(end_color.r == 0 and end_color.g == 0 and end_color.b == 255, "End interpolation failed")
end

function tests.getGradientColor()
    local red = {r = 255, g = 0, b = 0}
    local green = {r = 0, g = 255, b = 0}
    local blue = {r = 0, g = 0, b = 255}
    local gradient = {red, green, blue}
    
    local start = color.getGradientColor(gradient, 0)
    assert(start.r == 255 and start.g == 0 and start.b == 0, "Gradient start failed")
    
    local mid = color.getGradientColor(gradient, 0.5)
    assert(mid.r == 0 and mid.g == 255 and mid.b == 0, "Gradient mid failed")
    
    local end_color = color.getGradientColor(gradient, 1)
    assert(end_color.r == 0 and end_color.g == 0 and end_color.b == 255, "Gradient end failed")
    
    local quarter = color.getGradientColor(gradient, 0.25)
    assert(quarter.r == 127 and quarter.g == 127 and quarter.b == 0, "Gradient quarter failed")
end

return tests