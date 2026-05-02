local Log = require(script.Log)
local Service = require(script.Service)
local Types = require(script.Types)
local UseRequire = require(script.UseRequire)
local IsLoomService = require(script.IsLoomService)

local Loom = {}

local isStarted = false
local loadedModules: { ModuleScript } = {}
local loadedServices: { Service } = {}

export type Service = Types.Service

function Loom.AddSource(source: Instance)
	if isStarted then
		Log.Warn("failed to add source: loom has already been started")
		return
	end

	if source:IsA("ModuleScript") then
		table.insert(loadedModules, source)
		return
	end

	for _, child in pairs(source:GetChildren()) do
		Loom.AddSource(child)
	end
end

function Loom.Start()
	if isStarted then
		Log.Warn("failed to start loom: loom has already been started")
		return
	end

	isStarted = true

	for i, module in ipairs(loadedModules) do
		local service: Service = UseRequire(module)

		if not IsLoomService(service) then
			Log.Warn(string.format("skipping module %s: invalid loom service", module.Name))
			continue
		end

		table.insert(loadedServices, service)
		loadedModules[i] = nil

		if not service.__isInitialized then
			Loom.InitService(service)
		end
	end

	for _, service in ipairs(loadedServices) do
		if not service.__isStarted then
			Loom.StartService(service)
		end
	end
end

function Loom.Stop()
	if not isStarted then
		Log.Warn("failed to stop loom: loom has already been stopped")
		return
	end

	for _, service in ipairs(loadedServices) do
		if service.__isStarted then
			Loom.StopService(service)
		end
	end
end

function Loom.IsStarted(): boolean
	return isStarted
end

function Loom.CreateService()
	return Service.new()
end

function Loom.InitService(service: Service)
	if service.__isInitialized then
		Log.Warn("failed to initialize service: service has already been initialized")
		return
	end

	service:OnInit()
	service.__isInitialized = true
end

function Loom.StartService(service: Service)
	if not service.__isInitialized then
		Log.Warn("failed to start service: service is not initialized")
		return
	end

	if service.__isStarted then
		Log.Warn("failed to start service: service has already been started")
		return
	end

	service:OnStart()
	service.__isStarted = true
end

function Loom.StopService(service: Service)
	if not service.__isStarted then
		Log.Warn("failed to stop service: service is not running")
		return
	end

	service:OnStop()
	service.__isStarted = false
end

return Loom
