class proj_rocket_c : proj_c
{
    void () proj_rocket_c =
    {
        classname = "rocket";
        model = MODELS::ROCKET;
        duration = 5;
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

        float damg = 100 + random()*20;
        
        if (other.health)
        {
            other.deathtype = "rocket";
            T_Damage(other, this, this.owner, damg, DAMAGE::NOTTEAM, DAMAGETYPE::EXPLOSION);
        }

        // don't do radius damage to the other, because all the damage
        // was done in the impact
        T_RadiusDamage(this, this.owner, 120, other);

        this.origin = this.origin - 8 * normalize(this.velocity);

        te_explosion(this.origin);
        remove(this);
    };
};