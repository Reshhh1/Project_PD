local CacheModule = {}

function CacheModule.loadModules(pathToModules: any)
    local modules = {}
    for _, module: ModuleScript in pairs(pathToModules:GetChildren()) do
		if not module:IsA("ModuleScript") then continue end
        local requiredModule = require(module)
        if requiredModule then
            modules[module.Name] = requiredModule
        end
    end
    return modules
end

return CacheModule