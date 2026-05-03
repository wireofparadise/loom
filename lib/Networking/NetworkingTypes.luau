export type Signal<T> = {
	Connect: (self: Signal<T>, handler: T) -> SignalConnection,
}

export type SignalConnection = {
	Disconnect: (self: SignalConnection) -> (),
}

export type ServerRemoteHandler = (player: Player, ...any) -> () | any
export type ClientRemoteHandler = (...any) -> () | any

export type Remote = {
	Server: Signal<ServerRemoteHandler>,
	Client: Signal<ClientRemoteHandler>,
}

return nil
