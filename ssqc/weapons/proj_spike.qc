class proj_spike_c : proj_c
{
    void () proj_spike_c =
    {
        this.classname = "spike";
        this.model = "progs/spike.mdl";
        this.duration = 6;
    };

    virtual void (vector org, vector dir, entity own) Setup =
    {
        super::Setup(org, dir, own);
    };

    virtual void () touch =
    {
        if (other == self.owner)
		    return;

        if (self.voided) 
            return;
        
        self.voided = 1;

        if (other.solid == SOLID_TRIGGER)
            return; // trigger field, do nothing

        if (pointcontents(self.origin) == CONTENT_SKY)
        {
            remove(self);
            return;
        }
        
    // hit something that bleeds
        if (other.takedamage)
        {
            spawn_touchblood (9);
            other.deathtype = "nail";
            T_Damage (other, self, self.owner, 9);
        }
        else
        {
            WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
            if (self.classname == "wizspike")
                WriteByte (MSG_MULTICAST, TE_WIZSPIKE);
            else if (self.classname == "knightspike")
                WriteByte (MSG_MULTICAST, TE_KNIGHTSPIKE);
            else
                WriteByte (MSG_MULTICAST, TE_SPIKE);
            WriteCoord (MSG_MULTICAST, self.origin_x);
            WriteCoord (MSG_MULTICAST, self.origin_y);
            WriteCoord (MSG_MULTICAST, self.origin_z);
            multicast (self.origin, MULTICAST_PHS);
        }

        remove(self);

    };
};