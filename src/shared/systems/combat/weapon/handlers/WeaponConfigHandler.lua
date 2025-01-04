local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleFinder = require(ReplicatedStorage.Core.utility.ModuleFinder)

local WeaponContainer = script.Parent.Parent.WeaponController
local SpecialMovesContainer = script.Parent.Parent.SpecialMoves

local WeaponConfigHandler = {}

function WeaponConfigHandler.getWeaponConfigByName(name: string)
    return ModuleFinder.findModuleByName(name, WeaponContainer)
end

function WeaponConfigHandler.getDefaultWeaponMoveConfigByName(weaponName: string, moveName: string)
    local config = ModuleFinder.findModuleByName(weaponName, WeaponContainer) or {}
    if config then
        for _, key in pairs(config) do
            if not key.NAME then return end
            if key.NAME == moveName then
                return key
            end
        end
    end
    return nil
end

function WeaponConfigHandler.getSpecialWeaponMoveConfigByName(name: string)
    return ModuleFinder.findModuleByName(name, SpecialMovesContainer)
end

return WeaponConfigHandler