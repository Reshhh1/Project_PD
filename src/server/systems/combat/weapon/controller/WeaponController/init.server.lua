local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)

local validateArguments = require(script.validateArguments)
local validateAttack = require(script.validateAttack)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local function handleDamage(character: CharacterMesh)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        humanoid:TakeDamage(5)
    end
end

Remotes.NormalAttack.OnServerInvoke = function(player: Player, charactersInHitbox: { CharacterMesh }): any
	if not validateAttack(player) then return end
	if not validateArguments(charactersInHitbox) then return end

	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	
	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, function()  handleDamage(targetCharacter) end)
		end
	end
end
