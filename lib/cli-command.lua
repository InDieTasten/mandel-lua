

local function buildCommandString(args)
    return table.concat(args, " ")
end

local function getSwitch(commandString, switch, switchLong)
    assert(type(commandString) == "string", "Expected string, got "..type(commandString))
    assert(type(switch) == "string", "Expected string, got "..type(switch))
    assert(type(switchLong) == "string", "Expected string, got "..type(switchLong))
    assert(#switch == 1, "Expected switch to be a single character, got "..#switch)
    assert(#switchLong > 0, "Expected switchLong to not be empty")

    local s, e
    s, e = string.find(commandString, "^%-%a*"..switch.."%a*%s")
    if s then
        return s, e
    end
    s, e = string.find(commandString, "^%-%a*"..switch.."%a*$")
    if s then
        return s, e
    end
    s, e = string.find(commandString, "%s%-%a*"..switch.."%a*%s")
    if s then
        return s, e
    end
    s, e = string.find(commandString, "%s%-%a*"..switch.."%a*$")
    if s then
        return s, e
    end
    s, e = string.find(commandString, "%-%-"..switchLong.."%s")
    if s then
        return s, e
    end
    s, e = string.find(commandString, "%-%-"..switchLong.."$")
    if s then
        return s, e
    end
    return false
end

local function getArgument(commandString, argument, argumentLong)
    assert(type(commandString) == "string", "Expected string, got "..type(commandString))
    assert(type(argument) == "string", "Expected string, got "..type(argument))
    assert(type(argumentLong) == "string", "Expected string, got "..type(argumentLong))
    assert(#argument == 1, "Expected argument to be a single character, got "..#argument)
    assert(#argumentLong > 0, "Expected argumentLong to not be empty")

    local _, argEnd = getSwitch(commandString, argument, argumentLong)
    if not argEnd then
        return nil
    end

    local _, _, normalValue = string.find(commandString,       "^%s+([^%-\"']%S*)", argEnd)
    local _, _, quotedValue = string.find(commandString,       "^%s+\"([^\"]*)\"", argEnd)
    local _, _, singleQuotedValue = string.find(commandString, "^%s+\'([^\']*)\'", argEnd)
    local _, _, negativeNumber = string.find(commandString,    "^%s+(%-[%d%.]+)", argEnd)

    return normalValue or quotedValue or singleQuotedValue or negativeNumber or true
end

return {
    buildCommandString = buildCommandString,
    getSwitch = getSwitch,
    getArgument = getArgument
}
