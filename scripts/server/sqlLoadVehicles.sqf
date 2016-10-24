_result = call compile ("extDB2" callExtension "0:SQL_VH_LOAD:SELECT * FROM vehicles");

waitUntil{count _result > 0 && _result select 0 > 0};
_vehiclesQueryStatus  = _result select 0;
_vehiclesInDB         = _result select 1;

{
    private["_spawnedVehicle","_type","_vehPosition"];
	_id        = _x select 0;
	_classname = _x select 1;
	_position  = _x select 2;
	_rotation  = _x select 3;
	_fuel      = _x select 4;
	_destroyed = _x select 5;
	_type      = _x select 6;
	_damage    = _x select 7;
	_items     = _x select 8;
	_weapons   = _x select 9;
	_magazines = _x select 10;
	_backpacks = _x select 11;

    _bde_fnc_randRoadPos = {
        params["_classname"];
        _towns = nearestLocations [worldCenter, ["NameVillage","NameCity","NameCityCapital"], worldHalfSize];
        _roads = getPos selectRandom(_towns) nearRoads 1000;
        _roadPosition = getPos selectRandom(_roads);
        _position1 = _roadPosition findEmptyPosition [0,100,_classname];
        _position1
    };

    _bde_fnc_randAirfieldPos = {
        _possiblePlanePositions = [];
        _rdmPlanePos = [0,0,0];

        // Hangars
        _allHangars = nearestObjects [worldCenter, ["Land_Hangar_F","Land_TentHangar_V1_F"], worldHalfSize];
        {
            _hangarPos = getPos _x;
            _hangarDir = (getDir _x) - 180;
            _possiblePlanePositions pushBack [_hangarPos,_hangarDir];

            /*_markerstr = createMarker [format["hangar%1",_foreachindex],_hangarPos];
            _markerstr setMarkerShape "ICON";
            _markerstr setMarkerType "mil_arrow";*/

            //_markerstr setMarkerDir _hangarDir;
            //_testplane = "C_Plane_Civil_01_F" createVehicle (getPosATL _x);
            //_testplane setDir _hangarDir;
        } forEach _allHangars;

        // Primary Airfield
        _afMainPos  = getArray (configFile >> "CfgWorlds" >> worldName >> "ilsPosition");
        _ilsDir     = getArray (configFile >> "CfgWorlds" >> worldName >> "ilsDirection");

        //_markerstr = createMarker ["airfieldMain",_afMainPos];
        //_markerstr setMarkerShape "ICON";
        //_markerstr setMarkerType "mil_arrow";

        _getDirHelper = "Sign_Arrow_Direction_Yellow_F" createVehicle _afMainPos;
        _getDirHelper setVectorDir  [_ilsDir select 0,_ilsDir select 2,(_ilsDir select 1) * (-1)];
        _getDirHelper setDir ((getDir _getDirHelper) - 180);
        _afMainDir getDir _getDirHelper;
        deleteVehicle _getDirHelper;

        //_markerstr setMarkerDir _afMainDir;
        _possiblePlanePositions pushBack [_afMainPos,_afMainDir];

        // Secondary Airfields
        _airfields   = (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports") call BIS_fnc_getCfgSubClasses;
        {
            private["_pos","_dir","_ilsDir"];
            _afSecPos = getArray (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports" >> _x >> "ilsPosition");
            _ilsDir = getArray (configFile >> "CfgWorlds" >> worldName >> "SecondaryAirports" >> _x >> "ilsDirection");

            //_markerstr = createMarker [format["airfieldNo%1",_foreachindex],_afSecPos];
            //_markerstr setMarkerShape "ICON";
            //_markerstr setMarkerType "mil_arrow";

            //_testplane = "C_Plane_Civil_01_F" createVehicle _afSecPos;
            //_testplane setVectorDir [_ilsDir select 0,_ilsDir select 2,(_ilsDir select 1) * (-1)];
            //_testplane setDir ((getDir _testplane) - 180);

            //_markerstr setMarkerDir (getDir _testplane);

            _getDirHelper = "Sign_Arrow_Direction_Yellow_F" createVehicle _afSecPos;
            _getDirHelper setVectorDir  [_ilsDir select 0,_ilsDir select 2,(_ilsDir select 1) * (-1)];
            _getDirHelper setDir ((getDir _getDirHelper) - 180);
            _afSecDir getDir _getDirHelper;
            deleteVehicle _getDirHelper;

            _possiblePlanePositions pushBack [_afSecPos,_afSecDir];
        } forEach _airfields;

        _rdmPlanePos = selectRandom _possiblePlanePositions;
        _rdmPlanePos
    };

    _bde_fnc_randHeliportPos = {
        _helipads = nearestObjects [worldCenter, ["Land_HelipadSquare_F","Land_HelipadRescue_F","Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F"], worldHalfSize];
        _rdmHelipad = selectRandom _helipads;
        _heliportPosition = getPosATL _rdmHelipad;
        _heliportPosition
    };

    if(_destroyed == 1) then {
        _vehPosition = [0,0,0];
        _vehDirection = 0;
        if(_type == "heli")then{
            _vehPosition = [] call _bde_fnc_randHeliportPos;
        };
        if(_type == "car")then{
            _vehPosition = [_classname] call _bde_fnc_randRoadPos;
        };
        if(_type == "plane")then{
            //_vehPosition = [_classname] call _bde_fnc_randRoadPos;
            _vehPosition  = ([] call _bde_fnc_randAirfieldPos) select 0;
            _vehDirection = ([] call _bde_fnc_randAirfieldPos) select 1;
        };

        //systemchat str _vehPosition;

        _spawnedVehicle = _classname createVehicle _vehPosition;
        _spawnedVehicle setVariable["id",_id,true];

        if(_type == "plane")then{
            _spawnedVehicle setDir _vehDirection;
        };/*else{
            _spawnedVehicle setDir random 360;
        };*/

        _spawnedVehicle setFuel random 1;

        _allHitPoints = getAllHitPointsDamage _spawnedVehicle;
        _hitPointNames	= _allHitPoints select 0;
        _hitPointsCount = count _hitPointNames;
        for "_i" from 0 to _hitPointsCount do {
            if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, 0.3 + (random 0.7)];
            };
        };

        clearWeaponCargoGlobal _spawnedVehicle;
        clearMagazineCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

        [_spawnedVehicle] call fnc_saveVehicle;

    }else{
        _spawnedVehicle = createVehicle [_classname,_position,[],0,"can_collide"];
        _spawnedVehicle setVectorDirAndUp  _rotation;
        _spawnedVehicle setVehiclePosition [_position, [], 0, "can_collide"];

        _spawnedVehicle setVariable["id",_id,true];
        _spawnedVehicle setVariable["type",_type,true];

        clearMagazineCargoGlobal _spawnedVehicle;
        clearBackpackCargoGlobal _spawnedVehicle;
        clearWeaponCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

    	_spawnedVehicle setFuel _fuel;

        if(str _items != "[[],[]]")then{
        	{
        		_count_items = (_items select 1) select _foreachindex;
        		_spawnedVehicle addItemCargoGlobal[_x,_count_items];
        	} forEach (_items select 0);
        };

        if(str _weapons != "[[],[]]")then{
        	{
        		_count_weapons = (_weapons select 1) select _foreachindex;
        		_spawnedVehicle addWeaponCargoGlobal [_x,_count_weapons];
        	} forEach (_weapons select 0);
        };

        if(str _magazines != "[[],[]]")then{
        	{
        		_count_magazines = (_magazines select 1) select _foreachindex;
        		_spawnedVehicle addMagazineCargoGlobal [_x,_count_magazines];
        	} forEach (_magazines select 0);
        };

        if(str _backpacks != "[[],[]]")then{
        	{
        		_count_backpacks = (_backpacks select 1) select _foreachindex;
        		_spawnedVehicle addBackpackCargoGlobal [_x, _count_backpacks];
        	} forEach (_backpacks select 0);
        };

    	_hitPointNames	= _damage select 0;
    	_hitPointValues	= _damage select 1;
    	_hitPointsCount = count _hitPointNames;

    	for "_i" from 0 to _hitPointsCount do {
    		if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
    		};
    	};
    };

    // EventHandlers for saving vehicle to db
    _spawnedVehicle addEventHandler ["ContainerClosed", {
        params["_vehicle","_player"];
        [_vehicle] call fnc_saveVehicle;
        //systemChat format["closed inventory of %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["Hit", {
        params["_vehicle","_causedBy","_damage"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        //systemChat format["hit %1 by %2",typeOf _vehicle,_causedBy];
    }];
    _spawnedVehicle addEventHandler ["Killed", {
        params["_vehicle","_killer"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        deleteMarker format["vehicle %1",_vehicle getVariable "id"];
        //systemChat format["destroyed %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["Fuel", {
        params["_vehicle","_fuelState"];
        [_vehicle] call fnc_saveVehicle;
        //systemChat format["fuel state changed from %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["GetOut", {
        params["_vehicle","_position","_unit","_turret"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        //systemChat format["%1 exit %2",_unit,typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["GetIn", {
        params["_vehicle","_position","_unit","_turret"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        //systemChat format["%1 enters %2",_unit,typeOf _vehicle];
    }];

    // Actions (repair etc.)
    _spawnedVehicle setVariable ["repairActionIDs", [], false];
    _spawnedVehicle addAction[format["repair %1",_type],{
        _spawnedVehicle = _this select 3;
        [_spawnedVehicle] execVM "scripts\vehicles\repairVehicleActions.sqf";
    },_spawnedVehicle,0,false,false,"","vehicle _this == _this && count (_target getVariable ['repairActionIDs', []]) == 0",3,false];

    _spawnedVehicle addAction[format["refuel %1",_type],{
        _target = _this select 0;
        _caller = _this select 1;
        _type   = _this select 3;
        if(fuel _target + 0.5 > 1)then{
            _target setFuel 1;
        }else{
            _target setFuel (fuel _target + 0.5);
        };
        _caller removeMagazine "bde_fuelCanisterFilled";
        _caller addMagazine "bde_fuelCanisterEmpty";
    },_type,0,false,false,"","'bde_fuelCanisterFilled' in Magazines _this && vehicle _this == _this && fuel _target < 1",3,false];

    // Debug
    if(_type == "heli")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_air";
        _markerstr setMarkerColor "ColorGreen";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };
    if(_type == "car")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_car";
        _markerstr setMarkerColor "ColorBlue";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };
    if(_type == "plane")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_plane";
        _markerstr setMarkerColor "ColorBlue";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };
    sleep 0.1;
} forEach _vehiclesInDB;