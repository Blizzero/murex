local arguments = require("@self/arguments")
local console = require("@self/console")
local net = require("@self/net")

local RunService = game:GetService("RunService")

if RunService:IsServer() then
    net.server.init()
else
    net.client.init()
end

return {
    invokeCommand = net.client.invokeCommand,

    execute = console.execute,
    registerCommand = console.registerCommand,
    registerType = console.registerType,
    args = arguments,
}