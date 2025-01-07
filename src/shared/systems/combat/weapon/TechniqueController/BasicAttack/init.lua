local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)
local Config = require(script.Config)

local CooldownRemote = ReplicatedStorage.Core.remotes.isOnCooldown
local ComboCountRemote = ReplicatedStorage.Core.remotes.getComboCount
local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local LocalPlayer = Players.LocalPlayer
local Animations = script.Animations

local module = {}

function module.init(tool)
	normalAttackRequest(tool)
end

function createHitbox(root: Part): HitboxModule.HitboxModel
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }
	return HitboxModule.new()
		:setSize(Config.HITBOX_SIZE)
		:setPosition(root.CFrame * Config.HITBOX_OFFSET)
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
			WeaponRemotes.WeaponAttack:InvokeServer({ weapon = tool, action = Config.NAME }, { charactersInHitbox = result})
		end)
		animationTrack.Stopped:Wait()
		task.wait(Config.COOLDOWNS.client)
	end
end

return module