local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleFinder = require(ReplicatedStorage.Core.utility.ModuleFinder)

local TechniqueContainer = script.Parent.Parent.controllers.TechniqueController

local ModuleContainer = {}

local TechniqueConfigHandler = {}

function TechniqueConfigHandler.getByName(name: string)
    if not ModuleContainer[name] then
        ModuleContainer[name] = require(ModuleFinder.findModuleByName(name, TechniqueContainer).Config)
    end
    return ModuleContainer[name]
end

return TechniqueConfigHandler