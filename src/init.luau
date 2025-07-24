local arguments = require("@self/arguments")
local console = require("@self/console")

return {
    execute = console.execute,
    registerCommand = console.registerCommand,
    registerType = console.registerType,
    args = arguments,
}