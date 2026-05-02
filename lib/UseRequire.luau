--!nocheck

local function UseRequire(script: ModuleScript): any
	return require(script)
end

return UseRequire
