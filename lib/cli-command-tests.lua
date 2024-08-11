local cli = require("lib/cli-command")

local tests = {
    parse = function()
        local args = {"arg1", "arg2", "arg3"}
        local result = cli.buildCommandString(args)
        assert(result == "arg1 arg2 arg3", "Expected 'arg1 arg2 arg3', got "..result)
    end,
    getSwitch = function()
        assert(cli.getSwitch("-b", "b", "black"), "Expected b to be set. b was not set") 
        local commandString = "-a -bc --long --typooo"
        assert(cli.getSwitch(commandString, "a", "aaa"), "Expected a to be set. a was not set")
        assert(cli.getSwitch(commandString, "b", "bbb"), "Expected b to be set. b was not set")
        assert(cli.getSwitch(commandString, "c", "ccc"), "Expected c to be set. c was not set")
        assert(cli.getSwitch(commandString, "l", "long"), "Expected long to be set. long was not set")
        assert(not cli.getSwitch(commandString, "d", "ddd"), "Expected d to not be set. d was set")
        assert(not cli.getSwitch(commandString, "t", "typo"), "Expected typo to not be set. typo was set")
        assert(cli.getSwitch(commandString, "t", "typooo"), "Expected typooo to be set. typooo was not set")
    end,
    getArgument = function()
        local commandString = "-a value -bc -d 1 -e -0.4 --long longvalue --typooo=typovalue -q \"some quoted' value\" -s 'another quoted\" value'"
        assert(cli.getArgument(commandString, "a", "aaa") == "value", "Expected 'value', got "..tostring(cli.getArgument(commandString, "a", "aaa")))
        assert(cli.getArgument(commandString, "b", "bbb") == true, "Expected true, got "..tostring(cli.getArgument(commandString, "b", "bbb")))
        assert(cli.getArgument(commandString, "c", "ccc") == true, "Expected true, got "..tostring(cli.getArgument(commandString, "c", "ccc")))
        assert(cli.getArgument(commandString, "d", "ddd") == "1", "Expected '1', got "..tostring(cli.getArgument(commandString, "d", "ddd")))
        assert(cli.getArgument(commandString, "e", "eee") == "-0.4", "Expected -0.4, got "..tostring(cli.getArgument(commandString, "e", "eee")))
        assert(cli.getArgument(commandString, "l", "long") == "longvalue", "Expected 'longvalue', got "..tostring(cli.getArgument(commandString, "l", "long")))
        assert(cli.getArgument(commandString, "t", "typo") == nil, "Expected nil, got "..tostring(cli.getArgument(commandString, "t", "typo")))
        assert(cli.getArgument(commandString, "q", "quoted") == "some quoted' value", "Expected 'some quoted' value', got "..tostring(cli.getArgument(commandString, "q", "quoted")))
        assert(cli.getArgument(commandString, "s", "singlequoted") == "another quoted\" value", "Expected 'another quoted\" value', got "..tostring(cli.getArgument(commandString, "s", "singlequoted")))
    end
}

return tests
