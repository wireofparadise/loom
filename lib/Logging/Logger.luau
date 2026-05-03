local LogLevels = require(script.Parent.LogLevels)
local LoggingTypes = require(script.Parent.LoggingTypes)

local Logger = {} :: LoggingTypes.LoggerClass
Logger.__index = Logger

function Logger.new(options: LoggingTypes.LoggerOptions?): LoggingTypes.Logger
	local self: LoggingTypes.Logger = setmetatable({}, Logger) :: any

	self._logLevel = if options and options.Level ~= nil then options.Level else LogLevels.Info
	self._scope = if options and options.Scope then options.Scope else nil

	return self
end

local function getLogLevelName(logLevel: number): string
	if logLevel >= LogLevels.Debug then
		return "debug"
	elseif logLevel >= LogLevels.Info then
		return "info"
	elseif logLevel >= LogLevels.Warn then
		return "warn"
	elseif logLevel >= LogLevels.Error then
		return "error"
	elseif logLevel >= LogLevels.Fatal then
		return "fatal"
	else
		return "unknown"
	end
end

local function getLogFunction(logLevel: number): (message: string) -> ()
	if logLevel <= LogLevels.Fatal then
		return error
	elseif logLevel <= LogLevels.Warn then
		return warn
	else
		return print
	end
end

local function log(self: LoggingTypes.Logger, message: string, level: number)
	if level > self._logLevel then
		return
	end

	local formattedMessage = if self._scope
		then string.format("[%s] [%s]: %s", getLogLevelName(level), self._scope, message)
		else string.format("[%s]: %s", getLogLevelName(level), message)

	getLogFunction(level)(formattedMessage)
end

function Logger:Scope(name: string): LoggingTypes.Logger
	return Logger.new({
		Scope = name,
		Level = self._logLevel,
	})
end

function Logger:Fatal(fmt: string, ...: any)
	log(self, string.format(fmt, ...), LogLevels.Fatal)
end

function Logger:Error(fmt: string, ...: any)
	log(self, string.format(fmt, ...), LogLevels.Error)
end

function Logger:Warn(fmt: string, ...: any)
	log(self, string.format(fmt, ...), LogLevels.Warn)
end

function Logger:Info(fmt: string, ...: any)
	log(self, string.format(fmt, ...), LogLevels.Info)
end

function Logger:Debug(fmt: string, ...: any)
	log(self, string.format(fmt, ...), LogLevels.Debug)
end

return Logger
