local Log = require(script.Log)
local Service = require(script.Service)
local UseRequire = require(script.UseRequire)

local services: { { any } } = {}
local isRunning = false

local Loom = {}

Loom.Init = Service.Init
Loom.Start = Service.Start
Loom.Stop = Service.Stop

function Loom.CreateService(table: any)
	if isRunning then
		Log.Warn("failed to create service: loom is already running")
		return
	end

	Service.Create(table)
end

function Loom.IsServiceInitialized(service: any)
	return Service.IsInitialized(service)
end

function Loom.IsServiceStarted(service: any)
	return Service.IsStarted(service)
end

function Loom.On(table: any, trigger: Service.Trigger, func: Service.EventHandler)
	if isRunning then
		Log.Warn("failed to add service event: loom is already running")
		return
	end

	Service.On(table, trigger, func)
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
		Service.Trigger(service, Service.Init)
	end

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
