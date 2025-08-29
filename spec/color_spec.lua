local color = require("lib/color")

describe("Color operations", function()
    describe("parseHex", function()
        it("should parse basic color hex values", function()
            local red = color.parseHex("FF0000")
            assert.are.equal(255, red.r)
            assert.are.equal(0, red.g)
            assert.are.equal(0, red.b)
            
            local green = color.parseHex("00FF00")
            assert.are.equal(0, green.r)
            assert.are.equal(255, green.g)
            assert.are.equal(0, green.b)
            
            local blue = color.parseHex("0000FF")
            assert.are.equal(0, blue.r)
            assert.are.equal(0, blue.g)
            assert.are.equal(255, blue.b)
        end)

        it("should handle hex values with # prefix", function()
            local white = color.parseHex("#FFFFFF")
            assert.are.equal(255, white.r)
            assert.are.equal(255, white.g)
            assert.are.equal(255, white.b)
        end)

        it("should parse black correctly", function()
            local black = color.parseHex("000000")
            assert.are.equal(0, black.r)
            assert.are.equal(0, black.g)
            assert.are.equal(0, black.b)
        end)
    end)

    describe("interpolate", function()
        local red = {r = 255, g = 0, b = 0}
        local blue = {r = 0, g = 0, b = 255}

        it("should interpolate between colors at midpoint", function()
            local mid = color.interpolate(red, blue, 0.5)
            assert.are.equal(127, mid.r)
            assert.are.equal(0, mid.g)
            assert.are.equal(127, mid.b)
        end)

        it("should return start color at t=0", function()
            local start = color.interpolate(red, blue, 0)
            assert.are.equal(255, start.r)
            assert.are.equal(0, start.g)
            assert.are.equal(0, start.b)
        end)

        it("should return end color at t=1", function()
            local end_color = color.interpolate(red, blue, 1)
            assert.are.equal(0, end_color.r)
            assert.are.equal(0, end_color.g)
            assert.are.equal(255, end_color.b)
        end)
    end)

    describe("getGradientColor", function()
        local red = {r = 255, g = 0, b = 0}
        local green = {r = 0, g = 255, b = 0}
        local blue = {r = 0, g = 0, b = 255}
        local gradient = {red, green, blue}

        it("should return first color at start", function()
            local start = color.getGradientColor(gradient, 0)
            assert.are.equal(255, start.r)
            assert.are.equal(0, start.g)
            assert.are.equal(0, start.b)
        end)

        it("should return middle color at midpoint", function()
            local mid = color.getGradientColor(gradient, 0.5)
            assert.are.equal(0, mid.r)
            assert.are.equal(255, mid.g)
            assert.are.equal(0, mid.b)
        end)

        it("should return last color at end", function()
            local end_color = color.getGradientColor(gradient, 1)
            assert.are.equal(0, end_color.r)
            assert.are.equal(0, end_color.g)
            assert.are.equal(255, end_color.b)
        end)

        it("should interpolate correctly at quarter point", function()
            local quarter = color.getGradientColor(gradient, 0.25)
            assert.are.equal(127, quarter.r)
            assert.are.equal(127, quarter.g)
            assert.are.equal(0, quarter.b)
        end)
    end)
end)