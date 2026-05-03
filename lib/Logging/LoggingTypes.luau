export type LoggerOptions = {
	Scope: string?,
	Level: number?,
}

export type LoggerClass = {
	_logLevel: number,
	_scope: string?,

	__index: LoggerClass,
	new: (options: LoggerOptions?) -> Logger,

	Scope: (self: Logger, name: string) -> Logger,

	Fatal: (self: Logger, fmt: string, ...any) -> (),
	Error: (self: Logger, fmt: string, ...any) -> (),
	Warn: (self: Logger, fmt: string, ...any) -> (),
	Info: (self: Logger, fmt: string, ...any) -> (),
	Debug: (self: Logger, fmt: string, ...any) -> (),
}

export type Logger = typeof(setmetatable({} :: LoggerClass, {} :: { __index: LoggerClass }))

return nil
