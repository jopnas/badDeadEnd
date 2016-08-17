//[<newUnit>, <oldUnit>, <respawn>, <respawnDelay>]
_newUnit = _this select 0;
_oldUnit = _this select 1;
_respawn = _this select 2;
_respawnDelay = _this select 3;

_newUnitUID     = getPlayerUID _newUnit;
[_newUnit,_newUnitUID] remoteExecCall ["fnc_loadPlayerStats",2,false];
