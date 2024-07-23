local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

LocalPlayer.CharacterAdded:Connect(function(character: any)
    print("WERKT")
    character.ChildAdded:Connect(function(addedChild: any)
        print("ADDED")
        if addedChild:IsA("Tool") and addedChild:FindFirstChild("BodyAttach") then
            print("real")
            character.Torso.ToolGrip.Part1 = addedChild.BodyAttach
        end
    end)
end)