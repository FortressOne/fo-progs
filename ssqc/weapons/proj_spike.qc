#define PROJ_SPIKE_CLASSNAME "spike"
#define PROJ_SPIKE_MODEL "progs/spike.mdl"
#define PROJ_SPIKE_DURATION 6

class proj_spike_c : proj_c
{
    static proj_spike_c (vector org, vector dir, entity own) spawn =
    {
        proj_spike_c ent = (proj_spike_c)super::spawn(org, dir, own, PROJ_SPIKE_CLASSNAME, PROJ_SPIKE_MODEL, PROJ_SPIKE_DURATION);
        return ent;
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