local WeaponType = require(script.Parent.Parent.types.WeaponTypes)

local WeaponController = script.Parent.Parent.controller.WeaponController

local WeaponConfigHandler = {}

function WeaponConfigHandler.getConfigByWeaponName(name: string)
    for _, module in pairs(WeaponController:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end
        if module.Name == name then
            local weaponConfig = require(module.Config)
            return weaponConfig
        end
    end
    return nil
end

--[[
    This method can only be used to get information of a move.
    Things like normal attack, heavy attack ect.

    @author Reshwan
--]]
function WeaponConfigHandler.getCombatMoveConfig(weaponName: string, action: string): WeaponType.WeaponMoveType | nil
    local toolConfig = WeaponConfigHandler.getConfigByWeaponName(weaponName)
    if toolConfig then
        for _, config in pairs(toolConfig.COMBAT) do
            if config.NAME == action then
                return config
            end
        end
    end
    return nil
end

return WeaponConfigHandler