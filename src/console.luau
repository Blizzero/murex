local types = require("./types")

local commands: { [string]: Command<...any> } = {}
local argTypes = {}

local function execute(s: string)
    local tokens = s:split(" ")
    local cmd = tokens[1]

    assert(cmd, "No command provided.")

    local command = commands[cmd]

    local args = {}
    for i = 1, #command.args do
        local token = tokens[i + 1]
        table.insert(args, command.args[i].transform(token))
    end

    return command.callback(table.unpack(args))
end

local function registerType<T>(
    name: string,
    props: {
        transform: (string) -> T,
        analysis: {
            optional: boolean,
        }
    }
)
    assert(argTypes[name] == nil, `Cannot register type: type by name '{name}' already exists.`)
    argTypes[name] = props

    return function(): T
        return {
            name = name,
            optional = props.analysis.optional,
            transform = props.transform,
        } :: any
    end
end

type CommandProps<T...> = {
    description: string?,
    permissions: { string }?,
    arguments: () -> T...,
    callback: (T...) -> ...any,
}

type Command<T...> = {
    callback: (T...) -> ... any,
    args: { types.CommandArgument<any> },
}

local function registerCommand<T...>(name: string, props: CommandProps<T...>)
    assert(commands[name] == nil, `Cannot register command: command by name '{name}' already exists.`)
    
    local args = { props.arguments() }

    commands[name] = {
        callback = props.callback,
        args = args,
    }
end

return {
    registerCommand = registerCommand,
    registerType = registerType,
    execute = execute,
}