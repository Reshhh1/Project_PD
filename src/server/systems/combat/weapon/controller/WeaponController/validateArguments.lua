local function validateArguments(charactersInHitbox): boolean
    if typeof(charactersInHitbox) ~= "table" then
        return false
    end
    
    return true
end

return validateArguments