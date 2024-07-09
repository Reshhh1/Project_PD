local ServerScriptService = game:GetService("ServerScriptService")

local validateInstance = require(ServerScriptService.Core.utility.typevalidation.validateInstance)

local function validateArguments(weapon, charactersInHitbox): boolean
    if typeof(charactersInHitbox) ~= "table" then
        return false
    end
    
    if validateInstance(weapon, "Tool") then
        return false
    end
    return true
end

return validateArguments