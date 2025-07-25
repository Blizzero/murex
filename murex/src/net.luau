local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local console = require("./console")

local net = {
	client = {
        initialized = false,
    },
	server = {
        initialized = false,
    },
}

type RunContext = "server" | "client"

type RemoteIndex = {
    invokeCommand: RemoteEvent,
}

local runContext: RunContext = if RunService:IsServer() then "server" else "client"
local remotes: RemoteIndex

local function expectRunContext(expected: RunContext)
	assert(expected == runContext, `Expected run context {expected}, but got {runContext}.`)
end

function net.server.init()
	expectRunContext("server")

    local murexRemotes = Instance.new("Folder")
    murexRemotes.Name = "MUREX_NETWORKING"
    murexRemotes.Parent = ReplicatedStorage

    local function remote(name: string): RemoteEvent
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = murexRemotes
        return event
    end

    local remoteIndex: RemoteIndex = {
        invokeCommand = remote("invokeCommand"),
    }

    remoteIndex.invokeCommand.OnServerEvent:Connect(function(player: Player, s: string)  
        local result = console.execute(s)
        print(`Command received: {player}: {s} | output: {result}`)
    end)

    remotes = remoteIndex
    net.server.initialized = true
end

-- function net.server.commandInvoked(callback: (Player) -> ())
--     remotes.invokeCommand.OnServerEvent:Connect(callback)
-- end

function net.client.init() 
    expectRunContext("client")

    local murexRemotes = ReplicatedStorage:WaitForChild("MUREX_NETWORKING")

    local function remote(name: string): RemoteEvent
        return murexRemotes:WaitForChild(name) :: RemoteEvent
    end

    local remoteIndex: RemoteIndex = {
        invokeCommand = remote("invokeCommand"),
    }

    remotes = remoteIndex

    net.client.initialized = true
end

function net.client.invokeCommand(s: string)
    expectRunContext("client")

    remotes.invokeCommand:FireServer(s)
end

return net
