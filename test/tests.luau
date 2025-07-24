local Murex = require("../src")
local opt = Murex.args.optional

Murex.registerCommand("add", {
    description = "basic addition operator",
    permissions = {},
    arguments = function()
        return Murex.args.number(), Murex.args.number()
    end,
    callback = function(a, b)
        print(a + b)
    end,
})

Murex.execute("add 1 2")

Murex.registerCommand("add-optional", {
    description = "basic addition operator",
    permissions = {},
    arguments = function()
        return Murex.args.number(), opt(Murex.args.number())
    end,
    callback = function(a, b)
        if b == nil then
            print(a)
        else
            print(a + b)
        end
    end,
})

Murex.execute("add-optional 7")
Murex.execute("add-optional 29 5")

Murex.registerCommand("add-return", {
    description = "basic addition operator and returns result",
    permissions = {},
    arguments = function()
        return Murex.args.number(), Murex.args.number()
    end,
    callback = function(a, b)
        return a + b
    end,
})

do
    local result = Murex.execute("add-return 5 3")
    assert(result == 8)
end
