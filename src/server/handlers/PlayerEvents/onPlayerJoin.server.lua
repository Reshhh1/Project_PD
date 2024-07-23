local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player: Player)
    print("Test")
    player.CharacterAdded:Connect(function(character: any)
        local weld = Instance.new("Motor6D")
        weld.Part0 = character.Torso
        weld.Name = "ToolGrip"
        weld.Parent = weld.Part0
        character.ChildAdded:Connect(function(addedChild: any)
            if addedChild:IsA("Tool") and addedChild:FindFirstChild("BodyAttach") then
                weld.Part1 = addedChild.BodyAttach
            end
        end)
    end)
end)