//fSpawnCar = compile preprocessFile "scripts\vehicles\spawnCar.sqf";
loadedCarsList = [];
fnc_loadCars = compile preprocessFile "scripts\server\sqlLoadCars.sqf";
[] call fnc_loadCars;

/*_towns = nearestLocations [[16000,16000], ["NameVillage","NameCity","NameCityCapital"], 12000];
{
	_xTown = _x;
	_roads = getPos _xTown nearRoads 1000;
	{
		_xRoad = _X;
		_xRoadPosition = getPos _xRoad;
		if(random 100 < 0.1)then{
			[_xRoadPosition] spawn fSpawnCar;
		}
		
	} forEach _roads;
} forEach _towns;*/