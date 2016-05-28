_playerUnit = _this select 0;
_towns = nearestLocations [[16000,16000], ["NameVillage","NameCity","NameCityCapital"], 12000];
_rdmTown = _towns call BIS_fnc_selectRandom;
_roadsNearRdmTown = getPos _rdmTown nearRoads 1000;

_rdmSpawnPos = _roadsNearRdmTown call BIS_fnc_selectRandom;
_playerUnit setPosATL getPos(_rdmSpawnPos);
_playerUnit setVariable["playerSetupReady",true];