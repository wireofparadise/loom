export type ServiceClass = {
	__index: ServiceClass,
	new: () -> Service,

	__isInitialized: boolean,
	__isStarted: boolean,
	__methodRegistry: { string },

	AddMethod: (self: Service, name: string, func: (self: Service, ...any) -> any) -> (),
	RemoveMethod: (self: Service, name: string) -> (),

	OnInit: (self: Service) -> (),
	OnStart: (self: Service) -> (),
	OnStop: (self: Service) -> (),
}

export type Service = typeof(setmetatable({} :: ServiceClass, {} :: any))

return nil
