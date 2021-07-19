#define PROJ_ROCKET_CLASSNAME "rocket"
#define PROJ_ROCKET_MODEL "progs/missile.mdl"
#define PROJ_ROCKET_DURATION 5

class proj_rocket_c : proj_c
{
    static proj_rocket_c (vector org, vector dir, entity own) spawn =
    {
        proj_rocket_c ent = (proj_rocket_c)super::spawn(org, dir, own, PROJ_ROCKET_CLASSNAME, PROJ_ROCKET_MODEL, PROJ_ROCKET_DURATION);
        return ent;
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
            T_Damage (other, this, this.owner, damg );
        }

        // don't do radius damage to the other, because all the damage
        // was done in the impact
        T_RadiusDamage (this, this.owner, 120, other, "rocket");

        this.origin = this.origin - 8 * normalize(this.velocity);

        WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
        WriteByte (MSG_MULTICAST, TE_EXPLOSION);
        WriteCoord (MSG_MULTICAST, this.origin_x);
        WriteCoord (MSG_MULTICAST, this.origin_y);
        WriteCoord (MSG_MULTICAST, this.origin_z);
        multicast (this.origin, MULTICAST_PHS);

        remove(this);
    };
};