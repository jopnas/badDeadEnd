//[player:Object, didJIP:Boolean]
_player = _this select 0;
_didJIP = _this select 1;

_newUnitUID = getPlayerUID _player;

systemChat format["server: initPlayerServer %1",_player];
sleep 2;
[_player,_newUnitUID] remoteExecCall  ["fnc_loadPlayerStats",2];