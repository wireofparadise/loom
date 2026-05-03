local LogLevels = require(script.Logging.LogLevels)
local Logger = require(script.Logging.Logger)
local LoggingTypes = require(script.Logging.LoggingTypes)

local Loom = {}

Loom.LogLevels = LogLevels

export type Logger = LoggingTypes.Logger
export type LoggerOptions = LoggingTypes.LoggerOptions

local logger: LoggingTypes.Logger? = nil

function Loom.ConfigureLogger(options: LoggerOptions?)
	logger = Logger.new(options)
end

function Loom.Fatal(fmt: string, ...)
	assert(logger ~= nil, "logger has not been configured, did you forget 'Loom.configureLogger'?")
	logger:Fatal(fmt, ...)
end

function Loom.Error(fmt: string, ...)
	assert(logger ~= nil, "logger has not been configured, did you forget 'Loom.configureLogger'?")
	logger:Error(fmt, ...)
end

function Loom.Warn(fmt: string, ...)
	assert(logger ~= nil, "logger has not been configured, did you forget 'Loom.configureLogger'?")
	logger:Warn(fmt, ...)
end

function Loom.Info(fmt: string, ...)
	assert(logger ~= nil, "logger has not been configured, did you forget 'Loom.configureLogger'?")
	logger:Info(fmt, ...)
end

function Loom.Debug(fmt: string, ...)
	assert(logger ~= nil, "logger has not been configured, did you forget 'Loom.configureLogger'?")
	logger:Debug(fmt, ...)
end

return Loom
