local commands: { [string]: Command<...any> } = {}
local types = {}

local function execute(s: string)
    local tokens = s:split(" ")
    local cmd = tokens[1]

    assert(cmd, "No command provided.")

    local command = commands[cmd]

    local args = {}
    for i = 2, #cmd do
        local token = tokens[i]
        table.insert(args, command.args[i - 1].transform(token))
    end

    command.callback(table.unpack(args))
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
    assert(types[name] == nil, `Cannot register type: type by name '{name}' already exists.`)
    types[name] = props

    return function(): T
        return {
            name = name,
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

type CommandArgument<T> = {
    name: string,
    transform: (string) -> T,
}

type Command<T...> = {
    callback: (T...) -> ... any,
    args: { CommandArgument<any> },
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