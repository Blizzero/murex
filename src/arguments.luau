local console = require("./console")

local numberT = {
    transform = tonumber :: (<T>(T) -> number),
    analysis = {
        optional = false,
    }
}

return {
    -- string = console.registerType("string", stringT)
    number = console.registerType("number", numberT),
}