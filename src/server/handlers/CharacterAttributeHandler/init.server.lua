local Players = game:GetService("Players")

local CharacterAttributes = require(script.CharacterAttributes)

Players.PlayerAdded:Connect(function(player: Player)
    player.CharacterAdded:Connect(function(character: Model)
        if character == nil then return end
        for attributeName, attributeValue in pairs(CharacterAttributes) do
            character:SetAttribute(attributeName, attributeValue)
        end
    end)
end)