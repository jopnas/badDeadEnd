_playerUnit = _this select 0;

_rdmSpawnPos = [];

/*_towns = nearestLocations [[16000,16000], ["NameVillage","NameCity","NameCityCapital"], 12000];
_rdmTown = selectRandom _towns;
_roadsNearRdmTown = getPos _rdmTown nearRoads 1000;
_rdmSpawnPos = selectRandom _roadsNearRdmTown;*/

_forests = selectBestPlaces [[16000,16000], 12000, "(1 + forest + trees) * (1 - sea) * (1 - houses)", 30, 20];
_forests = _forests apply {_x select 0};
_rdmSpawnPos = (selectRandom _forests) findEmptyPosition [0, 10, "C_man_1"];

waitUntil {count _rdmSpawnPos > 0};
_playerUnit setPosATL getPos(_rdmSpawnPos);
_playerUnit setVariable["playerSetupReady",true,false];
