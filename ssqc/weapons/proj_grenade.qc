class proj_grenade_c : proj_c
{
    void () proj_grenade_c =
    {
        classname = "grenade";
        model = MODELS::GRENADE;
        movetype = MOVETYPE_BOUNCE;
        nextthink_interval = 2.5;
        speed = 600;
        speed_vertical = 200;
        damage = 120;
        skin = 1;
        direction = aim(this.owner, 10000);
    };

    virtual void () touch =
    {
        if (other == this.owner)
            return;
        if (other.takedamage == DAMAGE_AIM)
        {
            this.Explode();
            return;
        }
        sound(this, CHAN_WEAPON, SOUNDS::BOUNCE, 1, ATTN_NORM);
        if (this.velocity == '0 0 0')
            this.avelocity = '0 0 0';
    };

    virtual void () think =
    {
        this.Explode();
    };
};