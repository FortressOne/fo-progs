class item_weapon_c : item_c
{
    virtual void () touch =
    {
        if (!(other.flags & FL_CLIENT))
		return;

        player_c player = (player_c)other;
        if (!player.CanInteract())
            return;

        float w_switch = 8;
        if ((stof(infokey(player,"w_switch"))) == 0)
            w_switch = 8;
        else
            w_switch = stof(infokey(player,"w_switch"));
        
        float leave = FALSE;
        if (deathmatch == 2 || deathmatch == 3 || deathmatch == 5)
            leave = TRUE;
        
        float new = 0;
        if (self.classname == "weapon_nailgun")
        {
            if (leave && (player.items & IT_NAILGUN) )
                return;
            new = IT_NAILGUN;
            player.ammo_nails = player.ammo_nails + 30;
        }
        else if (self.classname == "weapon_supernailgun")
        {
            if (leave && (player.items & IT_SUPER_NAILGUN) )
                return;
            new = IT_SUPER_NAILGUN;
            player.ammo_nails = player.ammo_nails + 30;
        }
        else if (self.classname == "weapon_supershotgun")
        {
            if (leave && (player.items & IT_SUPER_SHOTGUN) )
                return;
            new = IT_SUPER_SHOTGUN;
            player.ammo_shells = player.ammo_shells + 5;
        }
        else if (self.classname == "weapon_rocketlauncher")
        {
            if (leave && (player.items & IT_ROCKET_LAUNCHER) )
                return;
            new = IT_ROCKET_LAUNCHER;
            player.ammo_rockets = player.ammo_rockets + 5;
        }
        else if (self.classname == "weapon_grenadelauncher")
        {
            if (leave && (player.items & IT_GRENADE_LAUNCHER) )
                return;
            new = IT_GRENADE_LAUNCHER;
            player.ammo_rockets = player.ammo_rockets + 5;
        }
        else if (self.classname == "weapon_lightning")
        {
            if (leave && (player.items & IT_LIGHTNING))
                return;
            new = IT_LIGHTNING;
            player.ammo_cells = player.ammo_cells + 15;
        }
        else
            objerror ("weapon_touch: unknown classname");

        sprint (player, PRINT_LOW, "You got the ", self.netname, "\n");
    // weapon touch sound
        sound (player, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
        stuffcmd (player, "bf\n");

        player.CheckMaxAmmo();

        player.items = player.items | new;

        if (leave)
            return;

        if (deathmatch!=3 || deathmatch !=5)
        {
        // remove it in single player, or setup for respawning in deathmatch
            self.model = "";
            self.solid = SOLID_NOT;
            if (deathmatch != 2)
                self.nextthink = time + 30;
            self.think = this.Regen;
        }
        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};

class weapon_supershotgun : item_weapon_c
{
    void () weapon_supershotgun =
    {
        if (deathmatch <= 3)
        {
            this.model = "progs/g_shot.mdl";
            precache_model(this.model);
            setmodel(this, this.model);
            this.weapon = IT_SUPER_SHOTGUN;
            this.netname = "Double-barrelled Shotgun";
            setsize (this, '-16 -16 0', '16 16 56');
        }
    };
};

class weapon_nailgun : item_weapon_c
{
    void () weapon_nailgun =
    {
        if (deathmatch <= 3)
        {
            precache_model("progs/g_nail.mdl");
            setmodel(self, "progs/g_nail.mdl");
            self.weapon = IT_NAILGUN;
            self.netname = "nailgun";
            setsize(self, '-16 -16 0', '16 16 56');
        }
    };
};

class weapon_supernailgun : item_weapon_c
{
    void () weapon_supernailgun =
    {
        if (deathmatch <= 3)
        {
            precache_model("progs/g_nail2.mdl");
            setmodel(self, "progs/g_nail2.mdl");
            self.weapon = IT_SUPER_NAILGUN;
            self.netname = "Super Nailgun";
            setsize(self, '-16 -16 0', '16 16 56');
        }
    };
};

class weapon_grenadelauncher : item_weapon_c
{
    void () weapon_grenadelauncher =
    {
        if (deathmatch <= 3)
        {
            precache_model("progs/g_rock.mdl");
            setmodel(self, "progs/g_rock.mdl");
            self.weapon = IT_GRENADE_LAUNCHER;
            self.netname = "Grenade Launcher";
            setsize(self, '-16 -16 0', '16 16 56');
        }
    };
};

class weapon_rocketlauncher : item_weapon_c
{
    void () weapon_rocketlauncher =
    {
        if (deathmatch <= 3)
        {
            precache_model ("progs/g_rock2.mdl");
            setmodel (self, "progs/g_rock2.mdl");
            self.weapon = IT_ROCKET_LAUNCHER;
            self.netname = "Rocket Launcher";
            setsize (self, '-16 -16 0', '16 16 56');
        }
    };
};

class weapon_lightning : item_weapon_c
{
    void () weapon_lightning =
    {
        if (deathmatch <= 3)
        {
            precache_model ("progs/g_light.mdl");
            setmodel (self, "progs/g_light.mdl");
            self.weapon = IT_LIGHTNING;
            self.netname = "Thunderbolt";
            setsize (self, '-16 -16 0', '16 16 56');
        }
    };
};