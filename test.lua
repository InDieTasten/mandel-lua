-- Grab all tests
local complexTests = require("lib/complex-tests")
local allTests = complexTests

-- Run tests
print("Running "..#allTests.." tests...")
local passed = 0
local failed = 0
for name, test in pairs(allTests) do
    io.write("Running test "..name.."... ")
    local success, err = pcall(test)
    if success then
        print("Passed!")
        passed = passed + 1
    else
        print("Failed: "..err)
        failed = failed + 1
    end
end

print("Tests passed: "..passed..", failed: "..failed)