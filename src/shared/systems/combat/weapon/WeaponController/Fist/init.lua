local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local LocalPlayer = Players.LocalPlayer

local FistController = {}
FistController.__index = FistController

function FistController.new(tool: Tool)
    local self = setmetatable({
        tool = tool,
        equipped = false,
		equipTrack = nil :: AnimationTrack | nil
    }, FistController)
    return self
end

function FistController:equip()
	self.equipped = true
	-- local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	-- local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
	-- local animator = humanoid.Animator :: Animator
	-- if animator then
	-- 	self.equipTrack = humanoid.Animator:LoadAnimation(script.Animations.Equip)
	-- 	self.equipTrack.Priority = Enum.AnimationPriority.Action
	-- 	-- self.equipTrack:Play()
	-- end
end

function FistController:unEquip()
    self.equipped = false
	if self.equipTrack then
		-- self.equipTrack:Stop()
	end
end

function FistController.handleUserInput(self, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end

end

return FistController