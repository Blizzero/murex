local types = require("./types")

local commands: { [string]: Command<...any> } = {}
local argTypes = {}

local function parse(s: string): {
    command: string?,
    args: { string },
}
    local tokens: { string } = {}
    local token = ""

    local function is_quote(c: string): boolean
        return c == "'" or c == '"'
    end

    local function quoted_string(c: string)
        if #token == 0 then
            token ..= "'"
        elseif is_quote(token:sub(1, 1)) then
            table.insert(tokens, token:sub(2))
            token = ""
        else
            token ..= c
        end
    end

    for _, c in s:split("") do
        if c == " " then
            if is_quote(token:sub(1, 1)) then
                token ..= c
            elseif #token > 0 then
                table.insert(tokens, token)
                token = ""
            end
        elseif is_quote(c) then
            quoted_string(c)
        else
            token ..= c
        end
    end

    if #token > 0 then
        table.insert(tokens, token)
    end

    local cmd = table.remove(tokens, 1)
    return {
        command = cmd,
        args = tokens,
    }
end

local function execute(s: string)
    local data = parse(s)

    assert(data.command, "No command provided.")
    local command = commands[data.command]

    local requiredArgs = 0
    for _, arg in command.args do
        if arg.optional == false then
            requiredArgs += 1
        end
    end

    if #data.args < requiredArgs then
        error(`Invalid args count: got {#data.args}, expected at least {requiredArgs}`)
    end

    local args = {}
    for i = 1, #command.args do
        local raw = data.args[i]
        table.insert(args, command.args[i].transform(raw))
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
    parse = parse,
}