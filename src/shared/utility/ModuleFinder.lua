local ModuleFinder = {}

function ModuleFinder.findModuleByName(name: string, container: Instance)
    for _, module in pairs(container:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end
        if module.Name == name then
            local weaponConfig = require(module.Config)
            return weaponConfig
        end
    end
    return nil
end

return ModuleFinder