class proj_rocket_c : proj_c
{
    void () proj_rocket_c =
    {
        classname = "rocket";
        model = MODELS::ROCKET;
        nextthink_interval = 5;
        speed = 1000;
        think = SUB_Remove;
        movetype = MOVETYPE_FLYMISSILE;
        damage = 100;
        damage_bonus = 20;
    };

    virtual void () touch =
    {
        if (other == this.owner)
            return;         // don't explode on owner

        if (this.voided) 
            return;
        
        this.voided = 1;

        if (pointcontents(this.origin) == CONTENT_SKY)
        {
            remove(this);
            return;
        }

        float damg = this.damage + random()*this.damage_bonus;
        
        if (other.health)
        {
            other.deathtype = "rocket";
            T_Damage(other, this, this.owner, damg, DAMAGE::NOTTEAM, DAMAGETYPE::EXPLOSION);
        }

        this.Explode();
    };
};