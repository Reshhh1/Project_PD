local module = {}

export type WeaponConfigType = {
    BASE_INFO: { ID: string, NAME: string },
    [string]: WeaponMoveType
}

export type WeaponMoveType = {NAME: string, BASE_DAMAGE: {}, COOLDOWNS: { server: {}, client: {}}, HITBOX_SIZE: Vector3, HITBOX_OFFSET: CFrame }
export type WeaponAction = { weapon: Tool, action: string, attackType: string }

return module
