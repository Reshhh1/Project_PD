local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TechniqueConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.TechniqueConfigHandler)
local CacheModule = require(ReplicatedStorage.Core.utility.CacheModule)
local validateArguments = require(script.validation.validateArguments)
local validateAttack = require(script.validation.validateAttack)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local MovesModules = CacheModule.loadModules(script.moves)

local function initializeSkill(player: Player, action: string, config: WeaponTypes.WeaponMoveType, args: {})
	local moveModule = MovesModules[action]
	if moveModule and moveModule.init then
		moveModule.init(player, config, args)
	else
		warn(`Action: {action}. Doesn't exists`)
	end
end

Remotes.WeaponAttack.OnServerInvoke = function(player: Player, weaponAction: WeaponTypes.WeaponAction, args: {})
	if not validateArguments(weaponAction, args) then return end
	if not validateAttack(weaponAction.weapon, player, weaponAction.action) then return end
	
	local config =  TechniqueConfigHandler.getByName(weaponAction.action)
	if not config then warn(`Weapon configuration not found for: {weaponAction.action}`) return end
	args["weapon"] = weaponAction.weapon 
	initializeSkill(player, weaponAction.action, config, args)
end
