local types = require("./types")
local console = require("./console")

local numberT = {
    transform = tonumber :: (<T>(T) -> number),
    analysis = {
        optional = false,
    }
}

-- local stringT = {
--     transform = tostring,
--     analysis = {
--         optional = false,
--     }
-- }

-- local booleanT = {
--     transform = function()
        
--     end,
--     analysis = {
--         optional = false,
--     }
-- }

local function optional<T>(argument: T): T?
    local a: types.CommandArgument<T> = argument :: any
    a.optional = true
    return a :: any
end

return {
    optional = optional,

    number = console.registerType("number", numberT),
    -- string = console.registerType("string", stringT),
    -- boolean = console.registerType("boolean", booleanT),
}