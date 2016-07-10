private["_spawnedCar"];
_CarsQuery        = call compile ("extDB2" callExtension "0:SQL_VH_LOAD:SELECT id,classname,position,rotation,fuel,damage,destroyed,items,weapons,magazines,backpacks FROM vehicles");
_CarsQueryStatus  = _CarsQuery select 0;
_CarsInDB         = _CarsQuery select 1;

waitUntil { _CarsQueryStatus > 0 };
loadedCarsList = loadedCarsList - ["empty"];
{
	_id        = _x select 0;
	_classname = _x select 1;
	_position  = _x select 2;
	_rotation  = _x select 3;
	_fuel      = _x select 4;
	_damage    = _x select 5;
	_destroyed = _x select 6;
	_items     = _x select 7;
	_weapons   = _x select 8;
	_magazines = _x select 9;
	_backpacks = _x select 10;

    if(_destroyed > 0)then{
        _towns = nearestLocations [worldCenter, ["NameVillage","NameCity","NameCityCapital"], worldHalfSize];
        _roads = getPos selectRandom(_towns) nearRoads 1000;
        _roadPosition = getPos selectRandom(_roads);

        _spawnedCar = _classname createVehicle _roadPosition;
        _spawnedCar setVariable["id",_id,true];

        _spawnedCar setDir random 180;
        _spawnedCar setFuel random 1;

        _allHitPoints = getAllHitPointsDamage _spawnedCar;
        _hitPointNames	= _allHitPoints select 0;
        _hitPointsCount = count _hitPointNames;
        for "_i" from 0 to _hitPointsCount do {
            if(count(_hitPointNames select _i) > 0)then{
                _spawnedCar setHitPointDamage [_hitPointNames select _i, 0.3 + (random 0.7)];
            };
        };

        _spawnedCar setVehiclePosition [[_roadPosition select 0,_roadPosition select 1,(_roadPosition select 2) + 1], [], 0, "NONE"];

        clearWeaponCargoGlobal _spawnedCar;
        clearMagazineCargoGlobal _spawnedCar;
        clearItemCargoGlobal _spawnedCar;

        [_spawnedCar] call fnc_saveCar;

    }else{
        _spawnedCar = _classname createVehicle _position;
        _spawnedCar setVariable["id",_id,true];

        clearWeaponCargoGlobal _spawnedCar;
        clearMagazineCargoGlobal _spawnedCar;
        clearItemCargoGlobal _spawnedCar;

    	_spawnedCar setDir _rotation;
    	_spawnedCar setFuel _fuel;

    	{
    		_count_items = (_items select 1) select _foreachindex;
    		_spawnedCar addItemCargoGlobal[_x,_count_items];
    	} forEach (_items select 0);

    	{
    		_count_weapons = (_weapons select 1) select _foreachindex;
    		_spawnedCar addWeaponCargoGlobal [_x,_count_weapons];
    	} forEach (_weapons select 0);

    	{
    		_count_magazines = (_magazines select 1) select _foreachindex;
    		_spawnedCar addMagazineCargoGlobal [_x,_count_magazines];
    	} forEach (_magazines select 0);

    	{
    		_count_backpacks = (_backpacks select 1) select _foreachindex;
    		_spawnedCar addBackpackCargoGlobal [_x, _count_backpacks];
    	} forEach (_backpacks select 0);

    	_hitPointNames	= _damage select 0;
    	_hitPointValues	= _damage select 1;
    	_hitPointsCount = count _hitPointNames;

    	for "_i" from 0 to _hitPointsCount do {
    		if(count(_hitPointNames select _i) > 0)then{
                _spawnedCar setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
    		};
    	};
        _spawnedCar setVehiclePosition [[_position select 0,_position select 1,(_position select 2) + 1], [], 0, "NONE"];
    };

	loadedCarsList pushBackUnique _classname;

    _markerstr = createMarker [format["car %1",_id] , _position];
	_markerstr setMarkerShape "ICON";
	_markerstr setMarkerType "c_car";
	_markerstr setMarkerColor "ColorGreen";

    sleep 0.5;
} forEach _CarsInDB;
