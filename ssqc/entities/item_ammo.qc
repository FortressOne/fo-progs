class item_ammo_c : item_c
{
    string big_model;
    string small_model;
    float big_amount;
    float small_amount;

    void () item_ammo_c =
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
            precache_model(small_model);
            setmodel(self, small_model);
            this.aflag = small_amount;
        }
        setsize (self, '0 0 0', '32 32 56');
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
            if (player.ammunition_shells >= player.tf_class.max_shells)
                return;
            player.ammunition_shells = player.ammunition_shells + self.aflag;
        }

        // spikes
        if (self.weapon == 2)
        {
            if (player.ammunition_nails >= player.tf_class.max_nails)
                return;
            player.ammunition_nails = player.ammunition_nails + self.aflag;
        }

        //      rockets
        if (self.weapon == 3)
        {
            if (player.ammunition_rockets >= player.tf_class.max_rockets)
                return;
            player.ammunition_rockets = player.ammunition_rockets + self.aflag;
        }

        //      cells
        if (self.weapon == 4)
        {
            if (player.ammunition_cells >= player.tf_class.max_cells)
                return;
            player.ammunition_cells = player.ammunition_cells + self.aflag;
        }
       
        sprint(player, PRINT_LOW, "You got the ", self.netname, "\n");

        // ammo touch sound
        sound(player, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
        stuffcmd(player, "bf\n");

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

class item_shells : item_ammo_c
{
    void () item_shells =
    {
        big_model = "maps/b_shell1.bsp";
        small_model = "maps/b_shell0.bsp";
        big_amount = 40;
        small_amount = 20;
        netname = "shells";
        weapon = 1;
    };
};

class item_spikes : item_ammo_c
{
    void () item_spikes =
    {
        big_model = "maps/b_nail1.bsp";
        small_model = "maps/b_nail0.bsp";
        big_amount = 50;
        small_amount = 25;
        netname = "nails";
        weapon = 2;
    };
};

class item_rockets : item_ammo_c
{
    void () item_rockets =
    {
        big_model = "maps/b_rock1.bsp";
        small_model = "maps/b_rock0.bsp";
        big_amount = 10;
        small_amount = 5;
        netname = "rockets";
        weapon = 3;
    };
};

class item_cells : item_ammo_c
{
    void () item_cells =
    {
        big_model = "maps/b_batt1.bsp";
        small_model = "maps/b_batt0.bsp";
        big_amount = 12;
        small_amount = 6;
        netname = "cells";
        weapon = 4;
    };
};