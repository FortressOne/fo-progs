class proj_c : entity
{
    vector direction;
    float speed;
    float speed_vertical;
    float nextthink_interval;
    float damage_bonus; // FIXME - when will default values on consts be fixed?
    float damage;

    void () proj_c =
    {
        if (!owner)
        {
            bprint(PRINT_HIGH, "owner on ", this.classname, " not set!\n");
            remove(this);
            return;
        }
        
        solid = SOLID_BBOX;

        switch (this.movetype)
        {
            case MOVETYPE_FLYMISSILE:
                angles = vectoangles(direction);
                velocity = direction * speed;
                break;
            case MOVETYPE_BOUNCE:
                makevectors(this.owner.v_angle);
                if (this.owner.v_angle_x)
                    this.velocity = v_forward*speed + v_up * speed_vertical + crandom()*v_right*10 + crandom()*v_up*10;
                else
                {
                    this.velocity = direction * speed;
                    this.velocity_z = speed_vertical;
                }

                this.avelocity = '300 300 300';
                this.angles = vectoangles(this.velocity);
                break;
        }

        setmodel(this, model);
        setsize(this, VEC_ORIGIN, VEC_ORIGIN);
        setorigin(this, origin);
        nextthink = time + nextthink_interval;
    };

    virtual void () Explode =
    {
        if (this.voided) 
        {
            return;
        }
        this.voided = TRUE;
        
        // don't do radius damage to the other, because all the damage
        // was done in the impact
        T_RadiusDamage(this, this.owner, (this.damage + this.damage_bonus), other);

        this.origin = this.origin - 8 * normalize(this.velocity);

        te_explosion(this.origin);
        remove(this);
    };
};