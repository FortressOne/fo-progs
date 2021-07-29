
enum SCOUT
{
    CLASS = 1,
    MAXSPEED = 450,
    MAXSTRAFESPEED = 450,
    MAXARMORTYPE = .3,
    INITARMORTYPE = .3,
    INITARMORCLASS = 0,
    MAXAMMO_SHOT = 50,
    MAXAMMO_NAIL = 200,
    MAXAMMO_CELL = 100,
    MAXAMMO_ROCKET = 25,
    INITAMMO_SHOT = 25,
    INITAMMO_NAIL = 100,
    INITAMMO_CELL = 50,
    INITAMMO_ROCKET = 0,
    INITAMMO_GREN1 = 2,
    INITAMMO_GREN2 = 3,
    MAXAMMO_GREN1 = 3,
    MAXAMMO_GREN2 = 4,
    WEAPON1 = WEAPON::NAILGUN,
    WEAPON2 = WEAPON::SHOTGUN,
    WEAPON3 = WEAPON::AXE,
    TYPE_GREN1 = GRENADE::FLASH,
    TYPE_GREN2 = GRENADE::CONCUSSION,
    ILLEGALBIT = 1, // Legal Playerclass Handling
    MAXHEALTH = 75,
    MAXHEALTH_FO = 100,
    MAXARMOR_FO = 50,
    MAXARMOR = 25,
    MAX_GREN1 = 3,
    MAX_GREN2 = 4,
    INIT_GREN1 = 2,
    INIT_GREN2 = 3,
};

class Scout : entity
{
    static void (player_c player) Dash =
    {
        if (!GameSettings.scout_dash)
            return;

        if (!(player.tf_attributes & ATTRIBUTE::DASH))
            return;

        if (player.dash_cooldown > time)
            return;

        player.dash_cooldown = time + 1;
        makevectors(player.angles);
        player.velocity = v_forward * 540;
        player.velocity_z = 181;
        sound(player, CHAN_BODY, "dash.wav", 1, ATTN_NORM);
    };

    
};

enumflags SCAN
{
    FRIENDLY,
    ENEMY,
    SOUND,
    
};

class scan_c : entity
{
    float scan_cost;
    float scan_range;
    void () scan_c =
    {
        ((player_c)owner).is_scanning = TRUE;
        sprint(owner, PRINT_HIGH, "Scanner on\n");
        nextthink = time + 2;

        scan_cost = 2;
        scan_range = 2000;
    };

    nonvirtual void (float silent) StopScanning =
    {
        ((player_c)owner).is_scanning = FALSE;
        if (!silent)
            sprint(owner, PRINT_HIGH, "Scanner off\n");
        remove(this);
    };

    virtual void () think =
    {
        player_c player = (player_c)this.owner;

        if (!player.is_scanning)
        {
            remove(this);
            return;
        }
        if (player.ammunition_cells < this.scan_cost)
        {
            sprint(player, PRINT_HIGH, "Not enough cells to run scanner\n");
            remove(this);
            return;
        }

tofinish

        this.nextthink = time + 2;
    };

    static void (player_c player) ToggleScan =
    {
        if (!(player.tf_attributes & ATTRIBUTE::SCAN))
            return;

        // if off, turn on
        if (!player.is_scanning)
        {
            scan_c::ClearScanners(player, TRUE);
            scan_c scanner = spawn(scan_c, owner: player);
        }
        else
        {
            scan_c::ClearScanners(player, FALSE);
        }
    };

    static void (player_c player, float value) ToggleMode =
    {
        if (!(player.tf_attributes & ATTRIBUTE::SCAN))
            return;

        if (player.scan_mode & value)
        {
            player.scan_mode = player.scan_mode - value;
        }
        else
        {
            player.scan_mode = player.scan_mode | value;
        }

        if (value == SCAN::SOUND)
        {
            if (player.scan_mode & SCAN::SOUND)
            {
                sprint(player, PRINT_HIGH, "Scanner sound: on\n");
            }
            else
            {
                sprint(player, PRINT_HIGH, "Scanner sound: off\n");
            }
        }
        else
        {
            string mode = "";

            if (player.scan_mode & SCAN::FRIENDLY)
            {
                mode = "Friendlies";
            }
            if (player.scan_mode & SCAN::ENEMY)
            {
                if (strlen(mode) > 0)
                    mode = strcat(mode, " and ");
                mode = strcat(mode, "Enemies");
            }

            if (strlen(mode) == 0)
            {
                mode = "Nothing";
                scan_c::ClearScanners(player, FALSE);
            }
            else
            {
                // check if a scanner needs to be spawned
                if (!player.is_scanning)
                    scan_c::ToggleScan(player);
            }

            mode = strcat("Scanning for: ", mode, "\n");

            sprint(player, PRINT_HIGH, mode);
        }
    };

    static void (player_c player, float silent) ClearScanners =
    {
        scan_c ent = (scan_c)find(world, ::classname, "scanner");
        float count = 0;
        while (ent)
        {
            if (ent.owner == player)
            {
                if (count > 0)
                    silent = TRUE;
                ent.StopScanning(silent);
                count++;
            }
            ent = (scan_c)find(ent, ::classname, "scanner");
        }
    };
};