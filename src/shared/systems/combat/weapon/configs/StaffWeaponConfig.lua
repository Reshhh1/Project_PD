local WeaponConfig = script.Parent.Parent.types.WeaponTypes

local SPEAR_ID = "WSP"
return {
	{
		ID = SPEAR_ID .. "1",
		BASE_INFO = {
			NAME = "Basic Staff",
		},
		COMBAT = {
			NORMAL_ATTACK = {
                NAME = "Basic attack",
				BASE_DAMAGE = { 50, 5, 5, 5, 10},
				COOLDOWNS = { 0.5, 0.5, 0.5, 0.5, 2},
				HITBOX_SIZE = Vector3.new(6, 6, 6),
				HITBOX_OFFSET = CFrame.new(0, 0, -3),
			},
            HEAVY_ATTACK = {
                NAME = "Heavy attack",
				BASE_DAMAGE = 5,
				COOLDOWNS = 0.5,
				HITBOX_SIZE = Vector3.new(6, 6, 6),
				HITBOX_OFFSET = CFrame.new(0, 0, -3),
			}
		},
	},
	{
		ID = SPEAR_ID .. "2",
		BASE_INFO = {
			NAME = "Bo Staff",
		},
		COMBAT = {
			NORMAL_ATTACK = {
                NAME = "Basic attack",
				BASE_DAMAGE = { 5, 5, 5, 5, 10},
				COOLDOWNS = { 0.5, 0.5, 0.5, 0.5, 2},
				HITBOX_SIZE = Vector3.new(6, 6, 6),
				HITBOX_OFFSET = CFrame.new(0, 0, -3),
			},
		},
	},
}
