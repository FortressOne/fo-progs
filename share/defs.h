//============================================================================
//			VARS NOT REFERENCED BY C CODE
//============================================================================

#ifndef VER
#define VER "unknown"
#endif

#ifndef REV
#define REV "unk"
#endif

//
// constants
//

#define FALSE		0
#define TRUE		1

// edict.flags
#define FL_FLY		1
#define FL_SWIM		2
#define FL_CLIENT	8 	// set for all client edicts
#define FL_INWATER	16 	// for enter / leave water splash
#define FL_MONSTER	32
#define FL_GODMODE	64 	// player cheat
#define FL_NOTARGET	128 	// player cheat
#define FL_ITEM		256 	// extra wide size for bonus items
#define FL_ONGROUND	512 	// standing on something
#define FL_PARTIALGROUND	1024 	// not all corners are valid
#define FL_WATERJUMP	2048 	// player jumping out of water
#define FL_JUMPRELEASED	4096 	// for jump debouncing

// edict.movetype values
#define MOVETYPE_NONE			0 	// never moves
//#define MOVETYPE_ANGLENOCLIP	1
//#define MOVETYPE_ANGLECLIP	2
#define MOVETYPE_WALK			3 	// players only
#define MOVETYPE_STEP			4 	// discrete, not real time unless fall
#define MOVETYPE_FLY			5
#define MOVETYPE_TOSS			6 	// gravity
#define MOVETYPE_PUSH			7 	// no clip to world, push and crush
#define MOVETYPE_NOCLIP			8
#define MOVETYPE_FLYMISSILE		9 	// fly with extra size against monsters
#define MOVETYPE_BOUNCE			10
#define MOVETYPE_BOUNCEMISSILE		11 	// bounce with extra size

// edict.solid values
#define SOLID_NOT	0 	// no interaction with other objects
#define SOLID_TRIGGER	1 	// touch on edge, but not blocking
#define SOLID_BBOX	2 	// touch on edge, block
#define SOLID_SLIDEBOX	3 	// touch on edge, but not an onground
#define SOLID_BSP	4 	// bsp clip, touch on edge, block

// range values
#define RANGE_MELEE	0
#define RANGE_NEAR	1
#define RANGE_MID	2
#define RANGE_FAR	3

// deadflag values
#define DEAD_NO			0
#define DEAD_DYING		1
#define DEAD_DEAD		2
#define DEAD_RESPAWNABLE	3

// takedamage values
#define DAMAGE_NO	0
#define DAMAGE_YES	1
#define DAMAGE_AIM	2

// items
#define IT_AXE			4096
#define IT_SHOTGUN		1
#define IT_SUPER_SHOTGUN	2
#define IT_NAILGUN		4
#define IT_SUPER_NAILGUN	8
#define IT_GRENADE_LAUNCHER	16
#define IT_ROCKET_LAUNCHER	32
#define IT_LIGHTNING		64
#define IT_EXTRA_WEAPON		128

#define IT_SHELLS	256
#define IT_NAILS	512
#define IT_ROCKETS	1024
#define IT_CELLS	2048

#define IT_ARMOR1	8192
#define IT_ARMOR2	16384
#define IT_ARMOR3	32768
#define IT_SUPERHEALTH	65536

#define IT_KEY1	131072
#define IT_KEY2	262144

#define IT_INVISIBILITY		524288
#define IT_INVULNERABILITY	1048576
#define IT_SUIT			2097152
#define IT_QUAD			4194304
#define IT_HOOK			8388608

// point content values
#define CONTENT_EMPTY	-1
#define CONTENT_SOLID	-2
#define CONTENT_WATER	-3
#define CONTENT_SLIME	-4
#define CONTENT_LAVA	-5
#define CONTENT_SKY	-6

#define STATE_TOP	0
#define STATE_BOTTOM	1
#define STATE_UP	2
#define STATE_DOWN	3

#define VEC_ORIGIN	'0 0 0'
#define VEC_HULL_MIN	'-16 -16 -24'
#define VEC_HULL_MAX	'16 16 32'

#define VEC_HULL2_MIN	'-32 -32 -24'
#define VEC_HULL2_MAX	'32 32 64'

#define VEC_ZOMBIE_MIN '-16 -16 -24'
#define VEC_ZOMBIE_MAX '16 16 40'

// protocol bytes
#define SVC_TEMPENTITY		23
#define SVC_KILLEDMONSTER	27
#define SVC_FOUNDSECRET		28
#define SVC_INTERMISSION	30
#define SVC_FINALE		31
#define SVC_CDTRACK		32
#define SVC_SELLSCREEN		33

#define SVC_SMALLKICK		34
#define SVC_BIGKICK		35
#define SVC_UPDATEPING		36
#define SVC_UPDATETIME		37
#define SVC_MUZZLEFLASH		39
#define SVC_UPDATEUSERINFO	40
#define SVC_PLAYERINFO		42
#define SVC_PACKETENTITIES	47
#define SVC_DELTAPACKETENTITIES	48
#define SVC_SETINFO		51
#define SVC_UPDATEPL		53

#define TE_SPIKE		0
#define TE_SUPERSPIKE		1
#define TE_GUNSHOT		2
#define TE_EXPLOSION		3
#define TE_TAREXPLOSION		4
#define TE_LIGHTNING1		5
#define TE_LIGHTNING2		6
#define TE_WIZSPIKE		7
#define TE_KNIGHTSPIKE		8
#define TE_LIGHTNING3		9
#define TE_LAVASPLASH		10
#define TE_TELEPORT		11
#define TE_BLOOD        	12
#define TE_LIGHTNINGBLOOD	13

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
#define CHAN_AUTO	0
#define CHAN_WEAPON	1
#define CHAN_VOICE	2
#define CHAN_ITEM	3
#define CHAN_BODY	4
#define CHAN_NO_PHS_ADD	8

// update types

#define UPDATE_GENERAL	0
#define UPDATE_STATIC	1
#define UPDATE_BINARY	2
#define UPDATE_TEMP	3

// entity effects

#define EF_BRIGHTFIELD	1
#define EF_MUZZLEFLASH	2
#define EF_BRIGHTLIGHT	4
#define EF_DIMLIGHT	8
#define EF_FLAG1	16
#define EF_FLAG2	32
// GLQuakeWorld Stuff
#define EF_BLUE		64	// Blue Globe effect for Quad
#define EF_RED		128	// Red Globe effect for Pentagram

// messages
#define MSG_BROADCAST	0		// unreliable to all
#define MSG_ONE		1 		// reliable to one (msg_entity)
#define MSG_ALL		2 		// reliable to all
#define MSG_INIT	3 		// write to the init string
#define MSG_MULTICAST   4

// message levels
#define	PRINT_LOW	0		// pickup messages
#define	PRINT_MEDIUM	1		// death messages
#define	PRINT_HIGH	2		// critical messages
#define PRINT_CHAT	3		// also goes to chat console

// multicast sets
#define MULTICAST_ALL	0    	// every client
#define MULTICAST_PHS	1    	// within hearing
#define MULTICAST_PVS	2    	// within sight
#define MULTICAST_ALL_R	3    	// every client, reliable
#define MULTICAST_PHS_R	4    	// within hearing, reliable
#define MULTICAST_PVS_R	5  	// within sight, reliable

// attack_state
#define AS_STRAIGHT	1
#define AS_SLIDING	2
#define AS_MELEE	3
#define AS_MISSILE	4

/*======================================================*/
/* Impulse Defines                                      */
/*======================================================*/
#define IMP_SLOT1                1   // Changes weapon to slot 1 (primary weapon)
#define IMP_SLOT2                2   // Changes weapon to slot 2 (secondary weapon)
#define IMP_SLOT3                3   // Changes weapon to slot 3 (tertiary weapon)
#define IMP_SLOT4                4   // Changes weapon to slot 4 (melee weapon)
#define TF_CLASSMENU            5   // Brings up class menu
// unused                       6
// unused                       7
// unused                       8
// unused                       9
// unused                       10
#define TF_WEAPNEXT             11  // Selects the next weapon slot
#define TF_WEAPPREV             12  // Selects the previous weapon slot
#define TF_WEAPLAST             13  // Selects the last used weapon slot
#define TF_QUICKSLOT1           20  // Fire weapon slot 1 and then switch back to current weapon
#define TF_QUICKSLOT2           21  // Fire weapon slot 2 and then switch back to current weapon
#define TF_QUICKSLOT3           22  // Fire weapon slot 3 and then switch back to current weapon
#define TF_QUICKSLOT4           23  // Fire weapon slot 4 and then switch back to current weapon
#define TF_QUICKSTOP            24  // Used to tell server that quick firing has stopped
#define TF_RELOAD_SLOT1         25  // Reload weapon slot 1
#define TF_RELOAD_SLOT2         26  // Reload weapon slot 2
#define TF_RELOAD_SLOT3         27  // Reload weapon slot 3
#define TF_RELOAD               28  // Reload current weapon
#define TF_RELOAD_NEXT          29  // Reload next weapon with a non-full clip
#define TF_SPECIAL_SKILL        30  // Class special
#define TF_DROPFLAG             31  // Drop flag
#define TF_DROPKEY              32  // Drop key
#define TF_DISCARD              33  // Discard useless ammo
#define TF_DROP_AMMO            34  // Drop an ammo box on the ground
#define TF_MEDIC_HELPME         35  // Alert players around you that you are in need of medical attention
#define TF_INVENTORY            36  // Displays current inventory
#define FLAG_INFO               37  // Displays current flag location
#define TF_ID                   38  // Identify player/object in front of player
#define TF_ID_TEAM              39  // Identify team player/object in front of player
#define TF_ID_ENEMY             40  // Identify enemy player/object in front of player
#define TF_ZOOMTOGGLE           46  // Sniper: Toggle zoom mode on/off
#define TF_ZOOMIN               47  // Sniper: Zoom in (while zoom mode is on)
#define TF_ZOOMOUT              48  // Sniper: Zoom out (while zoom mode is on)
#define TF_DEMOMAN_DETPACK      49  // Demoman: Bring up detpack menu
#define TF_DETPACK              50  // Demoman: Detpack Pre-Impulse
#define TF_DETPACK_STOP         51  // Demoman: Impulse to stop setting detpack
#define TF_DETPACK_5            52  // Demoman: Detpack set to 5 seconds
#define TF_DETPACK_20           53  // Demoman: Detpack set to 20 seconds
#define TF_DETPACK_50           54  // Demoman: Detpack set to 50 seconds
#define TF_PB_DETONATE          55  // Demoman: Detonate Pipebombs
#define TF_MEDIC_AURA_TOGGLE    56  // Medic: Toggle Healing Aura on/off
#define TF_LOCKON               57  // HWGuy: Turn Assault Cannon fire on
#define TF_LOCKOFF              58  // HWGuy: Turn Assault Cannon fire off
#define TF_SPY_DIE              59  // Spy: Feign death
#define TF_SPY_SILENT_DIE       60  // Spy: Silent feign death
#define TF_SPY_SPY              61  // Spy: Bring up disguise menu
#define TF_DISGUISE_ENEMY       62  // Spy: Disguise as enemy team
#define TF_DISGUISE_LAST        63  // Spy: Use last disguise
#define TF_DISGUISE_RESET       64  // Spy: Reset disguise
#define TF_DISGUISE_SCOUT       65  // Spy: Disguise as Scout
#define TF_DISGUISE_SNIPER      66  // Spy: Disguise as Sniper
#define TF_DISGUISE_SOLDIER     67  // Spy: Disguise as Soldier
#define TF_DISGUISE_DEMOMAN     68  // Spy: Disguise as Demoman
#define TF_DISGUISE_MEDIC       69  // Spy: Disguise as Medic
#define TF_DISGUISE_HWGUY       70  // Spy: Disguise as HWGuy
#define TF_DISGUISE_PYRO        71  // Spy: Disguise as Pyro
#define TF_DISGUISE_ENGINEER    72  // Spy: Disguise as Engineer
#define TF_DISGUISE_BLUE        73  // Spy: Disguise as blue team
#define TF_DISGUISE_RED         74  // Spy: Disguise as red team
#define TF_DISGUISE_YELLOW      75  // Spy: Disguise as yellow team
#define TF_DISGUISE_GREEN       76  // Spy: Disguise as green team
#define TF_ENGINEER_BUILD       77  // Engineer: Bring up build menu for Engineer
#define TF_ENGINEER_DETDISP     78  // Engineer: Detonate dispenser for Engineer
#define TF_ENGINEER_DETSENTRY   79  // Engineer: Detonate sentry gun for Engineer
#define TF_DISCARD_DROP_AMMO    80
// unused                       81
// unused                       82
// unused                       83
// unused                       84
// unused                       85
// unused                       86
// unused                       87
// unused                       88
// unused                       89
// unused                       90
// unused                       91
// unused                       92
// unused                       93
// unused                       94
// unused                       95
// unused                       96
// unused                       97
// unused                       98
// unused                       99
#define TF_CHANGETEAM           100 // Bring up team selection menu
#define TF_TEAM_1               101 // Join team 1
#define TF_TEAM_2               102 // Join team 2
#define TF_TEAM_3               103 // Join team 3
#define TF_TEAM_4               104 // Join team 4
#define TF_DISPLAYLOCATION      105 // Displays current location and angles (for developers)
#define TF_SHOWTF               106 // Displays server settings and mod version
#define TF_SHOWLEGALCLASSES     107 // Show what classes are allowed by current map
#define TF_SHOW_IDS             108 // Show ids of connected players
#define TF_ALIAS_CHECK          109 // Check if client has gotten all the aliases
#define TF_CHANGECLASS          110 // Bring up class selection menu
#define TF_CHANGEPC_SCOUT       111 // Change class to Scout
#define TF_CHANGEPC_SNIPER      112 // Change class to Sniper
#define TF_CHANGEPC_SOLDIER     113 // Change class to Soldier
#define TF_CHANGEPC_DEMOMAN     114 // Change class to Demoman
#define TF_CHANGEPC_MEDIC       115 // Change class to Medic
#define TF_CHANGEPC_HVYWEAP     116 // Change class to HWGuy
#define TF_CHANGEPC_PYRO        117 // Change class to Pyro
#define TF_CHANGEPC_SPY         118 // Change class to Spy
#define TF_CHANGEPC_ENGINEER    119 // Change class to Engineer
#define TF_CHANGEPC_RANDOM      120 // Change class to RandomPC
#define TF_HELP_MAP             121 // Displays current map objectives
#define TF_CLASSHELP            122 // Class help alias
#define TF_TEAM_CLASSES         123 // Display team classes
#define TF_TEAM_LIST            124 // Display the players in each team
#define TF_TEAM_SCORES          125 // Display team scores
#define TF_STATUS_QUERY         126 // Displays current team balance and equilization ratios
#define TF_NEXTTIP              127 // Shows the next general/class tip
// unused                       128
// unused                       129
#define TF_TOGGLEVOTE           130 // Toggle vote menu on/off
#define TF_VOTENEXT             131 // Vote to start voting for next map
#define TF_VOTETRICK            132 // Vote to start voting for a trick map
#define TF_VOTERACE             133 // Vote to start voting for a race map
#define TF_FORCENEXT            134 // Vote to force a change to voted map
#define TF_PLAYER_READY         135
#define TF_PLAYER_NOT_READY     136
#define TF_ADMIN_FORCESTARTMATCH      137
#define TF_ADMIN_READYSTATUS          138
// unused                       139
#define TF_NAILGREN_INFO        140
// unused                       141
// unused                       142
// unused                       143
// unused                       144
// unused                       145
// unused                       146
// unused                       147
// unused                       148
// unused                       149
// unused                       150
// unused                       151
// unused                       152
// unused                       153
// unused                       154
// unused                       155
// unused                       156
// unused                       157
// unused                       158
// unused                       159
// unused                       160
// unused                       161
// unused                       162
// unused                       163
// unused                       164
// unused                       165
// unused                       166
// unused                       167
// unused                       168
// unused                       169
// unused                       170
// unused                       171
// unused                       172
// unused                       173
// unused                       174
// unused                       175
// unused                       176
// unused                       177
// unused                       178
// unused                       179
// unused                       180
// unused                       181
// unused                       182
// unused                       183
// unused                       184
// unused                       185
// unused                       186
// unused                       187
// unused                       188
#define TF_ADMIN_CYCLEDEAL          189
#define TF_ADMIN_KICK          190
#define TF_ADMIN_BAN          191
#define TF_ADMIN_COUNTPLAYERS          192
#define TF_ADMIN_CEASEFIRE          193
// unused                       194
#define TF_ADMIN_NEXT          195
// unused                       196
// unused                       197
#define TF_ADMIN_LISTIPS          198
// unused                       199
// unused                       200
// unused                       201
// unused                       202
// unused                       203
// unused                       204
// unused                       205
// unused                       206
#define TF_ADMIN_CLANMODE          207
#define TF_ADMIN_QUADMODE          208
// unused                       209
// unused                       210
// unused                       211
// unused                       212
// unused                       213
// unused                       214
// unused                       215
// unused                       216
// unused                       217
// unused                       218
// unused                       219
// unused                       220
// unused                       221
// unused                       222
// unused                       223
// unused                       224
// unused                       225
// unused                       226
// unused                       227
// unused                       228
// unused                       229
// unused                       230
// unused                       231
// unused                       232
// unused                       233
// unused                       234
// unused                       235
// unused                       236
// unused                       237
// unused                       238
#define TF_ADMIN_ADMINMENU          239
// unused                       240
// unused                       241
// unused                       242
// unused                       243
// unused                       244
// unused                       245
// unused                       246
// unused                       247
// unused                       248
// unused                       249
// unused                       250
// unused                       251
// unused                       252
// unused                       253
// unused                       254
// unused                       255

/*======================================================*/
/* New Weapon Defines					*/
/*======================================================*/

#define WEAP_HOOK			1
// unused                               2
#define WEAP_MEDIKIT			4
#define WEAP_SPANNER			8
#define WEAP_AXE			16
#define WEAP_SNIPER_RIFLE		32
#define WEAP_AUTO_RIFLE			64
#define WEAP_SHOTGUN			128
#define WEAP_SUPER_SHOTGUN		256
#define WEAP_NAILGUN			512
#define WEAP_SUPER_NAILGUN		1024
#define WEAP_GRENADE_LAUNCHER		2048
#define WEAP_FLAMETHROWER		4096
#define WEAP_ROCKET_LAUNCHER		8192
#define WEAP_INCENDIARY			16384
#define WEAP_ASSAULT_CANNON		32768
#define WEAP_LIGHTNING			65536
#define WEAP_DETPACK			131072
#define WEAP_TRANQ			262144
#define WEAP_LASER			524288
// still room for 12 more weapons
// but we can remove some by giving the weapons
// a weapon mode (like the rifle)

/*======================================================*/
/* Death Message defines				*/
/*======================================================*/

#define DMSG_SHOTGUN			1
#define DMSG_SSHOTGUN			2
#define DMSG_NAILGUN			3
#define DMSG_SNAILGUN			4
#define DMSG_GRENADEL			5
#define DMSG_ROCKETL			6
#define DMSG_LIGHTNING			7
#define DMSG_GREN_HAND			8
#define DMSG_GREN_NAIL			9
#define DMSG_GREN_MIRV			10
#define DMSG_GREN_PIPE			11
#define DMSG_DETPACK			12
#define DMSG_BIOWEAPON          13
#define DMSG_BIOWEAPON_ATT      14
#define DMSG_FLAME			15
#define DMSG_DETPACK_DIS		16
#define DMSG_AXE			17
#define DMSG_SNIPERRIFLE		18
#define DMSG_AUTORIFLE			19
#define DMSG_ASSAULTCANNON		20
#define DMSG_HOOK			21
#define DMSG_BACKSTAB			22
#define DMSG_MEDIKIT			23
#define DMSG_GREN_GAS			24
#define DMSG_TRANQ			25
#define DMSG_LASERBOLT			26
#define DMSG_SENTRYGUN_BULLET		27
#define DMSG_SNIPERLEGSHOT		28
#define DMSG_SNIPERHEADSHOT		29
#define DMSG_GREN_EMP			30
#define DMSG_GREN_EMP_AMMO		31
#define DMSG_SPANNER			32
#define DMSG_INCENDIARY			33
#define DMSG_SENTRYGUN_ROCKET		34
#define DMSG_GREN_FLASH			35
#define DMSG_TRIGGER			36



// Legal Playerclass Handling
#define TF_ILL_SCOUT 		1
#define TF_ILL_SNIPER		2
#define TF_ILL_SOLDIER		4
#define TF_ILL_DEMOMAN		8
#define TF_ILL_MEDIC		16
#define TF_ILL_HVYWEP		32
#define TF_ILL_PYRO		    64
#define TF_ILL_RANDOMPC		128
#define TF_ILL_SPY		    256
#define TF_ILL_ENGINEER		512

// Classes
#define PC_SCOUT_NAME               "scout"

// Seasons
#define SEASON_TF28 2.8
#define SEASON_FO 0
#define SEASON_ONE 1

#define FLAGEMU_CHECKED     -1
#define FLAGEMU_NORM        1
#define FLAGEMU_WARSTANDARD 2

// Defines for Goal Item types, : goal_activation (in items)
#define TFGI_GLOW		1   // Players carrying this GoalItem will glow
#define TFGI_SLOW		2   // Players carrying this GoalItem will move at half-speed
#define TFGI_DROP		4   // Players dying with this item will drop it
#define TFGI_RETURN_DROP	8   // Return if a player with it dies
#define TFGI_RETURN_GOAL	16  // Return if a player with it has it removed by a goal's activation
#define TFGI_RETURN_REMOVE	32  // Return if it is removed by TFGI_REMOVE
#define TFGI_REVERSE_AP		64  // Only pickup if the player _doesn't_ match AP Details
#define TFGI_REMOVE		128 // Remove if left untouched for 2 minutes after being dropped
#define TFGI_KEEP		256 // Players keep this item even when they die
#define TFGI_ITEMGLOWS		512	// Item glows when on the ground
#define TFGI_DONTREMOVERES	1024 // Don't remove results when the item is removed
#define TFGI_DROPTOFLOOR	2048 // If this bit is set, the GoalItem drops to the ground when it first spawns.
#define TFGI_ALLOWTHROW	    4096 // Item can be thrown with 'dropitems' command
#define TFGI_SOLID	        8192 // Item is solid


// Defines for Goal States
#define TFGS_NONE	0
#define TFGS_ACTIVE		1
#define TFGS_INACTIVE		2
#define TFGS_REMOVED		3
#define TFGS_DELAYED		4

// Defines for Goal Activation types : goal_activation (in goals)
#define TFGA_TOUCH		1  // Activated when touched
#define TFGA_TOUCH_DETPACK	2  // Activated when touched by a detpack explosion
#define TFGA_REVERSE_AP		4  // Activated when AP details are _not_ met
#define TFGA_SPANNER		8  // Activated when hit by an engineer's spanner

// Defines for Goal Effects types : goal_effect
#define TFGE_AP			1  // AP is affected. Default.
#define TFGE_AP_TEAM		2  // All of the AP's team.
#define TFGE_NOT_AP_TEAM	4  // All except AP's team.
#define TFGE_NOT_AP		8  // All except AP.
#define TFGE_WALL		16 // If set, walls stop the Radius effects
#define TFGE_SAME_ENVIRONMENT	32 // If set, players in a different environment to the Goal are not affected
#define TFGE_TIMER_CHECK_AP	64 // If set, Timer Goals check their criteria for all players fitting their effects

// Defines for Goal Result types : goal_result
#define TFGR_SINGLE		1	// Goal can only be activated once
#define TFGR_ADD_BONUSES	2	// Any Goals activated by this one give their bonuses
#define TFGR_ENDGAME		4	// Goal fires Intermission, displays scores, and ends level
#define TFGR_NO_ITEM_RESULTS	8	// GoalItems given by this Goal don't do results
#define TFGR_REMOVE_DISGUISE	16	// Prevent/Remove undercover from any Spy
#define TFGR_FORCE_RESPAWN	32

// Defines for TeamSpawnpoints : goal_effects (in teamspawns)
#define TFSP_REMOVESELF		1  // Remove itself after being spawned on

// spawnflags
#define TFGI_NOGLOW	1 // stop the automatic glow applied in fortressone to goals with a .mdl set based on team
#define TFGI_CB_IGNORE	2 // Allow this goal to work even in clan battle/quadmode prematch

// Defines for the playerclass
#define PC_UNDEFINED		0
#define PC_SCOUT		1
#define PC_SNIPER		2
#define PC_SOLDIER		3
#define PC_DEMOMAN		4
#define PC_MEDIC		5
#define PC_HVYWEAP		6
#define PC_PYRO			7
#define PC_SPY			8
#define PC_ENGINEER		9


#define MSG_FLAGINFOINIT    1
#define MSG_FLAGINFO        2

#define MSG_SBAR            4
#define MSG_GRENPRIMED      5

#define MSG_CLIENT_MENU     6
#define MSG_TEAMS_UPDATE    7
#define MSG_CLASSES_UPDATE  8
#define MSG_SENTRY_POS      9
#define MSG_DISPENSER_POS   10
#define MSG_SERVER_ADMIN_INFO   11
#define MSG_CAPTAINS        12
#define MSG_MOTD            13
#define MSG_PREMATCH    14
#define MSG_GRENTHROWN      15
#define MSG_ID              16
#define MSG_TEAM_SCORES     17
#define MSG_VOTE_MAPS       18
#define MSG_VOTE_UPDATE     19
#define MSG_VOTE_MAP_ADD    20
#define MSG_VOTE_MAP_DELETE 21