local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxHandler = require(ServerScriptService.Core.systems.combat.handlers.HitboxHandler)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local function handleDamage(character: CharacterMesh)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        humanoid:TakeDamage(5)
    end
end

Remotes.NormalAttack.OnServerInvoke = function(player: Player, charactersInHitbox: { CharacterMesh }): any
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, handleDamage(targetCharacter))
		end
	end
end
