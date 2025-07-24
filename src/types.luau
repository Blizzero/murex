export type CommandArgument<T> = {
    name: string,
    optional: boolean,
    transform: (string) -> T,
}

return {}