local Log = require(script.Log)
local Service = require(script.Service)
local UseRequire = require(script.UseRequire)

local services: { { any } } = {}
local isRunning = false

local Loom = {}

export type ServiceTable = Service.Table
export type EventHandler = Service.EventHandler

function Loom.CreateService(table: ServiceTable)
	if isRunning then
		Log.Warn("failed to create service: loom is already running")
		return
	end

	Service.Create(table)
end

function Loom.IsServiceStarted(service: ServiceTable)
	return Service.IsStarted(service)
end

local function connectLifecycleTrigger(table: ServiceTable, trigger: Service.Trigger, func: Service.EventHandler)
	if isRunning then
		Log.Warn("failed to add service event: loom is already running")
		return
	end

	Service.On(table, trigger, func)
end

function Loom.OnStart(table: ServiceTable, func: Service.EventHandler)
	connectLifecycleTrigger(table, Service.Start, func)
end

function Loom.OnStop(table: ServiceTable, func: Service.EventHandler)
	connectLifecycleTrigger(table, Service.Stop, func)
end

function Loom.AddSource(source: Instance)
	if isRunning then
		Log.Warn("failed to add source: loom is already running")
		return
	end

	if source:IsA("ModuleScript") then
		local module = UseRequire(source)

		if not Service.IsService(module) then
			Log.Warn("failed to add source: module is not a valid loom service, did you forget `Loom.CreateService()`?")
			return
		end

		table.insert(services, module)
	end

	for _, child in ipairs(source:GetChildren()) do
		Loom.AddSource(child)
	end
end

function Loom.Run()
	if isRunning then
		Log.Warn("failed to run loom: loom is already running")
		return
	end

	isRunning = true

	for _, service in ipairs(services) do
		Service.Trigger(service, Service.Start)
	end
end

function Loom.Terminate()
	if not isRunning then
		Log.Warn("failed to terminate loom: loom is not running")
		return
	end

	isRunning = false

	for _, service in ipairs(services) do
		Service.Trigger(service, Service.Stop)
	end
end

function Loom.IsRunning()
	return isRunning
end

return Loom
