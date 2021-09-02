enum DEMOMAN
{
    CLASS = CLASS::DEMOMAN,
    MAXSPEED = 280,
    MAXSTRAFESPEED = 280,
    MAXARMORTYPE = .6,
    INITARMORTYPE = .6,
    INITARMORCLASS = 0,
    MAXAMMO_SHOT = 75,
    MAXAMMO_NAIL = 50,
    MAXAMMO_ROCKET = 50,
    MAXAMMO_CELL = 50,
    
    INITAMMO_SHOT = 30,
    INITAMMO_NAIL = 0,
    INITAMMO_ROCKET = 20,
    INITAMMO_CELL = 0,
    
    INITAMMO_GREN1 = 4,
    INITAMMO_GREN2 = 1,
    MAXAMMO_GREN1 = 4,
    MAXAMMO_GREN2 = 2,
    WEAPON1 = WEAPON::GRENADELAUNCHER,
    WEAPON2 = WEAPON::PIPEBOMBLAUNCHER,
    WEAPON3 = WEAPON::SHOTGUN,
    WEAPON4 = WEAPON::AXE,
    TYPE_GREN1 = GRENADE::HANDGRENADE,
    TYPE_GREN2 = GRENADE::MIRV,
    ILLEGALBIT = ILLEGALBIT::DEMOMAN, // Legal Playerclass Handling
    MAXHEALTH = 100,
    MAXHEALTH_FO = 100,
    MAXARMOR_FO = 110,
    MAXARMOR = 110,
    TF_ATTRIBUTES = 0,
    MAX_ACTIVEGREN2 = 2,
};

class Demoman : entity
{
    static void (player_c player) Special =
    {
        Demoman::Detpipe(player);
    };

    static void (player_c player) Detpipe =
    {
        if (player.det_cooldown > time)
            return;

        proj_pipebomb_c pipe = (proj_pipebomb_c)find(world, ::classname, "pipebomb");
        while (pipe)
        {
            if (pipe.owner == player)
            {
                pipe.Explode();
            }

            pipe = (proj_pipebomb_c)find(pipe, ::classname, "pipebomb");
        }
    };

    static void (player_c player) ExplodeOldestPipebomb =
    {
        proj_pipebomb_c pipe = (proj_pipebomb_c)find(world, ::classname, "pipebomb");
        proj_pipebomb_c oldest = __NULL__;
        while (pipe)
        {
            if (pipe.owner == player)
            {
                if (!oldest)
                    oldest = pipe;
                else if (oldest.nextthink > pipe.nextthink)
                        oldest = pipe;
            }

            pipe = (proj_pipebomb_c)find(pipe, ::classname, "pipebomb");
        }

        if (oldest)
            oldest.Explode();
    };
};