return {
    BASE_INFO = {
        NAME = "Fist",
    },
    COMBAT = {
        NORMAL_ATTACK = {
            NAME = "Basic attack",
            BASE_DAMAGE = { 5, 5, 5, 5, 10},
            COOLDOWNS = {
                server = { 0.3, 0.3, 0.3, 0.3, 1.5 }
            },
            HITBOX_SIZE = Vector3.new(6, 6, 6),
            HITBOX_OFFSET = CFrame.new(0, 0, -3),
        }
    }
}
