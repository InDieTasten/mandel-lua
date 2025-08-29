local cli = require("lib/cli-command")

describe("CLI command parsing", function()
    it("should build command string from arguments", function()
        local args = {"arg1", "arg2", "arg3"}
        local result = cli.buildCommandString(args)
        assert.are.equal("arg1 arg2 arg3", result)
    end)

    describe("getSwitch", function()
        it("should detect switches correctly", function()
            assert.is_truthy(cli.getSwitch("-b", "b", "black"))
        end)

        it("should parse complex command strings correctly", function()
            local commandString = "-a -bc --long --typooo"
            assert.is_truthy(cli.getSwitch(commandString, "a", "aaa"))
            assert.is_truthy(cli.getSwitch(commandString, "b", "bbb"))
            assert.is_truthy(cli.getSwitch(commandString, "c", "ccc"))
            assert.is_truthy(cli.getSwitch(commandString, "l", "long"))
            assert.is_falsy(cli.getSwitch(commandString, "d", "ddd"))
            assert.is_falsy(cli.getSwitch(commandString, "t", "typo"))
            assert.is_truthy(cli.getSwitch(commandString, "t", "typooo"))
        end)
    end)

    describe("getArgument", function()
        local commandString = "-a value -bc -d 1 -e -0.4 --long longvalue --typooo=typovalue -q \"some quoted' value\" -s 'another quoted\" value'"

        it("should parse simple arguments", function()
            assert.are.equal("value", cli.getArgument(commandString, "a", "aaa"))
            assert.are.equal("1", cli.getArgument(commandString, "d", "ddd"))
            assert.are.equal("longvalue", cli.getArgument(commandString, "l", "long"))
        end)

        it("should handle switches without values as true", function()
            assert.are.equal(true, cli.getArgument(commandString, "b", "bbb"))
            assert.are.equal(true, cli.getArgument(commandString, "c", "ccc"))
        end)

        it("should handle negative numbers", function()
            assert.are.equal("-0.4", cli.getArgument(commandString, "e", "eee"))
        end)

        it("should handle quoted values", function()
            assert.are.equal("some quoted' value", cli.getArgument(commandString, "q", "quoted"))
            assert.are.equal("another quoted\" value", cli.getArgument(commandString, "s", "singlequoted"))
        end)

        it("should return nil for non-existent arguments", function()
            assert.is_nil(cli.getArgument(commandString, "t", "typo"))
        end)
    end)
end)