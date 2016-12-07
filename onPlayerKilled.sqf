//[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
_oldUnit 		= _this select 0;
_killer 		= _this select 1;
_respawn 		= _this select 2;
_respawnDelay 	= _this select 3;

systemChat "onPlayerKilled.sqf";
cutText ["You died ...", "BLACK"];
[getPlayerUID player] call fnc_deletePlayerStats;
