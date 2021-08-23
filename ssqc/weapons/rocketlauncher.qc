class rocketlauncher_c : weapon_c
{
    void () rocketlauncher_c = 
    {
        classname = "player_rocketlauncher";
        netname = "Rocket Launcher";
        shoot_sound = SOUNDS::ROCKETLAUNCHER_SHOOT;
        weapon = IT_ROCKET_LAUNCHER; // hud
        weapon_type = WEAPON::ROCKETLAUNCHER;
        ammo_type = IT_ROCKETS;
        weaponmodel = MODELS::VIEW_ROCKETLAUNCHER;
        attack_finish_delay = .8;
        animation_func = player_rocket1;
        ammo_per_shot = 1;
        clip_size = 4;
        reload_time = 5;
    };

    virtual float () Attack =
    {           
        if(!super::Attack())
            return FALSE;

        msg_entity = this.owner;
        WriteByte (MSG_ONE, SVC_SMALLKICK);

        makevectors(this.owner.v_angle);
        vector org = this.owner.origin + v_forward*8 + '0 0 16';
        vector dir = aim(this.owner, 1000)
        proj_rocket_c ent = ::spawn(proj_rocket_c, origin: org, direction: dir, owner: this.owner);

        return TRUE;
    };
};