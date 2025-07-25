local args = require("../murex/arguments")
local console = require("../murex/console")

local opt = args.optional

console.registerCommand("add", {
    description = "basic addition operator",
    permissions = {},
    arguments = function()
        return args.number(), args.number()
    end,
    callback = function(a, b)
        return a + b
    end,
})

do
    assert(console.execute("add 1 2") == 3)
end

console.registerCommand("add-optional", {
    description = "basic addition operator",
    permissions = {},
    arguments = function()
        return args.number(), opt(args.number())
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
    assert(console.execute("add-optional 7") == 7)
    assert(console.execute("add-optional 29 5") == 34)
end

console.registerCommand("add-return", {
    description = "basic addition operator and returns result",
    permissions = {},
    arguments = function()
        return args.number(), args.number()
    end,
    callback = function(a, b)
        return a + b
    end,
})

do
    assert(console.execute("add-return 5 3") == 8)
end

console.registerCommand("concat", {
    description = "concatenmates two strings",
    permissions = {},
    arguments = function()
        return args.string(), args.string()
    end,
    callback = function(a, b)
        return a .. b
    end,
})

-- basic strings
do
    assert(console.execute("concat foo bar") == "foobar")
end

-- quotes
do
    assert(console.execute("concat foo bar") == "foobar")
    assert(console.execute("concat 'foo' 'bar'") == "foobar")
    assert(console.execute("concat 'foo bar' 'hello world'") == "foo barhello world")
end


console.registerCommand("is-truthy", {
    description = "determines if a boolean is truthy",
    permissions = {},
    arguments = function()
        return args.boolean()
    end,
    callback = function(a)
        return a == true
    end,
})

do
    assert(console.execute("is-truthy false") == false)
    assert(console.execute("is-truthy true") == true)
end