local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local HitboxModule = require(ReplicatedStorage.Core.combat.module.HitboxModule)

local LocalPlayer = Players.LocalPlayer

local CombatController = {}
CombatController.__index = CombatController

export type CombatController = typeof(setmetatable(
	{} :: {
		tool: Tool,
		debounce: boolean,
		equipped: boolean,
		connections: table,
	},
	CombatController
))

function CombatController.new(tool: Tool): CombatController
	local self = setmetatable({
		tool = tool,
		debounce = false,
		equipped = false,
		connections = {},
	}, CombatController)
	self:init()
	return self
end

function CombatController.init(self: CombatController)
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

function CombatController._attack(self: CombatController, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.debounce then
		self.debounce = true
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local hitbox = CombatController._getHitbox(humanoidRootPart)
			local test = hitbox:getHitResults()
			print(test)
		end
		task.wait(0.6)
		self.debounce = false
	end
end

function CombatController._heavyAttack() end

function CombatController.destroy(self: CombatController)
	self:_unEquip()
	for _, connection: RBXScriptConnection in pairs(self.connections) do
		connection:Disconnect()
	end
end

function CombatController._equip(self: CombatController)
	self.equipped = true
end

function CombatController._unEquip(self: CombatController)
	self.equipped = false
end

function CombatController._addConnection(self: CombatController, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

function CombatController._getHitbox(root: Part)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }
	return HitboxModule.new()
		:setSize(Vector3.new(6, 6, 6))
		:setPosition(root.CFrame)
		:makeVisible()
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

return CombatController
