export type LoggerOptions = {
	Scope: string?,
	Level: number?,
}

export type Logger = {
	Scope: (self: Logger, name: string) -> Logger,
	Fatal: (self: Logger, fmt: string, ...any) -> (),
	Error: (self: Logger, fmt: string, ...any) -> (),
	Warn: (self: Logger, fmt: string, ...any) -> (),
	Info: (self: Logger, fmt: string, ...any) -> (),
	Debug: (self: Logger, fmt: string, ...any) -> (),
}

return nil
