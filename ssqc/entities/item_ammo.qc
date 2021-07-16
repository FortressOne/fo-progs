/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_shells =
{
	item_shells_c ent = (item_shells_c)self;
	ent.Process();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
	item_spikes_c ent = (item_spikes_c)self;
	ent.Process();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
	item_rockets_c ent = (item_rockets_c)self;
	ent.Process();
};

/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
	item_cells_c ent = (item_cells_c)self;
	ent.Process();
};

/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/
void() item_weapon =
{
    if (self.spawnflags & WEAPON_SHOTGUN)
    {
        item_shells();
    }
    else if (self.spawnflags & WEAPON_SPIKES)
    {
        item_spikes();
    }
    else if (self.spawnflags & WEAPON_ROCKET)
    {
        item_rockets();
    }
};

class item_ammo_c : item_c
{
    string big_model;
    string small_model;
    float big_amount;
    float small_amount;

    virtual void () Process =
    {
        if (deathmatch == 4)
		    return;

        if ((self.spawnflags & WEAPON_BIG2) || (self.spawnflags & WEAPON_BIG))
        {
            precache_model(big_model);
            setmodel (self, big_model);
            this.aflag = big_amount;
        }
        else
        {
            precache_model("maps/b_shell0.bsp");
            setmodel(self, "maps/b_shell0.bsp");
            this.aflag = small_amount;
        }
        setsize (self, '0 0 0', '32 32 56');
        item_c::Process();
    };

    virtual void () touch =
    {
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;

        player_c player = (player_c)other;

        // shotgun
        if (self.weapon == 1)
        {
            if (other.ammo_shells >= 100)
                return;
            other.ammo_shells = other.ammo_shells + self.aflag;
        }

        // spikes
        if (self.weapon == 2)
        {
            if (other.ammo_nails >= 200)
                return;
            other.ammo_nails = other.ammo_nails + self.aflag;
        }

        //      rockets
        if (self.weapon == 3)
        {
            if (other.ammo_rockets >= 100)
                return;
            other.ammo_rockets = other.ammo_rockets + self.aflag;
        }

        //      cells
        if (self.weapon == 4)
        {
            if (other.ammo_cells >= 100)
                return;
            other.ammo_cells = other.ammo_cells + self.aflag;
        }

        
        player.CheckMaxAmmo();
        
        sprint(other, PRINT_LOW, "You got the ", self.netname, "\n");

        // ammo touch sound
        sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
        stuffcmd (other, "bf\n");

        // change to a better weapon if appropriate
        player.current_weapon = player.GetBestWeapon();

        // remove it in single player, or setup for respawning in deathmatch
        self.model = "";
        self.solid = SOLID_NOT;
        if (deathmatch != 2)
            self.nextthink = time + 30;

        // Xian -- If playing in DM 3.0 mode, halve the time ammo respawns        
        if (deathmatch == 3 || deathmatch == 5)        
            self.nextthink = time + 15;

        self.think = this.Regen;

        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};

class item_shells_c : item_ammo_c
{
    virtual void () Process =
    {
        big_model = "maps/b_shell1.bsp";
        small_model = "maps/b_shell0.bsp";
        big_amount = 40;
        small_amount = 20;
        netname = "shells";
        weapon = 1;
        item_ammo_c::Process();
    };
};

class item_spikes_c : item_ammo_c
{
    virtual void () Process =
    {
        big_model = "maps/b_nail1.bsp";
        small_model = "maps/b_nail0.bsp";
        big_amount = 50;
        small_amount = 25;
        netname = "nails";
        weapon = 2;
        item_ammo_c::Process();
    };
};

class item_rockets_c : item_ammo_c
{
    virtual void () Process =
    {
        big_model = "maps/b_rock1.bsp";
        small_model = "maps/b_rock0.bsp";
        big_amount = 10;
        small_amount = 5;
        netname = "rockets";
        weapon = 3;
        item_ammo_c::Process();
    };
};

class item_cells_c : item_ammo_c
{
    virtual void () Process =
    {
        big_model = "maps/b_batt1.bsp";
        small_model = "maps/b_batt0.bsp";
        big_amount = 12;
        small_amount = 6;
        netname = "cells";
        weapon = 4;
        item_ammo_c::Process();
    };
};