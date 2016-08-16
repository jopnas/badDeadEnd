//[<oldUnit>, <killer>, <respawn>, <respawnDelay>]
_oldUnit 		= _this select 0;
_killer 		= _this select 1;
_respawn 		= _this select 2;
_respawnDelay 	= _this select 3;

[getPlayerUID player] remoteExec ["fnc_deletePlayerStats",2,false];
cutText ["You died ...", "BLACK"];