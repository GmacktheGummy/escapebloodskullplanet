class_name AreaBoxBehavior
extends Area3D

enum FACTION_ENUM {
	PLAYER = 0,
	ENEMY = 1,
	GAIA = 2,
	POWERUP = 3
};

@export var Faction : FACTION_ENUM = FACTION_ENUM.GAIA;
