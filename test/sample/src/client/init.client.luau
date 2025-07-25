local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Murex = require(ReplicatedStorage.Packages.Murex)

local channel: TextChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
channel.MessageReceived:Connect(function(msg: TextChatMessage)
    print(`Invoking server with: {msg.Text}`)
    Murex.invokeCommand(msg.Text)
end)