local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CacheModule = require(ReplicatedStorage.Core.utility.CacheModule)

local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local TechniqueCache = CacheModule.loadModules(script) 

local TechniqueController = {}
TechniqueController.__index = TechniqueController

function TechniqueController.new(tool)
    local self = setmetatable({
		tool = tool,
        debounce = false
    }, TechniqueController)
    return self
end

function TechniqueController:equip()
end

function TechniqueController:unEquip()
end

function TechniqueController:handleUserInput(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.toolController.equipped then
		return
	end
	for _, move in pairs(self.tool.Moves:GetChildren()) do
		if not move:IsA("StringValue") then continue end
		handleWeaponMoves(self, input, move)
		handleSpecialMoves(self, input, move)
	end
end

function handleWeaponMoves(self, input: InputObject, move)
	if input.UserInputType.Name == move.Value and not self.techniqueController.debounce then
		 if not TechniqueCache[move.Name] then return end
		 self.techniqueController.debounce = true
		TechniqueCache[move.Name].init(self.tool)
		task.wait(1) -- FIX THIS
		self.techniqueController.debounce = false
	end
end

function handleSpecialMoves(self, input: InputObject, move)
	if input.KeyCode.Name == move.Value and not self.techniqueController.debounce then
		self.techniqueController.debounce = true
		WeaponRemotes.WeaponAttack:InvokeServer({ weapon = self.tool, action = move.Name }, { charactersInHitbox = {}})
		task.wait(1) -- FIX THIS
		self.techniqueController.debounce = false
	end
end

return TechniqueController