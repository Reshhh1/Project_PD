local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)
local Config = require(script.Config)

local CooldownRemote = ReplicatedStorage.Core.remotes.isOnCooldown
local ComboCountRemote = ReplicatedStorage.Core.remotes.getComboCount
local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local LocalPlayer = Players.LocalPlayer
local Animations = script.Animations

local FistController = {}
FistController.__index = FistController

FistController.WeaponName = "Fist"

function FistController.new(tool: Tool)
    local self = setmetatable({
        tool = tool,
        equipped = false,
        debounce = false,
		skillDebounce = false,
		equipTrack = nil :: AnimationTrack | nil
    }, FistController)
    return self
end

function FistController:equip()
	self.equipped = true
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
	local animator = humanoid.Animator :: Animator
	if animator then
		self.equipTrack = humanoid.Animator:LoadAnimation(script.Animations.Equip)
		self.equipTrack.Priority = Enum.AnimationPriority.Action
		-- self.equipTrack:Play()
	end
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
	handleWeaponMoves(self, input)
	handleSpecialMoves(self, input)
end

function handleWeaponMoves(self, input: InputObject)
		if input.UserInputType.Value == Enum.UserInputType.MouseButton1.Value and not self.debounce then
		self.debounce = true
		normalAttackRequest(self.tool)
		self.debounce = false
	end
end

function handleSpecialMoves(self, input: InputObject)
	for _, move in pairs(self.tool.Moves:GetChildren()) do
		if not move:IsA("StringValue") then continue end
		if input.KeyCode.Name == move.Value and not self.skillDebounce then
			self.skillDebounce = true
			print("E")
			WeaponRemotes.WeaponAttack:InvokeServer({ weapon = self.tool, action = move.Name, attackType = Config.BASIC_ATTACK.ATTACK_TYPE }, { charactersInHitbox = {}})
			self.skillDebounce = false
		end
	end
end

function createHitbox(root: Part): HitboxModule.HitboxModel
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }
	return HitboxModule.new()
		:setSize(Config.BASIC_ATTACK.HITBOX_SIZE)
		:setPosition(root.CFrame * Config.BASIC_ATTACK.HITBOX_OFFSET)
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

function normalAttackRequest(tool: Tool)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local isOnCooldown = CooldownRemote:InvokeServer("Basic attack")
	
	if not isOnCooldown then
		local comboCount = ComboCountRemote:InvokeServer()
		local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
		local animator = humanoid:FindFirstChild("Animator") :: Animator

		local animation = Animations[`Attack_{comboCount}`]
		local animationTrack = animator:LoadAnimation(animation)
		animationTrack:Play()
		animationTrack:AdjustSpeed(1.2)

		animationTrack:GetMarkerReachedSignal("impact"):Connect(function()
			local clientHitbox = createHitbox(humanoidRootPart)
			local result = clientHitbox:getHitResults()
			WeaponRemotes.WeaponAttack:InvokeServer({ weapon = tool, action = Config.BASIC_ATTACK.NAME, attackType = Config.BASIC_ATTACK.ATTACK_TYPE }, { charactersInHitbox = result})
		end)
		animationTrack.Stopped:Wait()
		task.wait(Config.BASIC_ATTACK.COOLDOWNS.client)
	end
end

return FistController