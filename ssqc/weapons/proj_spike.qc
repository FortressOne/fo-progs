class proj_spike_c : proj_c
{
    void () proj_spike_c =
    {
        classname = "spike";
        model = MODELS::SPIKE;
        nextthink_interval = 6;
        speed = 1500;
        think = SUB_Remove;
        movetype = MOVETYPE_FLYMISSILE;
        damage = 9;
    };

    virtual void () touch =
    {
        if (other == this.owner)
		    return;

        if (this.voided) 
            return;
        
        this.voided = 1;

        if (other.solid == SOLID_TRIGGER)
            return; // trigger field, do nothing

        if (pointcontents(this.origin) == CONTENT_SKY)
        {
            remove(this);
            return;
        }
        
    // hit something that bleeds
        if (other.takedamage)
        {
            spawn_touchblood(this.damage);
            other.deathtype = "nail";
            T_Damage(other, this, this.owner, this.damage, DAMAGE::NOTTEAM, DAMAGETYPE::NAIL);
        }
        else
        {
            WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
            if (this.classname == "wizspike")
                WriteByte (MSG_MULTICAST, TE_WIZSPIKE);
            else if (this.classname == "knightspike")
                WriteByte (MSG_MULTICAST, TE_KNIGHTSPIKE);
            else
                WriteByte (MSG_MULTICAST, TE_SPIKE);
            WriteCoord (MSG_MULTICAST, this.origin_x);
            WriteCoord (MSG_MULTICAST, this.origin_y);
            WriteCoord (MSG_MULTICAST, this.origin_z);
            multicast (this.origin, MULTICAST_PHS);
        }

        remove(this);

    };
};