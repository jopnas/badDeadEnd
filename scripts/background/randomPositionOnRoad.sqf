private["_centerPos","_searchRadius","_towns","_rdmTown","_roadsNearRdmTown","_rdmSpawnPos"];
_centerPos      = _this select 0;
_searchRadius   = _this select 1;

_towns = nearestLocations [_centerPos, ["NameVillage","NameCity","NameCityCapital"], _searchRadius];

_rdmTown = selectRandom _towns;
_roadsNearRdmTown = getPos _rdmTown nearRoads 1000;

_rdmSpawnPos = selectRandom _roadsNearRdmTown;

_rdmSpawnPos
