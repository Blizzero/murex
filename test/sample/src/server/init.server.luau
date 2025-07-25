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
        return a + b
    end,
})

do
    assert(Murex.execute("add 1 2") == 3)
end

Murex.registerCommand("add-optional", {
    description = "basic addition operator",
    permissions = {},
    arguments = function()
        return Murex.args.number(), opt(Murex.args.number())
    end,
    callback = function(a, b)
        if b == nil then
            return a
        else
            return a + b
        end
    end,
})

do
    assert(Murex.execute("add-optional 7") == 7)
    assert(Murex.execute("add-optional 29 5") == 34)
end

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
    assert(Murex.execute("add-return 5 3") == 8)
end

Murex.registerCommand("concat", {
    description = "concatenmates two strings",
    permissions = {},
    arguments = function()
        return Murex.args.string(), Murex.args.string()
    end,
    callback = function(a, b)
        return a .. b
    end,
})

do
    assert(Murex.execute("concat foo bar") == "foobar")
end

Murex.registerCommand("is-truthy", {
    description = "determines if a boolean is truthy",
    permissions = {},
    arguments = function()
        return Murex.args.boolean()
    end,
    callback = function(a)
        return a == true
    end,
})

do
    assert(Murex.execute("is-truthy false") == false)
    assert(Murex.execute("is-truthy true") == true)
end

do
    assert(Murex.execute("concat foo bar") == "foobar")
    assert(Murex.execute("concat 'foo' 'bar'") == "foobar")
    assert(Murex.execute("concat 'foo bar' 'hello world'") == "foo barhello world")
end
