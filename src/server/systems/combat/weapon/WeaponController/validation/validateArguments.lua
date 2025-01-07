local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local validateInstance = require(ServerScriptService.Core.utility.typevalidation.validateInstance)

local function validateArguments(weaponAction: WeaponTypes.WeaponAction, args: {}): boolean
    if typeof(args) ~= "table" then
        warn(`{tostring(args)} isn't of type table`)
        return false
    end

    if not validateInstance(weaponAction.weapon, "Tool") then
        warn(`Invalid tool`)
        return false
    end

    if typeof(weaponAction.action) ~= "string" then
        warn(`weaponAction.action isn't of type string`)
        return false    
    end

    return true
end

return validateArguments