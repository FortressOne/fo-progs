class grenadelauncher_c : weapon_c
{
    void () grenadelauncher_c = 
    {
        shoot_sound = SOUNDS::GRENADELAUNCHER_SHOOT;
        weapon = IT_GRENADE_LAUNCHER; // hud
        weapon_type = WEAPON::GRENADELAUNCHER;
        ammo_type = IT_ROCKETS;
        weaponmodel = MODELS::VIEW_GRENADELAUNCHER;
        attack_finish_delay = .6;
        animation_func = player_rocket1;
        ammo_per_shot = 1;
        clip_size = 6;
        reload_time = 4;
    };

    virtual float () Attack =
    {           
        if(!super::Attack())
            return FALSE;

        msg_entity = this.owner;
        WriteByte (MSG_ONE, SVC_SMALLKICK);

        switch (this.weapon_type)
        {
            case WEAPON::GRENADELAUNCHER:
                proj_grenade_c ent = ::spawn(proj_grenade_c, origin: this.owner.origin, owner: this.owner);
                break;
            case WEAPON::PIPEBOMBLAUNCHER:
                proj_pipebomb_c ent2 = ::spawn(proj_pipebomb_c, origin: this.owner.origin, owner: this.owner);
                break;
        }

        return TRUE;
    };
};