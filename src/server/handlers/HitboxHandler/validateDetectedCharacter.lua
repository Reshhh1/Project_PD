local function validateDetectedCharacter(targetCharacter: CharacterMesh)
    local isValid = typeof(targetCharacter) == "Instance" and targetCharacter:IsA("Model")
    return isValid
end

return function(character: CharacterMesh): boolean
    return validateDetectedCharacter(character)
end