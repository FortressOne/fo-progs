class supershotgun_c : shotgun_c 
{
    void () supershotgun_c =
    {
        shoot_sound = "weapons/shotgn2.wav";
        spread = '0.14 0.08 0';
        shot_count = 14;
        weapon = IT_SUPER_SHOTGUN;
        ammo_type = IT_SHELLS;
        weaponmodel = "progs/v_shot2.mdl";
    };

    virtual void () Attack =
    {
        super::Attack();
        if (this.owner.currentammo == 1)
        {
            shoot_sound = "weapons/guncock.wav";
            spread = '0.04 0.04 0';
            shot_count = 6;
            shotgun_c::Attack();
            return;
        }

        sound(this.owner ,CHAN_WEAPON, shoot_sound, 1, ATTN_NORM); 

        msg_entity = this.owner;
        WriteByte(MSG_ONE, SVC_BIGKICK);
        
        if (deathmatch != 4)
            this.owner.currentammo = this.owner.ammo_shells = this.owner.ammo_shells - 2;
        vector dir = aim(this.owner, 100000);
        FireBullets(shot_count, dir, spread);

    };
};