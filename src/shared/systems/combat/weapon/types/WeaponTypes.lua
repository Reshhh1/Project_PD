local module = {}

export type WeaponConfigType = {
    BASE_INFO: { ID: string, NAME: string },
    COMBAT: { 
        [string]: WeaponMoveType
    }
}

export type WeaponMoveType = {NAME: string, BASE_DAMAGE: number, COOLDOWNS: number, HITBOX_SIZE: Vector3, HITBOX_OFFSET: CFrame }

return module
