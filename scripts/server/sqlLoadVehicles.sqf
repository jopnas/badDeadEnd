private["_spawnedVehicle","_type"];
_result = call compile ("extDB2" callExtension "0:SQL_VH_LOAD:SELECT * FROM vehicles");

waitUntil{count _result > 0 && _result select 0 > 0};
_CarsQueryStatus  = _result select 0;
_CarsInDB         = _result select 1;

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
	_type      = _x select 11;

    if(_destroyed == 1) then {
        _towns = nearestLocations [worldCenter, ["NameVillage","NameCity","NameCityCapital"], worldHalfSize];
        _roads = getPos selectRandom(_towns) nearRoads 1000;
        _roadPosition = getPos selectRandom(_roads);
        _position = _roadPosition findEmptyPosition [0,100,_classname];

        _spawnedVehicle = _classname createVehicle _position;
        _spawnedVehicle setVariable["id",_id,true];
        _spawnedVehicle setVariable["type",_type,true];

        _spawnedVehicle setDir random 180;
        _spawnedVehicle setFuel random 1;

        _allHitPoints = getAllHitPointsDamage _spawnedVehicle;
        _hitPointNames	= _allHitPoints select 0;
        _hitPointsCount = count _hitPointNames;
        for "_i" from 0 to _hitPointsCount do {
            if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, 0.3 + (random 0.7)];
            };
        };

        _spawnedVehicle setVehiclePosition [[_position select 0,_position select 1,(_position select 2) + 1], [], 0, ""];

        clearWeaponCargoGlobal _spawnedVehicle;
        clearMagazineCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

        [_spawnedVehicle] call fnc_saveVehicle;

    }else{
        _spawnedVehicle = _classname createVehicle _position;
        _spawnedVehicle setVariable["id",_id,true];
        _spawnedVehicle setVariable["type",_type,true];

        clearWeaponCargoGlobal _spawnedVehicle;
        clearMagazineCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

    	_spawnedVehicle setDir _rotation;
    	_spawnedVehicle setFuel _fuel;

    	{
    		_count_items = (_items select 1) select _foreachindex;
    		_spawnedVehicle addItemCargoGlobal[_x,_count_items];
    	} forEach (_items select 0);

    	{
    		_count_weapons = (_weapons select 1) select _foreachindex;
    		_spawnedVehicle addWeaponCargoGlobal [_x,_count_weapons];
    	} forEach (_weapons select 0);

    	{
    		_count_magazines = (_magazines select 1) select _foreachindex;
    		_spawnedVehicle addMagazineCargoGlobal [_x,_count_magazines];
    	} forEach (_magazines select 0);

    	{
    		_count_backpacks = (_backpacks select 1) select _foreachindex;
    		_spawnedVehicle addBackpackCargoGlobal [_x, _count_backpacks];
    	} forEach (_backpacks select 0);

    	_hitPointNames	= _damage select 0;
    	_hitPointValues	= _damage select 1;
    	_hitPointsCount = count _hitPointNames;

    	for "_i" from 0 to _hitPointsCount do {
    		if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
    		};
    	};
        _spawnedVehicle setPosATL _position;
    };

    // EventHandlers for saving vehicle to db
    _spawnedVehicle addEventHandler ["ContainerClosed", {
        params["_container","_player"];
        [_container] call fnc_saveVehicle;
        systemChat format["closed inventory of %1",typeOf _container];
    }];
    _spawnedVehicle addEventHandler ["Hit", {
        params["_unit","_causedBy","_damage"];
        [_unit] call fnc_saveVehicle;
        systemChat format["hit %1 by %2",typeOf _unit,_causedBy];
    }];
    _spawnedVehicle addEventHandler ["Killed", {
        params["_unit","_killer"];
        [_unit] call fnc_saveVehicle;
        deleteMarker format["vehicle %1",_unit getVariable "id"];
        systemChat format["destroyed %1",typeOf _unit];
    }];
    _spawnedVehicle addEventHandler ["Fuel", {
        params["_vehicle","_fuelState"];
        [_vehicle] call fnc_saveVehicle;
        systemChat format["fuel state changed from %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["GetOut", {
        params["_vehicle","_position","_unit","_turret"];
        [_vehicle] call fnc_saveVehicle;
        systemChat format["%1 exit %2",_unit,typeOf _vehicle];
    }];

    // Debug Marker
    if(_type == "heli")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_air";
    	_markerstr setMarkerColor "ColorGreen";
    };
    if(_type == "car")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_car";
    	_markerstr setMarkerColor "ColorBlue";
    };

} forEach _CarsInDB;
