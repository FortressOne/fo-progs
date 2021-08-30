/*
	player.qc

	player functions/definitions

	Copyright (C) 1996-1997  Id Software, Inc.

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to:

		Free Software Foundation, Inc.
		59 Temple Place - Suite 330
		Boston, MA  02111-1307, USA

*/
/*
==============================================================================

PLAYER

==============================================================================
*/




$cd /raid/quake/id1/models/player_4
$origin 0 -6 24
$base base              
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

void()  player_stand1 =[        $axstnd1,       player_stand1   ]
{
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		player_run();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;

		if (self.weaponframe % 4 == 0)
			self.weaponframe = 0;
	}
	else
	{
		if (self.walkframe >= 5)
			self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;    
};

void()  player_run =[   $rockrun1,      player_run      ]
{
	if (self.classname != "player")
		self = self.owner;

	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe = 0;
		player_stand1();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
		if (self.weaponframe % 4 == 0)
			self.weaponframe = 0;
	}
	else
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;
};

void() muzzleflash =
{
	WriteByte (MSG_MULTICAST, SVC_MUZZLEFLASH);
	WriteEntity (MSG_MULTICAST, self);
	multicast (self.origin, MULTICAST_PVS);
};

void()  player_shot1 =  [$shotatt1, player_shot2        ] {
	self.owner.weaponframe=1;
	muzzleflash();
};
void()  player_shot2 =  [$shotatt2, player_shot3        ] {self.owner.weaponframe=2;};
void()  player_shot3 =  [$shotatt3, player_shot4        ] {self.owner.weaponframe=3;};
void()  player_shot4 =  [$shotatt4, player_shot5        ] {self.owner.weaponframe=4;};
void()  player_shot5 =  [$shotatt5, player_shot6        ] {self.owner.weaponframe=5;};
void()  player_shot6 =  [$shotatt6, player_run  ] {self.owner.weaponframe=6;};

void()  player_axe1 =   [$axatt1, player_axe2   ] {self.owner.weaponframe=1;};
void()  player_axe2 =   [$axatt2, player_axe3   ] {self.owner.weaponframe=2;};
void()  player_axe3 =   [$axatt3, player_axe4   ] 
{
	self.owner.weaponframe=3;
	axe_c weap = (axe_c)self;
	weap.Swing();
};
void()  player_axe4 =   [$axatt4, player_run    ] {self.owner.weaponframe=4;};

void()  player_axeb1 =  [$axattb1, player_axeb2 ] {self.owner.weaponframe=5;};
void()  player_axeb2 =  [$axattb2, player_axeb3 ] {self.owner.weaponframe=6;};
void()  player_axeb3 =  [$axattb3, player_axeb4 ] 
{
	self.owner.weaponframe=7;
	axe_c weap = (axe_c)self;
	weap.Swing();
};
void()  player_axeb4 =  [$axattb4, player_run   ] {self.owner.weaponframe=8;};

void()  player_axec1 =  [$axattc1, player_axec2 ] {self.owner.weaponframe=1;};
void()  player_axec2 =  [$axattc2, player_axec3 ] {self.owner.weaponframe=2;};
void()  player_axec3 =  [$axattc3, player_axec4 ] 
{
	self.owner.weaponframe=3;
	axe_c weap = (axe_c)self;
	weap.Swing();
};
void()  player_axec4 =  [$axattc4, player_run   ] {self.owner.weaponframe=4;};

void()  player_axed1 =  [$axattd1, player_axed2 ] {self.owner.weaponframe=5;};
void()  player_axed2 =  [$axattd2, player_axed3 ] {self.owner.weaponframe=6;};
void()  player_axed3 =  [$axattd3, player_axed4 ] 
{
	self.owner.weaponframe=7;
	axe_c weap = (axe_c)self;
	weap.Swing();
};
void()  player_axed4 =  [$axattd4, player_run   ] {self.owner.weaponframe=8;};


//============================================================================




//============================================================================

void() player_light1   =[$light1, player_light2  ] 
{
	muzzleflash();

	if (!self.button0 || GameManager.intermission_running)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	item_artifact_super_damage::ShootSound((player_c)self);
	//W_FireLightning();
	self.attack_finished = time + 0.2;
};
void() player_light2   =[$light2, player_light1  ]
{
	muzzleflash();

	if (!self.button0 || GameManager.intermission_running)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	item_artifact_super_damage::ShootSound((player_c)self);
	//W_FireLightning();
	self.attack_finished = time + 0.2;
};

//============================================================================


void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.owner.weaponframe=1;
	muzzleflash();};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.owner.weaponframe=2;};
void() player_rocket3   =[$rockatt3, player_rocket4  ] {self.owner.weaponframe=3;};
void() player_rocket4   =[$rockatt4, player_rocket5  ] {self.owner.weaponframe=4;};
void() player_rocket5   =[$rockatt5, player_rocket6  ] {self.owner.weaponframe=5;};
void() player_rocket6   =[$rockatt6, player_run  ] {self.owner.weaponframe=6;};

void()  player_pain1 =  [       $pain1, player_pain2    ] {
	player_c player = (player_c)self;
	player.PainSound();
};
void()  player_pain2 =  [       $pain2, player_pain3    ] {};
void()  player_pain3 =  [       $pain3, player_pain4    ] {};
void()  player_pain4 =  [       $pain4, player_pain5    ] {};
void()  player_pain5 =  [       $pain5, player_pain6    ] {};
void()  player_pain6 =  [       $pain6, player_run      ] {};

void()  player_axpain1 =        [       $axpain1,       player_axpain2  ] {
	player_c player = (player_c)self;
	player.PainSound();
};
void()  player_axpain2 =        [       $axpain2,       player_axpain3  ] {};
void()  player_axpain3 =        [       $axpain3,       player_axpain4  ] {};
void()  player_axpain4 =        [       $axpain4,       player_axpain5  ] {};
void()  player_axpain5 =        [       $axpain5,       player_axpain6  ] {};
void()  player_axpain6 =        [       $axpain6,       player_run      ] {};


void()  player_diea1    =       [       $deatha1,       player_diea2    ] {};
void()  player_diea2    =       [       $deatha2,       player_diea3    ] {};
void()  player_diea3    =       [       $deatha3,       player_diea4    ] {};
void()  player_diea4    =       [       $deatha4,       player_diea5    ] {};
void()  player_diea5    =       [       $deatha5,       player_diea6    ] {};
void()  player_diea6    =       [       $deatha6,       player_diea7    ] {};
void()  player_diea7    =       [       $deatha7,       player_diea8    ] {};
void()  player_diea8    =       [       $deatha8,       player_diea9    ] {};
void()  player_diea9    =       [       $deatha9,       player_diea10   ] {};
void()  player_diea10   =       [       $deatha10,      player_diea11   ] {};
void()  player_diea11   =       [       $deatha11,      player_diea11 ] {player_c player = (player_c)self; player.Dead();};

void()  player_dieb1    =       [       $deathb1,       player_dieb2    ] {};
void()  player_dieb2    =       [       $deathb2,       player_dieb3    ] {};
void()  player_dieb3    =       [       $deathb3,       player_dieb4    ] {};
void()  player_dieb4    =       [       $deathb4,       player_dieb5    ] {};
void()  player_dieb5    =       [       $deathb5,       player_dieb6    ] {};
void()  player_dieb6    =       [       $deathb6,       player_dieb7    ] {};
void()  player_dieb7    =       [       $deathb7,       player_dieb8    ] {};
void()  player_dieb8    =       [       $deathb8,       player_dieb9    ] {};
void()  player_dieb9    =       [       $deathb9,       player_dieb9    ] {player_c player = (player_c)self; player.Dead();};

void()  player_diec1    =       [       $deathc1,       player_diec2    ] {};
void()  player_diec2    =       [       $deathc2,       player_diec3    ] {};
void()  player_diec3    =       [       $deathc3,       player_diec4    ] {};
void()  player_diec4    =       [       $deathc4,       player_diec5    ] {};
void()  player_diec5    =       [       $deathc5,       player_diec6    ] {};
void()  player_diec6    =       [       $deathc6,       player_diec7    ] {};
void()  player_diec7    =       [       $deathc7,       player_diec8    ] {};
void()  player_diec8    =       [       $deathc8,       player_diec9    ] {};
void()  player_diec9    =       [       $deathc9,       player_diec10   ] {};
void()  player_diec10   =       [       $deathc10,      player_diec11   ] {};
void()  player_diec11   =       [       $deathc11,      player_diec12   ] {};
void()  player_diec12   =       [       $deathc12,      player_diec13   ] {};
void()  player_diec13   =       [       $deathc13,      player_diec14   ] {};
void()  player_diec14   =       [       $deathc14,      player_diec15   ] {};
void()  player_diec15   =       [       $deathc15,      player_diec15 ] {player_c player = (player_c)self; player.Dead();};

void()  player_died1    =       [       $deathd1,       player_died2    ] {};
void()  player_died2    =       [       $deathd2,       player_died3    ] {};
void()  player_died3    =       [       $deathd3,       player_died4    ] {};
void()  player_died4    =       [       $deathd4,       player_died5    ] {};
void()  player_died5    =       [       $deathd5,       player_died6    ] {};
void()  player_died6    =       [       $deathd6,       player_died7    ] {};
void()  player_died7    =       [       $deathd7,       player_died8    ] {};
void()  player_died8    =       [       $deathd8,       player_died9    ] {};
void()  player_died9    =       [       $deathd9,       player_died9    ] {player_c player = (player_c)self; player.Dead();};

void()  player_diee1    =       [       $deathe1,       player_diee2    ] {};
void()  player_diee2    =       [       $deathe2,       player_diee3    ] {};
void()  player_diee3    =       [       $deathe3,       player_diee4    ] {};
void()  player_diee4    =       [       $deathe4,       player_diee5    ] {};
void()  player_diee5    =       [       $deathe5,       player_diee6    ] {};
void()  player_diee6    =       [       $deathe6,       player_diee7    ] {};
void()  player_diee7    =       [       $deathe7,       player_diee8    ] {};
void()  player_diee8    =       [       $deathe8,       player_diee9    ] {};
void()  player_diee9    =       [       $deathe9,       player_diee9    ] {player_c player = (player_c)self; player.Dead();};

void()  player_die_ax1  =       [       $axdeth1,       player_die_ax2  ] {};
void()  player_die_ax2  =       [       $axdeth2,       player_die_ax3  ] {};
void()  player_die_ax3  =       [       $axdeth3,       player_die_ax4  ] {};
void()  player_die_ax4  =       [       $axdeth4,       player_die_ax5  ] {};
void()  player_die_ax5  =       [       $axdeth5,       player_die_ax6  ] {};
void()  player_die_ax6  =       [       $axdeth6,       player_die_ax7  ] {};
void()  player_die_ax7  =       [       $axdeth7,       player_die_ax8  ] {};
void()  player_die_ax8  =       [       $axdeth8,       player_die_ax9  ] {};
void()  player_die_ax9  =       [       $axdeth9,       player_die_ax9  ] {player_c player = (player_c)self; player.Dead();};

class player_c : entity 
{
	float _is_invincible;
	get float is_invincible =
	{
		return _is_invincible;
	};
	set float is_invincible =
	{
		if (value)
		{
			invincible_time = 1;
			items = items | IT_INVULNERABILITY;
			effects = effects | EF_DIMLIGHT | EF_RED;
		}
		else
		{
			items = items - IT_INVULNERABILITY;
			effects = effects - (effects & EF_DIMLIGHT);
			effects = effects - (effects & EF_RED);
			invincible_finished = 0;
			invincible_time = 0;
		}

		_is_invincible = value;
	};

	team_c tf_team;
	class_t *tf_class;
	float menu;
	float has_aliases;
	string status_string;
	float status_string_lines;
	float status_string_refresh_time;
	float status_string_time;
	float tf_attributes;
	float ammunition_gren1;
	float ammunition_gren2;

	get float ammunition_shells =
	{
		return ammo_shells;
	};
	set float ammunition_shells =
	{
		ammo_shells = value > this.tf_class.max_shells ? this.tf_class.max_shells : value;
	};
	get float ammunition_nails =
	{
		return ammo_nails;
	};
	set float ammunition_nails =
	{
		ammo_nails = value > this.tf_class.max_nails ? this.tf_class.max_nails : value;
	};
	get float ammunition_rockets =
	{
		return ammo_rockets;
	};
	set float ammunition_rockets =
	{
		ammo_rockets = value > this.tf_class.max_rockets ? this.tf_class.max_rockets : value;
	};
	get float ammunition_cells =
	{
		return ammo_cells;
	};
	set float ammunition_cells =
	{
		ammo_cells = value > this.tf_class.max_cells ? this.tf_class.max_cells : value;
	};

	weapon_c _current_weapon; // private
	weapon_c last_weapon;
	set weapon_c current_weapon =
	{
		this.items = this.items - ( this.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
		last_weapon = _current_weapon;
		_current_weapon = value;
		player_run();          // get out of any weapon firing states
		this.currentammo = value.ammo_count;
		this.weaponmodel = value.weaponmodel;
		this.weaponframe = 0;
		this.weapon = value.weapon;
		this.items = this.items | value.ammo_type;
	};
	inline get weapon_c current_weapon = { return _current_weapon; };

	weapon_c weapon1;
	weapon_c weapon2;
	weapon_c weapon3;
	weapon_c weapon4;
	handgrenade_c primed_grenade;

	float _is_reloading;
	get float is_reloading =
	{
		return _is_reloading;
	};
	set float is_reloading =
	{
		if (value == TRUE)
		{
			this.weaponmodel = "";
		}
		else
		{
			this.weaponmodel = this.current_weapon.weaponmodel;
			sprint(this, PRINT_HIGH, "Finished reloading\n");
		}

		_is_reloading = value;
	};
	float is_using_old_impulses;


	// scout
	float dash_cooldown;
	float is_scanning;
	float scan_mode;
	float flash_time; // time left on flash amount

	float _is_flashed;
	get float is_flashed =
	{
		return _is_flashed;
	};
	set float is_flashed =
	{
		if (value)
		{
			GameManager.flash_dimension = GameManager.flash_dimension + 1;
			float dmn = 1<<GameManager.flash_dimension;
			this.dimension_see = DIMENSION::FLASH | dmn;
			this.dimension_seen = dmn | DIMENSION::NOFLASH;
		}
		else
		{
			this.dimension_see = DIMENSION::NOFLASH;
			this.dimension_seen = DIMENSION::NOFLASH;			
		}

		_is_flashed = value;
	};

	float _is_concussed;
	get float is_concussed =
	{
		return _is_concussed;
	};
	set float is_concussed =
	{
		if (!value)
		{
			sprint(this, PRINT_HIGH, "Your head feels better now\n");
		}

		_is_concussed = value;
	};

	// spy
	float is_disguised; // TODO - maybe not needed due to gets/sets
	float _disguised_team_no;
	get float disguised_team_no =
	{
		return _disguised_team_no == 0 ? this.tf_team.team_no : _disguised_team_no;
	};
	set float disguised_team_no =
	{
		if (this.tf_team.team_no != value)
			is_disguised = TRUE;
		else
			is_disguised = FALSE;

		_disguised_team_no = value;
	};

	float is_feigning;

	// sniper, hwguy
	float is_aiming;

	nonvirtual void (float teamnum) SetTeam = 
	{
		string teamName = Teams[teamnum-1].name;
		
		if (teamnum == this.tf_team.team_no)
		{
			sprint(this, PRINT_HIGH, "You are already on the ", teamName, " team!\n");
			return;
		}

		if (teamnum > GameSettings.number_of_teams)
		{
			sprint(this, PRINT_HIGH, "This team doesn't exist!\n");
			return;
		}

		this.tf_team = Teams[teamnum-1];
		this.Suicide();

		bprint(PRINT_HIGH, this.netname, " has joined the ", teamName, " team!\n");

		this.SetTeamName();
	};

	nonvirtual void (float choice) PrimeThrowGrenade =
	{
		if (this.primed_grenade)
		{
			primed_grenade.Throw();
			return;
		}

		PrimeGrenade(choice);
	};

	nonvirtual void (float choice) PrimeGrenade =
	{
		float *ammo = __NULL__;
		GRENADE type = __NULL__;
		if (choice == 1)
		{
			ammo = &(this.ammunition_gren1);
			type = this.tf_class.type_gren1;
		}
		else if (choice == 2)
		{
			ammo = &(this.ammunition_gren2);
			type = this.tf_class.type_gren2;
		}

		if (ammo > 0)
		{
			ammo = ammo - 1;
			switch (type)
			{
				case GRENADE::FLASH:
					flashgrenade_c::Prime(this);
					break;
				case GRENADE::CONCUSSION:
					concussiongrenade_c::Prime(this);
					break;
				case GRENADE::HANDGRENADE:
					handgrenade_c::Prime(this);
					break;
				case GRENADE::SHOCK:
					shockgrenade_c::Prime(this);
					break;
			}
		}
	};

	nonvirtual void () ThrowGrenade =
	{
		if (this.primed_grenade)
			primed_grenade.Throw();
	};

	nonvirtual void () SetTeamName =
	{
		stuffcmd(this, strcat("team ", this.tf_team.scoreboard_name, "\n"));
	};

	nonvirtual void (float choice) SetClass = 
	{
		float spawn = FALSE;
		if (!this.tf_class)
			spawn = TRUE;

		this.tf_class = &Classes[choice-1];
		sprint(this, PRINT_HIGH, strcat("You will return as a ", this.tf_class.classname, "\n"));

		if (spawn)
			this.Respawn(FALSE);
	};

	nonvirtual float (float choice) CanChooseClass =
	{
		if (this.classname == "observer")
		{
			sprint(this, PRINT_HIGH, "You can't choose a class whilst spectating! Join the game first.\n");
			return FALSE;
		}

		if (!GameSettings.override_mapclasses)
		{
			// TODO - check map restrictions
			class_t *class = &Classes[choice-1];
			if (this.tf_team.illegal_classes & class.illegal_bit)
			{
				return FALSE;
			}
		}

		// check server restrictions
		float max = GameSettings.max_classes[choice-1];

		if (max > 0)
		{
			player_c p = (player_c)find(world, ::classname, "player");
			float numPlaying = 0;
			while (p)
			{
				if (p.tf_team.team_no == this.tf_team.team_no)
				{
					if (p.playerclass == choice)
					{
						numPlaying++;
					}
				}
				p = (player_c)find(world, ::classname, "player");
			}

			if (numPlaying >= max)
			{
				return FALSE;
			}
		}

		return TRUE;
	};

	nonvirtual float () CanInteract =
	{
		if (is_feigning)
			return FALSE;

		if (is_aiming)
			return FALSE;

		return TRUE;
	};

	nonvirtual void() PreThink =
	{
		if (GameManager.intermission_running)
		{
			GameManager.IntermissionThink(this);   // otherwise a button could be missed between
			return;                                 // the think tics
		}

		if (this.view_ofs == '0 0 0')
			return;         // intermission or finale

		makevectors (this.v_angle);             // is this still used

		this.deathtype = "";

		GameManager.CheckRules();
		this.WaterMove();

		if (this.deadflag >= DEAD_DEAD)
		{
			this.PlayerDeathThink();
			return;
		}
		
		if (this.deadflag == DEAD_DYING)
			return; // dying, so do nothing

		if (this.button2)
		{
			this.PlayerJump();
		}
		else
			this.flags = this.flags | FL_JUMPRELEASED;

	// teleporters can force a non-moving pause time        
		if (time < this.pausetime)
			this.velocity = '0 0 0';

		if (time > this.attack_finished && this.currentammo == 0 && this.weapon != IT_AXE)
		{
			//bprint(PRINT_HIGH, "prethink\n");
			//bprint(PRINT_HIGH, "currentammo: ", ftos(this.currentammo), "\n");
			//bprint(PRINT_HIGH, "weapon: ", ftos(this.weapon), "\n");
			this.current_weapon = this.GetBestWeapon();
		}
	};

	nonvirtual void() PostThink =
	{
		MenuManager.FrameThink(this);

		if (this.view_ofs == '0 0 0')
			return;         // intermission or finale
		if (this.deadflag)
			return;

		// check to see if player landed and play landing sound 
		if ((this.jump_flag < -300) && (this.flags & FL_ONGROUND) )
		{
			if (this.watertype == CONTENT_WATER)
				sound(this, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
			else if (this.jump_flag < -650)
			{
				this.deathtype = "falling";
				T_Damage (this, world, world, 5, DAMAGE::NOTTEAM, DAMAGETYPE::OTHER); 
				sound (this, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			}
			else
				sound (this, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
		}

		this.jump_flag = this.velocity_z;

		this.CheckPowerups();

		this.WeaponFrame();

		GameManager.SendAliases(this);

		
	};

	nonvirtual void (entity et, float f) Pain =
	{
		if (self.weaponframe)
			return;

		if (self.invisible_finished > time)
			return;         // eyes don't have pain frames

		if (self.weapon == IT_AXE)
			player_axpain1();
		else
			player_pain1();
	};

	 /*
	================
	CheckPowerups

	Check for turning off powerups
	================
	*/
	nonvirtual void () CheckPowerups =
	{
		if (this.health <= 0)
			return;

		// invisibility
		if (this.invisible_finished)
		{
			// sound and screen flash when items starts to run out
			if (this.invisible_sound < time)
			{
				sound (this, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
				this.invisible_sound = time + ((random() * 3) + 1);
			}

			if (this.invisible_finished < time + 3)
			{
				if (this.invisible_time == 1)
				{
					sprint (this, PRINT_HIGH, "Ring of Shadows magic is fading\n");
					stuffcmd (this, "bf\n");
					sound (this, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
					this.invisible_time = time + 1;
				}
				
				if (this.invisible_time < time)
				{
					this.invisible_time = time + 1;
					stuffcmd (this, "bf\n");
				}
			}

			if (this.invisible_finished < time)
			{       // just stopped
				this.items = this.items - IT_INVISIBILITY;
				this.invisible_finished = 0;
				this.invisible_time = 0;
			}
			
			// use the eyes
			this.frame = 0;
			this.modelindex = modelindex_eyes;
		}
		else
			this.modelindex = modelindex_player;    // don't use eyes

		// invincibility
		if (this.invincible_finished)
		{
			// sound and screen flash when items starts to run out
			if (this.invincible_finished < time + 3)
			{
				if (this.invincible_time == 1)
				{
					sprint (this, PRINT_HIGH, "Protection is almost burned out\n");
					stuffcmd (this, "bf\n");
					sound (this, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
					this.invincible_time = time + 1;
				}
				
				if (this.invincible_time < time)
				{
					this.invincible_time = time + 1;
					stuffcmd (this, "bf\n");
				}
			}
			
			if (this.invincible_finished < time)
			{
				this.is_invincible = FALSE;
			} 
		}

		// super damage
		if (this.super_damage_finished)
		{
			// sound and screen flash when items starts to run out
			if (this.super_damage_finished < time + 3)
			{
				if (this.super_time == 1)
				{
					if (deathmatch == 4)
						sprint (this, PRINT_HIGH, "OctaPower is wearing off\n");
					else
						sprint (this, PRINT_HIGH, "Quad Damage is wearing off\n");
					stuffcmd (this, "bf\n");
					sound (this, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
					this.super_time = time + 1;
				}         
				
				if (this.super_time < time)
				{
					this.super_time = time + 1;
					stuffcmd (this, "bf\n");
				}
			}

			if (this.super_damage_finished < time)
			{       // just stopped
				this.items = this.items - IT_QUAD;
				this.super_damage_finished = 0;
				this.super_time = 0;
			}
			if (this.super_damage_finished > time)
			{
				this.effects = this.effects | EF_DIMLIGHT;
				this.effects = this.effects | EF_BLUE;
			}
			else
			{
				this.effects = this.effects - (this.effects & EF_DIMLIGHT);
				this.effects = this.effects - (this.effects & EF_BLUE);
			}
		}       

		// suit 
		if (this.radsuit_finished)
		{
			this.air_finished = time + 12;          // don't drown
			// sound and screen flash when items starts to run out
			if (this.radsuit_finished < time + 3)
			{
				if (this.rad_time == 1)
				{
					sprint (this, PRINT_HIGH, "Air supply in Biosuit expiring\n");
					stuffcmd (this, "bf\n");
					sound (this, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
					this.rad_time = time + 1;
				}
				
				if (this.rad_time < time)
				{
					this.rad_time = time + 1;
					stuffcmd (this, "bf\n");
				}
			}

			if (this.radsuit_finished < time)
			{       // just stopped
				this.items = this.items - IT_SUIT;
				this.rad_time = 0;
				this.radsuit_finished = 0;
			}
		}       
	};

	nonvirtual void () WaterMove =
	{
		if (this.movetype == MOVETYPE_NOCLIP)
			return;
		if (this.health < 0)
			return;

		if (this.waterlevel != 3)
		{
			if (this.air_finished < time)
				sound(this, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
			else if (this.air_finished < time + 9)
				sound(this, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
			this.air_finished = time + 12;
			this.dmg = 2;
		}
		else if (this.air_finished < time)
		{       
			// drown!
			if (this.pain_finished < time)
			{
				this.dmg = this.dmg + 2;
				if (this.dmg > 15)
					this.dmg = 10;
				T_Damage(this, world, world, this.dmg, DAMAGE::NOTTEAM, DAMAGETYPE::OTHER);
				this.pain_finished = time + 1;
			}
		}
		
		if (!this.waterlevel)
		{
			if (this.flags & FL_INWATER)
			{       
				// play leave water sound
				sound(this, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
				this.flags = this.flags - FL_INWATER;
			}
			return;
		}

		if (this.watertype == CONTENT_LAVA)
		{       
			// do damage
			if (this.dmgtime < time)
			{
				if (this.radsuit_finished > time)
					this.dmgtime = time + 1;
				else
					this.dmgtime = time + 0.2;

				T_Damage(this, world, world, 10*this.waterlevel, DAMAGE::NOTTEAM, DAMAGETYPE::OTHER);
			}
		}
		else if (this.watertype == CONTENT_SLIME)
		{       
			// do damage
			if (this.dmgtime < time && this.radsuit_finished < time)
			{
				this.dmgtime = time + 1;
				T_Damage(this, world, world, 4*this.waterlevel, DAMAGE::NOTTEAM, DAMAGETYPE::OTHER);
			}
		}
		
		if (!(this.flags & FL_INWATER))
		{
			// player enter water sound
			if (this.watertype == CONTENT_LAVA)
				sound(this, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
			if (this.watertype == CONTENT_WATER)
				sound(this, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
			if (this.watertype == CONTENT_SLIME)
				sound(this, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

			this.flags = this.flags + FL_INWATER;
			this.dmgtime = 0;
		}       
	};

	nonvirtual void () Suicide =
	{
		bprint (PRINT_MEDIUM, self.netname, " suicides\n");
		this.SetSuicideFrame();
		self.modelindex = modelindex_player;
		logfrag (self, self);
		self.frags = self.frags - 2;    // extra penalty
		this.Respawn(TRUE);
	};

	nonvirtual void () PlayerDeathThink = 
	{
		if ((this.flags & FL_ONGROUND))
		{
			float forward = vlen(this.velocity);
			forward = forward - 20;
			if (forward <= 0)
				this.velocity = '0 0 0';
			else    
				this.velocity = forward * normalize(this.velocity);
		}

	// wait for all buttons released
		if (this.deadflag == DEAD_DEAD)
		{
			if (this.button2 || this.button1 || this.button0)
				return;
			this.deadflag = DEAD_RESPAWNABLE;
			return;
		}

	// wait for any button down
		if (!this.button2 && !this.button1 && !this.button0)
			return;

		this.button0 = 0;
		this.button1 = 0;
		this.button2 = 0;
		this.Respawn(TRUE);
	};

	nonvirtual void() PlayerJump = {
		if (this.flags & FL_WATERJUMP)
			return;
		
		if (this.waterlevel >= 2)
		{
			// play swiming sound
			if (this.swim_flag < time)
			{
				this.swim_flag = time + 1;
				if (random() < 0.5)
					sound (this, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
				else
					sound (this, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
			}

			return;
		}

		if (!(this.flags & FL_ONGROUND))
			return;

		if (!(this.flags & FL_JUMPRELEASED))
			return;         // don't pogo stick

		this.flags = this.flags - (this.flags & FL_JUMPRELEASED);       
		this.button2 = 0;

		// player jumping sound
		sound(this, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	};

	nonvirtual void () WeaponFrame =
    {
        if (time < this.attack_finished)
            return;

        this.ImpulseCommands();
        
        // check for attack
        if (this.button0 && this.current_weapon.IsReady())
        {
            item_artifact_super_damage::ShootSound(this);
            this.current_weapon.Attack();
        }

		// check for reload
		if (this.current_weapon.clip_left == 0 && this.current_weapon.clip_size > 0)
		{
			this.current_weapon.Reload();
		}
    };

	nonvirtual void (float input) ChangeWeapon =
	{
		if (this.is_reloading)
			return;

		if (this.attack_finished >= time)
			return;

		weapon_c weap = __NULL__;
		if (this.is_using_old_impulses)
		{

			return;
		}

		switch (input)
		{
			case 1:
				weap = this.weapon1;
				break;
			case 2:
				weap = this.weapon2;
				break;
			case 3:
				weap = this.weapon3;
				break;
			case 4:
				weap = this.weapon4;
				break;
		}

		if (weap)
		{
			if (weap.HasAmmo())
			{
				this.current_weapon = weap;
			}
			else
			{
				sprint(this, PRINT_HIGH, "Not enough ammo.\n");
			}
		}
	};

	nonvirtual void () ImpulseCommands =
	{
		if (this.impulse == 0)
			return;

		bprint(PRINT_HIGH, strcat("imp: ", ftos(this.impulse), "\n"));

		IMPULSE imp = (IMPULSE)this.impulse;
		if (imp<= 8 && imp >= 1)
		{
			this.ChangeWeapon(imp);
		}

		switch (imp)
		{
			case IMPULSE::PRIME_GREN1:
				this.PrimeGrenade(1);
				break;
			case IMPULSE::PRIME_GREN2:
				this.PrimeGrenade(2);
				break;
			case IMPULSE::THROW_GREN:
				this.ThrowGrenade();
				break;
			case IMPULSE::PRIMETHROW_GREN1:
				this.PrimeThrowGrenade(1);
				break;
			case IMPULSE::PRIMETHROW_GREN2:
				this.PrimeThrowGrenade(2);
				break;
			case IMPULSE::SPECIAL:
				switch(this.tf_class.class)
				{
					case CLASS::SCOUT:
						Scout::Special(this);
						break;
					case CLASS::SOLDIER:
						Soldier::Special(this);
						break;
				}
				break;
			case IMPULSE::DASH:
				Scout::Dash(this);
				break;
			case IMPULSE::SCAN:
				scan_c::ToggleScan(this);
				break;
			case IMPULSE::SCAN_FRIENDLY:
				scan_c::ToggleMode(this, SCAN::FRIENDLY);
				break;
			case IMPULSE::SCAN_ENEMY:
				scan_c::ToggleMode(this, SCAN::ENEMY);
				break;
			case IMPULSE::SCAN_SOUND:
				scan_c::ToggleMode(this, SCAN::SOUND);
				break;
		}

		self.impulse = 0;
	};

	nonvirtual weapon_c () GetBestWeapon =
    {
        if (this.weapon1.HasAmmo())
		{
			return this.weapon1;
		}

		if (this.weapon2.HasAmmo())
		{
			return this.weapon2;
		}
		if (this.weapon3.HasAmmo())
		{
			return this.weapon3;
		}
		
		return this.weapon4;
    };

	nonvirtual void () SetupClass =
	{
		if (!this.tf_class)
			return;
		this.health = this.tf_class.max_health;
		this.armorvalue = this.tf_class.init_armor;
		this.armortype = this.tf_class.init_armor_type;
		this.ammunition_shells = this.tf_class.init_shells;
		this.ammunition_nails = this.tf_class.init_nails;
		this.ammunition_rockets = this.tf_class.init_rockets;
		this.ammunition_cells = this.tf_class.init_cells;
		this.ammunition_gren1 = this.tf_class.init_gren1;
		this.ammunition_gren2 = this.tf_class.init_gren2;
		this.tf_attributes = this.tf_class.tf_attributes;

		if (this.weapon1)
			remove(this.weapon1);
		this.weapon1 = weapon_c::spawn(this.tf_class.weapon1, this);
		
		if (this.weapon2)
			remove(this.weapon2);
		this.weapon2 = weapon_c::spawn(this.tf_class.weapon2, this);

		if (this.weapon3)
			remove(this.weapon3);
		this.weapon3 = weapon_c::spawn(this.tf_class.weapon3, this);

		if (this.weapon4)
			remove(this.weapon4);
		this.weapon4 = weapon_c::spawn(this.tf_class.weapon4, this);
	};

	nonvirtual void(float spawnBody) Respawn =
	{
		// make a copy of the dead body for appearances sake
		if (spawnBody)
			CopyToBodyQue(this);

		this.classname = "player";
		this.health = 100;
		this.takedamage = DAMAGE_AIM;
		this.solid = SOLID_SLIDEBOX;
		this.movetype = MOVETYPE_WALK;
		this.show_hostile = 0;
		this.max_health = 100;
		this.flags = FL_CLIENT;
		this.air_finished = time + 12;
		this.dmg = 2;                   // initial water damage
		this.super_damage_finished = 0;
		this.radsuit_finished = 0;
		this.invisible_finished = 0;
		this.invincible_finished = 0;
		this.effects = 0;
		this.invincible_time = 0;

		this.SetupClass();
		
		this.current_weapon = this.GetBestWeapon();

		this.attack_finished = time;
		this.th_pain = this.Pain;
		this.th_die = this.Die;
		
		this.deadflag = DEAD_NO;
	// paustime is set by teleporters to keep the player from moving a while
		this.pausetime = 0;
		
		entity spot = SelectSpawnPoint();

		this.origin = spot.origin + '0 0 1';
		this.angles = spot.angles;
		this.fixangle = TRUE;           // turn this way immediately

		this.is_flashed = FALSE;

	// oh, this is a hack!
		setmodel(this, "progs/eyes.mdl");
		modelindex_eyes = this.modelindex;

		setmodel(this, "progs/player.mdl");
		modelindex_player = this.modelindex;

		setsize(this, VEC_HULL_MIN, VEC_HULL_MAX);
		
		this.view_ofs = '0 0 22';

	// Mod - Xian (May.20.97)
	// Bug where player would have velocity from their last kill

		this.velocity = '0 0 0';

		player_stand1();
		
		makevectors(this.angles);
		spawn_tfog(this.origin + v_forward*20);

		spawn_tdeath(this.origin, this);

		// Set Rocket Jump Modifiers
		if (stof(infokey(world, "rj")) != 0)
		{                
			rj = stof(infokey(world, "rj"));
		}
	};

	nonvirtual void () Die =
	{
		self.items = self.items - (self.items & IT_INVISIBILITY);

		if ((stof(infokey(world,"dq"))) != 0)
		{
			if (self.super_damage_finished > 0)
			{
				item_artifact_super_damage::Drop(this);
			}
		}

		if ((stof(infokey(world,"dr"))) != 0)
		{
			if (self.invisible_finished > 0)
			{
				item_artifact_invisibility::Drop(this);
			}
		}

		self.invisible_finished = 0;    // don't die as eyes
		self.invincible_finished = 0;
		self.super_damage_finished = 0;
		self.radsuit_finished = 0;
		self.modelindex = modelindex_player;    // don't use eyes

		this.DropBackpack();
		
		self.weaponmodel="";
		self.view_ofs = '0 0 -8';
		self.deadflag = DEAD_DYING;
		self.solid = SOLID_NOT;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.movetype = MOVETYPE_TOSS;
		if (self.velocity_z < 10)
			self.velocity_z = self.velocity_z + random()*300;

		if (self.health < -40)
		{
			this.Gib();
			return;
		}

		this.DeathSound();
		
		self.angles_x = 0;
		self.angles_z = 0;
		
		if (self.weapon == IT_AXE)
		{
			player_die_ax1();
			return;
		}
		
		float i = 1 + floor(random()*6);
		
		if (i == 1)
			player_diea1();
		else if (i == 2)
			player_dieb1();
		else if (i == 3)
			player_diec1();
		else if (i == 4)
			player_died1();
		else
			player_diee1();
	};

	nonvirtual void () DropBackpack =
	{
		item_backpack_c ent = (item_backpack_c)spawn(item_backpack_c, owner: this);
	};

	nonvirtual void() SetSuicideFrame =
	{       
		// used by kill command and disconnect command
		if (self.model != "progs/player.mdl")
			return; // already gibbed
		self.frame = $deatha11;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_TOSS;
		self.deadflag = DEAD_DEAD;
		self.nextthink = -1;
	};
	nonvirtual void () Gib =
	{
		ThrowHead("progs/h_player.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);

		self.deadflag = DEAD_DEAD;

		if (damage_attacker.classname == "teledeath")
		{
			sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
			return;
		}

		if (damage_attacker.classname == "teledeath2")
		{
			sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
			return;
		}
			
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
		else
			sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	};

	nonvirtual void () DeathSound =
	{
		// water death sounds
		if (self.waterlevel == 3)
		{
			bubble_spawner_c::Spawn(5, this);
			sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
			return;
		}
		
		float rs = rint ((random() * 4) + 1);
		if (rs == 1)
			self.noise = "player/death1.wav";
		if (rs == 2)
			self.noise = "player/death2.wav";
		if (rs == 3)
			self.noise = "player/death3.wav";
		if (rs == 4)
			self.noise = "player/death4.wav";
		if (rs == 5)
			self.noise = "player/death5.wav";

		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
		return;
	};

	nonvirtual void (entity attacker, float death_type) Obituary =
	{
		string msg = "";
		switch (attacker.classname)
		{
			case "teledeath":
				msg = strcat(this.netname, " was telefragged by ", attacker.owner.netname, "\n");
				break;
			case "teledeath2":
				msg = strcat("Satan's power deflects ", this.netname, "'s telefrag\n");
				break;
			case "teledeath3":
				msg = strcat(this.netname, " was telefragged by ", attacker.owner.netname, "'s Satan's power\n");
				break;
			case "selfwater":
				msg = strcat(this.netname, " electrocutes himself.\n");
				break;
		}

		/*switch (death_type)
		{
			case DMSG_TEAMKILL:
				msg = strcat(attacker.netname, " shoots his teammate one too many times\n");
				break;
			
		}*/
		// FIXME - do obituary, on classes?
		
	};

	nonvirtual void () PainSound =
	{
		self.weaponframe=0;
		if (self.health < 0)
			return;

		if (damage_attacker.classname == "teledeath")
		{
			sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
			return;
		}

	// water pain sounds
		switch (this.watertype)
		{
			case CONTENT_WATER:
				if (this.waterlevel == 3)
				{
					bubble_spawner_c::Spawn(1, this);
					if (random() > 0.5)
						sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
					else
						sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
					return;
				}
				break;
			case CONTENT_SLIME:
			case CONTENT_LAVA:
				if (random() > 0.5)
					sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
				else
					sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
				return;
				break;
		}

		if (self.pain_finished > time)
		{
			self.axhitme = 0;
			return;
		}
		self.pain_finished = time + 0.5;

	// don't make multiple pain sounds right after each other

	// ax pain sound
		if (self.axhitme == 1)
		{
			self.axhitme = 0;
			sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
			return;
		}

		float rs = rint((random() * 5) + 1);

		self.noise = "";
		if (rs == 1)
			self.noise = "player/pain1.wav";
		else if (rs == 2)
			self.noise = "player/pain2.wav";
		else if (rs == 3)
			self.noise = "player/pain3.wav";
		else if (rs == 4)
			self.noise = "player/pain4.wav";
		else if (rs == 5)
			self.noise = "player/pain5.wav";
		else
			self.noise = "player/pain6.wav";

		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	};

	nonvirtual void () Dead =
	{
		self.nextthink = -1;
		// allow respawn after a certain time
		self.deadflag = DEAD_DEAD;
	};

	// weapon ents call these, self is set to weapon ent
	static void () Anim_Nail1 = [$nailatt1, player_c::Anim_Nail2]
	{
		if (!nailgun_c::NailLogic(this))
			return;
	};

	static void () Anim_Nail2 = [$nailatt2, player_c::Anim_Nail1]
	{
		if (!nailgun_c::NailLogic(this))
			return;
	};
};

vector(float dm) VelocityForDamage =
{
	vector v;

	if (vlen(damage_inflictor.velocity)>0)
	{
		v = 0.5 * damage_inflictor.velocity;
		v = v + (25 * normalize(self.origin-damage_inflictor.origin));
		v_z = 100 + 240 * random();
		v_x = v_x + (200 * crandom());
		v_y = v_y + (200 * crandom());
	}
	else
	{
		v_x = 100 * crandom();
		v_y = 100 * crandom();
		v_z = 200 + 100 * random();
	}

	if (dm > -50)
	{
		v = v * 0.7;
	}
	else if (dm > -200)
	{
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
};

void(string gibname, float dm) ThrowGib =
{
	local   entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.frame = 0;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
};



