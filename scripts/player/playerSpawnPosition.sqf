_playerUnit = _this select 0;
_towns = nearestLocations [[16000,16000], ["NameVillage","NameCity","NameCityCapital"], 12000];
_rdmTown = selectRandom _towns;
_roadsNearRdmTown = getPos _rdmTown nearRoads 1000;

_rdmSpawnPos = selectRandom _roadsNearRdmTown;
_playerUnit setPosATL getPos(_rdmSpawnPos);

_playerUnit setVariable["playerSetupReady",true,false];
