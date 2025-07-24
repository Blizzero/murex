local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Murex = require(ReplicatedStorage.Packages.Murex)
local opt = Murex.args.optional

-- Murex.registerCommand("printf", {
--     description = "printf in luau!",
--     arguments = function()
--         return margs.string(), margs.string()
--     end,
--     callback = function()
        
--     end,
-- })

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

Murex.execute("add-optional 1 2")
Murex.execute("add-optional 1")