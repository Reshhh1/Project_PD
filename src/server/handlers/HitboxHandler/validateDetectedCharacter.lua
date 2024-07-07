local function validateType(targetCharacter: CharacterMesh)
    local isValid = typeof(targetCharacter) == "Instance" and targetCharacter:IsA("Model")
    return isValid
end

local function validateHealth(targetCharacter: CharacterMesh)
    local humanoid = targetCharacter:FindFirstChild("Humanoid"):: Humanoid
    return humanoid ~= nil and humanoid.Health > 0 
end

return function(character: CharacterMesh): boolean
    return validateType(character) and validateHealth(character)
end