local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local validateArguments = require(script.validation.validateArguments)
local validateAttack = require(script.validation.validateAttack)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local function initilizeSkill(player: Player, action: string, charactersInHitbox: { Model }, config)
	for _, module in pairs(script.moves:GetChildren()) do
		if not module:IsA("ModuleScript") then return end
		module = require(module)
		if module.MoveName and module.MoveName == action and module.init then
			module.init(player, charactersInHitbox, config)
		end
	end
end

Remotes.WeaponAttack.OnServerInvoke = function(player: Player, weapon: Tool, action: string, charactersInHitbox: { Model }): any
	if not validateArguments(weapon, action, charactersInHitbox) then return end
	if not validateAttack(weapon, player, action) then return end
	
	local config = WeaponConfigHandler.getCombatMoveConfig(weapon.Name, action)
	if not config then return end

	initilizeSkill(player, action, charactersInHitbox, config)
end
