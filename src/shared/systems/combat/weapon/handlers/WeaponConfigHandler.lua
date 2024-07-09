local WeaponType = require(script.Parent.Parent.types.WeaponTypes)

local WeaponConfigs = script.Parent.Parent.configs

local WeaponConfigHandler = {}

function WeaponConfigHandler.getConfigByWeaponName(name: string)
    for _, module in pairs(WeaponConfigs:GetChildren()) do
        if not module:IsA("ModuleScript") then continue end
        local weaponConfigs = require(module)
        return getConfigByKey(name, weaponConfigs)
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

function getConfigByKey(keyName: string, configs: any)
    for _, itemConfig: WeaponType.WeaponConfigType in pairs(configs) do
        local name = itemConfig.BASE_INFO.NAME
        if not name then continue end
        if name == keyName then 
            return itemConfig
        end
    end
end

return WeaponConfigHandler