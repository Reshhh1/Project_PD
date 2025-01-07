local ModuleFinder = {}

function ModuleFinder.findModuleByName(name: string, container: Instance)
    for _, module in pairs(container:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end
        if module.Name == name then
            return module
        end
    end
    return nil
end

return ModuleFinder