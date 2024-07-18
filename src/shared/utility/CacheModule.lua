local CacheModule = {}

function CacheModule.loadModules(pathToModules: any, requiredProperty)
    local modules = {}
    for _, module: ModuleScript in pairs(pathToModules:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end
        local requiredModule = require(module)
        modules[requiredModule[requiredProperty]] = requiredModule
    end
    return modules
end

return CacheModule