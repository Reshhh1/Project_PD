local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleFinder = require(ReplicatedStorage.Core.utility.ModuleFinder)

local WeaponContainer = script.Parent.Parent.WeaponController
local SpecialMovesContainer = script.Parent.Parent.SpecialMoves

local ModuleContainer = {}

local WeaponConfigHandler = {}

function WeaponConfigHandler.getDefaultWeaponMoveConfigByName(weaponName: string, moveName: string)
    if not ModuleContainer[weaponName] then
        ModuleContainer[weaponName] = require(ModuleFinder.findModuleByName(weaponName, WeaponContainer).Config)
    end
    for _, key in pairs(ModuleContainer[weaponName]) do
        if not key.NAME then return end
        if key.NAME == moveName then
            return key
        end
    end
    return nil
end

function WeaponConfigHandler.getSpecialWeaponMoveConfigByName(name: string)
    if not ModuleContainer[name] then
        ModuleContainer[name] = ModuleFinder.findModuleByName(name, SpecialMovesContainer)
    end
    return ModuleContainer[name]
end

return WeaponConfigHandler