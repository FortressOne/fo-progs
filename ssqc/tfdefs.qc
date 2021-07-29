#include "../share/defs.h"
#pragma target fte
#pragma autoproto


typedef void () void_f;


enum CLASS
{
    NONE = 0,
    SCOUT = 1
};

// TF 
enum TEAM
{
    NONE = 0,
    BLUE = 1,
    RED = 2,
    YELLOW = 3,
    GREEN = 4
};

enum SEASON
{
    FO = 0,
    ONE, // lordytf
    TF28
};

enumflags ATTRIBUTE
{
    SCAN,
    DASH,
    DISARM,
    
};

class player_c;
class gamemanager_c;
gamemanager_c GameManager;
class team_c;
team_c *Teams;



// old tf entity field support, unless we manually process ents raw with __fullspawndata
.float team_no;
.float goal_activation;
.float g_a;
.float g_e;
.float goal_effects;
.float h_i_g;
.float has_item_from_group;
.float hasnt_item_from_group;
.float hn_i_g;
.float r_i_g;
.float remove_item_group;
.float a_s;
.float a_n;
.float a_r;
.float a_c;
.float rv_s_h;
.float remove_spawngroup;
.float rs_s_h;
.float restore_spawngroup;
.float rv_gr;
.float remove_group_no;
.float rs_gr;
.float restore_group_no;
.float rv_g;
.float remove_goal_no;
.float rs_g;
.float restore_goal_no;
.string t_s_h;
.string team_str_home;
.string t_s_m;
.string team_str_moved;
.string t_s_c;
.string team_str_carried;
.string n_s_h;
.string non_team_str_home;
.string n_s_m;
.string non_team_str_moved;
.string n_s_c;
.string non_team_str_carried;
.string b_b;
.string broadcast;
.string b_t;
.string team_broadcast;
.string b_n;
.string non_team_broadcast;
.string b_o;
.string owners_team_broadcast;
.string n_b;
.string netname_broadcast;
.string n_t;
.string netname_team_broadcast;
.string n_n;
.string netname_non_team_broadcast;
.string n_o;
.string netname_owners_team_broadcast;
.string d_t;
.string team_drop;
.string d_n;
.string non_team_drop;
.string d_n_t;
.string netname_team_drop;
.string d_n_n;
.string netname_non_team_drop;

// random globals from qw code
entity  lastspawn;
float   modelindex_eyes, modelindex_player;
.float hit_z; // FIXME - is this used by engine?
.float  dmgtime;
float   H_ROTTEN = 1;
float   H_MEGA = 2;
.float  healamount, healtype;
float WEAPON_BIG2 = 1;
float START_OFF = 1;
float SPAWNFLAG_SUPERSPIKE      = 1;
float SPAWNFLAG_LASER = 2;

float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
float PLAT_LOW_TRIGGER = 1;



float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;

float SECRET_OPEN_ONCE = 1;             // stays open
float SECRET_1ST_LEFT = 2;              // 1st move is left of arrow
float SECRET_1ST_DOWN = 4;              // 1st move is down from arrow
float SECRET_NO_SHOOT = 8;              // only opened by trigger
float SECRET_YES_SHOOT = 16;    // shootable even if targeted