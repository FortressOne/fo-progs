#include "../share/defs.h"
#pragma target fte
#pragma autoproto


typedef void () void_f;

enum WEAPON
{
    AXE,
    SPANNER,
    SNIPERRIFLE,
    TRANQUILISER,
    SUPERSHOTGUN,
    NAILGUN,
    SUPERNAILGUN,
    GRENADELAUNCHER,
    FLAMETHROWER,
    INCENDIARYCANNON,
    ASSAULTCANNON,
    ROCKETLAUNCHER,
    RAILGUN,
    KNIFE,
    SHOTGUN,
    MEDIKIT
};

/*
//basic unnamed enum
enum {a,b,c};

//named enum
enum type1 {a,b,c}; type1 v1_2;
//named enum of specific base type, with variable declaration
enum type2 : string {a="something", b="something else", c="blarg"} v2; type2 v2_2;
//strict named enum, with variable declaration
enum class type3: float {a=0,b=1,c=2} v3; type3 v3_2;
//strict unnamed enum, with variable declaration
enum class : vector {a='0 1 2',b=[3,4,5],c=[6*4,[1,2]*[0,1],2]} v4;

//typedefed unamed enum (making an always-named typedef).
typedef enum{a,b,c} type5;  type5 v5;

void() test =
{
    v2 = type2::a;  //a member type
    v2 = v2::a;     //uses the type's a member.
    v2 = "splat";   //not 'class', so allowed.

    v3 = type3::c;  //allowed.
    v3 = v3::b; //allowed.
//  v3 = 16; //not allowed, must use only defined values.

    (void)v1_2; (void)v2_2; (void)v3_2; (void)v4; (void)v5;
};
*/


// random globals from qw code
//entity stemp, otemp, s, old;



float   modelindex_eyes, modelindex_player;
string nextmap;
.float hit_z; // FIXME - is this used by engine?

float   intermission_running;
float   intermission_exittime;
//entity  multi_ent;
//float   multi_damage;

//vector  blood_org;
//float   blood_count;

//vector  puff_org;
//float   puff_count;

float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
float PLAT_LOW_TRIGGER = 1;