local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)
local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local validateArguments = require(script.validateArguments)
local validateAttack = require(script.validateAttack)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local function onHit(character: CharacterMesh)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        humanoid:TakeDamage(5)
    end
end

Remotes.NormalAttack.OnServerInvoke = function(player: Player, weapon: Tool, charactersInHitbox: { CharacterMesh }): any
	if not validateArguments(weapon, charactersInHitbox) then return end
	if not validateAttack(weapon, player) then return end

	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	
	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, function()  onHit(targetCharacter) end)
		end
	end
	CooldownModule
		.new(player.UserId, "NormalAttack", 0.5)
		:create()
end
