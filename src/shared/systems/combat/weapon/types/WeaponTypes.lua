local module = {}

export type WeaponConfigType = {
    BASE_INFO: { ID: string, NAME: string },
    COMBAT: { 
        NORMAL_ATTACK: WeaponMoveType ,
        HEAVY_ATTACK: WeaponMoveType  
    }
}

export type WeaponMoveType = {NAME: string, BASE_DAMAGE: number, COOLDOWNS: number, HITBOX_SIZE: Vector3, HITBOX_OFFSET: CFrame }

return module
