/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void () item_key1 =
{
    item_key1_c ent = (item_key1_c)self;
    ent.Process();
};

void () item_key2 =
{
    item_key2_c ent = (item_key2_c)self;
    ent.Process();
};

class item_key_c : item_c
{
    virtual void () Process =
    {
        item_c::Process();
        string nn = "";
        precache_model(model);
        setmodel(self, model);
        switch (world.worldtype)
        {
            case 0:
                precache_sound ("misc/medkey.wav");
                self.noise = "misc/medkey.wav";
                break;
            case 1:
                precache_sound ("misc/runekey.wav");
                self.noise = "misc/runekey.wav";
                break;
            case 2:
                precache_sound2 ("misc/basekey.wav");
                self.noise = "misc/basekey.wav";
                break;
        }
    };

    virtual void () touch =
    {
        if (other.classname != "player")
            return;
        if (other.health <= 0)
            return;
        if (other.items & self.items)
            return;

        sprint(other, PRINT_LOW, "You got the ", self.netname, "\n");

        sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");
        other.items = other.items | self.items;

        self.solid = SOLID_NOT;
        self.model = "";

        activator = other;
        SUB_UseTargets();                               // fire all targets / killtargets
    };
};

class item_key1_c : item_key_c
{
    virtual void () Process =
    {
        switch (world.worldtype)
        {
            case 0:
                model = "progs/w_s_key.mdl";
                self.netname = "silver key";
                break;
            case 1:
                model = "progs/m_s_key.mdl";
                self.netname = "silver runekey";
                break;
            case 2:
                model = "progs/b_s_key.mdl";
                self.netname = "silver keycard";
                break;
        }
        self.items = IT_KEY1;

        item_key_c::Process();
    };
};

class item_key2_c : item_key_c
{
    virtual void () Process =
    {
        switch (world.worldtype)
        {
            case 0:
                model = "progs/w_g_key.mdl";
                self.netname = "gold key";
                break;
            case 1:
                model = "progs/m_g_key.mdl";
                self.netname = "gold runekey";
                break;
            case 2:
                model = "progs/b_g_key.mdl";
                self.netname = "gold keycard";
                break;
        }
        self.items = IT_KEY2;

        item_key_c::Process();
    };
};