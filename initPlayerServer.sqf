//[player:Object, didJIP:Boolean]
_player = _this select 0;
_didJIP = _this select 1;
//[_player,getPlayerUID _player] spawn fnc_loadPlayerStats;
[_player,getPlayerUID _player] remoteExecCall ["fnc_loadPlayerStats",2];