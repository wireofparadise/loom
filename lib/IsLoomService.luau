local function IsLoomService(target: any): boolean
	return typeof(target) == "table" and typeof(target.OnInit) == "function" and typeof(target.OnStart) == "function"
end

return IsLoomService
