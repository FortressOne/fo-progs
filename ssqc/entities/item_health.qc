/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/
class item_health : item_c
{
    void () item_health =
    {
        if (this.spawnflags & H_ROTTEN)
        {
            precache_model("maps/b_bh10.bsp");
            precache_sound("items/r_item1.wav");
            setmodel(this, "maps/b_bh10.bsp");
            this.noise = "items/r_item1.wav";
            this.healamount = 15;
            this.healtype = 0;
        }
        else if (this.spawnflags & H_MEGA)
        {
            precache_model("maps/b_bh100.bsp");
            precache_sound("items/r_item2.wav");
            setmodel(this, "maps/b_bh100.bsp");
            this.noise = "items/r_item2.wav";
            this.healamount = 100;
            this.healtype = 2;
        }
        else
        {
            precache_model("maps/b_bh25.bsp");
            precache_sound("items/health1.wav");
            setmodel(this, "maps/b_bh25.bsp");
            this.noise = "items/health1.wav";
            this.healamount = 25;
            this.healtype = 1;
        }
        setsize(this, '0 0 0', '32 32 56');
    };

    // T_Heal: add health to an entity, limiting health to max_health
    // "ignore" will ignore max_health limit
    nonvirtual float (entity e, float healamount, float ignore) Heal =
    {
        if (e.health <= 0)
            return FALSE;
        if ((!ignore) && (e.health >= other.max_health))
            return FALSE;
        healamount = ceil(healamount);

        e.health = e.health + healamount;
        if ((!ignore) && (e.health >= other.max_health))
            e.health = other.max_health;
            
        if (e.health > 250)
            e.health = 250;
        return TRUE;
    };

    virtual void () touch =
    {
        if (deathmatch == 4)
            if (other.invincible_time > 0)
                return;

        if (other.classname != "player")
            return;
        
        if (this.healtype == 2) // Megahealth?  Ignore max_health...
        {
            if (other.health >= 250)
                return;
            if (!this.Heal(other, this.healamount, 1))
                return;
        }
        else
        {
            if (!this.Heal(other, this.healamount, 0))
                return;
        }
        
        sprint(other, PRINT_LOW, "You receive ", ftos(this.healamount), " health\n");
        
        // health touch sound
        sound(other, CHAN_ITEM, this.noise, 1, ATTN_NORM);

        stuffcmd (other, "bf\n");
        
        this.model = "";
        this.solid = SOLID_NOT;

        // Megahealth = rot down the player's super health
        if (this.healtype == 2)
        {
            other.items = other.items | IT_SUPERHEALTH;
            if (deathmatch != 4)
            {
                this.nextthink = time + 5;
                this.think = this.MegaHealthRot;
            }
            this.owner = other;
        }
        else
        {
            if (deathmatch != 2)            // deathmatch 2 is the silly old rules
            {
                this.nextthink = time + 20;
                this.think = this.Regen;
            }
        }
        
        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };

    nonvirtual void () MegaHealthRot =
    {
        other = this.owner;
	
        if (other.health > other.max_health)
        {
            other.health = other.health - 1;
            this.nextthink = time + 1;
            return;
        }

        // it is possible for a player to die and respawn between rots, so don't
        // just blindly subtract the flag off
        other.items = other.items - (other.items & IT_SUPERHEALTH);
        
        if (deathmatch != 2)    // deathmatch 2 is silly old rules
        {
            this.nextthink = time + 20;
            this.think = this.Regen;
        }
    };
};