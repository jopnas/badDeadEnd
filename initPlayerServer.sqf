//[player:Object, didJIP:Boolean]
_player = _this select 0;
_didJIP = _this select 1;

_newUnitUID = getPlayerUID _player;
[_player,_newUnitUID] remoteExecCall ["fnc_loadPlayerStats",2];
