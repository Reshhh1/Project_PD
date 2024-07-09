local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)
local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local validateArguments = require(script.validateArguments)
local validateAttack = require(script.validateAttack)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local function onHit(character: CharacterMesh, damage: number)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        humanoid:TakeDamage(damage)
    end
end

Remotes.WeaponAttack.OnServerInvoke = function(player: Player, weapon: Tool, action: string, charactersInHitbox: { CharacterMesh }): any
	if not validateArguments(weapon, action, charactersInHitbox) then return end
	if not validateAttack(weapon, player) then return end

	local config = WeaponConfigHandler.getCombatMoveConfig(weapon.Name, action)
	if not config then return end

	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	
	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, function()  onHit(targetCharacter, config.BASE_DAMAGE) end)
		end
	end
	CooldownModule
		.new(player.UserId, config.NAME, 0.5)
		:create()
end
