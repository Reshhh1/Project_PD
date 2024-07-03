local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local HitboxModule = require(ReplicatedStorage.Core.combat.modules.HitboxModule)

local Remotes = ReplicatedStorage.Core.combat.systems.weapon.remotes
local LocalPlayer = Players.LocalPlayer

local WeaponController = {}
WeaponController.__index = WeaponController

export type CombatController = typeof(setmetatable(
	{} :: {
		tool: Tool,
		debounce: boolean,
		equipped: boolean,
		connections: table,
	},
	WeaponController
))

function WeaponController.new(tool: Tool): CombatController
	local self = setmetatable({
		tool = tool,
		debounce = false,
		equipped = false,
		connections = {},
	}, WeaponController)
	self:init()
	return self
end

function WeaponController.init(self: CombatController)
	self:_addConnection(self.tool.Equipped:Connect(function()
		self:_equip()
	end))
	self:_addConnection(self.tool.Unequipped:Connect(function()
		self:_unEquip()
	end))
	self:_addConnection(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		self:_attack(input, gameProcessedEvent)
	end))
end

function WeaponController._attack(self: CombatController, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.debounce then
		self.debounce = true
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local hitbox = getHitbox(humanoidRootPart)
			normalAttackRequest(hitbox)
		end
		task.wait(0.6)
		self.debounce = false
	end
end

function WeaponController._heavyAttack() end

function WeaponController.destroy(self: CombatController)
	self:_unEquip()
	for _, connection: RBXScriptConnection in pairs(self.connections) do
		connection:Disconnect()
	end
end

function WeaponController._equip(self: CombatController)
	self.equipped = true
end

function WeaponController._unEquip(self: CombatController)
	self.equipped = false
end

function WeaponController._addConnection(self: CombatController, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

function getHitbox(root: Part)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }
	return HitboxModule.new()
		:setSize(Vector3.new(6, 6, 6))
		:setPosition(root.CFrame * CFrame.new(0,0,-3))
		:makeVisible()
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

function normalAttackRequest(hitbox)
	local success, error = pcall(function()
		return Remotes.NormalAttack:InvokeServer(hitbox:getHitResults())
	end)
	if success then
		print(success)
	else
		warn(error)	
	end	
end

return WeaponController
