//[player:Object, didJIP:Boolean]
_player = _this select 0;
_didJIP = _this select 1;

_newUnitUID = getPlayerUID _player;

sleep 5;
[_player,_newUnitUID] call fnc_loadPlayerStats;
