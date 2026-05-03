local ComponentLifecycle = require(script.Components.ComponentLifecycle)
local UseRequire = require(script.Components.UseRequire)
local LogLevels = require(script.Logging.LogLevels)
local Logger = require(script.Logging.Logger)
local LoggingTypes = require(script.Logging.LoggingTypes)

local logger = (Logger.new() :: any) :: Logger
local components: { ComponentLifecycle.Component } = {}
local isStarted = false

local Loom = {}

-- Component lifecycle

export type Component = ComponentLifecycle.Component
export type EventHandler = ComponentLifecycle.EventHandler

function Loom.OnStart(component: Component, handler: EventHandler)
	ComponentLifecycle.On(component, ComponentLifecycle.Events.Start, handler)
end

function Loom.OnStop(component: Component, handler: EventHandler)
	ComponentLifecycle.On(component, ComponentLifecycle.Events.Stop, handler)
end

function Loom.AddSource(source: Instance)
	assert(not isStarted, "attempted to add source while loom is already started")

	if source:IsA("ModuleScript") then
		local component = UseRequire(source)

		if ComponentLifecycle.IsValidComponent(component) then
			table.insert(components, component)
		end
	end

	for _, child in ipairs(source:GetChildren()) do
		Loom.AddSource(child)
	end
end

function Loom.Start()
	assert(not isStarted, "attempted to start loom while it is already started")

	for _, component in ipairs(components) do
		ComponentLifecycle.Trigger(component, ComponentLifecycle.Events.Start)
	end
end

function Loom.Stop()
	assert(not isStarted, "attempted to stop loom while it is already stopped")

	for _, component in ipairs(components) do
		ComponentLifecycle.Trigger(component, ComponentLifecycle.Events.Stop)
	end
end

function Loom.IsStarted()
	return isStarted
end

-- Logging

Loom.LogLevels = LogLevels

export type Logger = LoggingTypes.Logger
export type LoggerOptions = LoggingTypes.LoggerOptions

function Loom.ConfigureLogger(options: LoggerOptions?)
	logger = Logger.new(options) :: any
end

function Loom.UseLogger(name: string?): Logger
	if name == nil then
		return logger
	else
		return logger:Scope(name)
	end
end

return Loom
