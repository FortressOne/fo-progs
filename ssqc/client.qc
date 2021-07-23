/*
	client.qc

	client functions

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

void() SetChangeParms =
{

};

void() SetNewParms =
{

};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	player_c player = (player_c)self;
	player.Suicide();
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity () SelectSpawnPoint = {
	entity spot, thing, spots;
	float numspots = 0, totalspots = 0, pcount;

// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point

// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");       
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 84);
		pcount=0;               
		while (thing)
		{
			if (thing.classname == "player")
				pcount=pcount + 1;                      
			thing=thing.chain;      
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");                
	}
	totalspots=totalspots - 1;
	if (!numspots) {
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");       
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		return spot;
	}
		
// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;
	
	numspots = rint((random() * numspots ) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;
};

/*
===========
PutClientInServer

called each time a player enters a new level
============
*/
void() PutClientInServer = {
	spawnfunc_player_c();
	player_c player = (player_c)self;
	player.Respawn(FALSE);
};

//============================================================================
// FIXME - does engine use this directly? No references, not in defs
void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{       // solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{       // open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;  // safety net
			return;
		}
	}
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink = {
	player_c player = (player_c)self;
	player.PreThink();
};

/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink = {
	player_c player = (player_c)self;
	player.PostThink();
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void (optional float csqcactive) ClientConnect = {
	bprint (PRINT_HIGH, self.netname, " entered the game\n");
	
// a client connecting during an intermission can cause problems
	if (GameManager.intermission_running)
		GameManager.GotoNextMap();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	bprint(PRINT_HIGH, self.netname, " left the game with ", ftos(self.frags), " frags\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	player_c player = (player_c)self;
	player.SetSuicideFrame();
};