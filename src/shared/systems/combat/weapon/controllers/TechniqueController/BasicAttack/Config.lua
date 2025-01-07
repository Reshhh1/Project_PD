return {
    NAME = "BasicAttack",
    BASE_DAMAGE = { 5, 5, 5, 5, 10},
    COOLDOWNS = {
        server = { 0.1, 0.1, 0.1, 0.1, 1.5 },
        client = 0.1
    },
    HITBOX_SIZE = Vector3.new(6, 6, 6),
    HITBOX_OFFSET = CFrame.new(0, 0, -3)
}
