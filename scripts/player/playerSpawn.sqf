private["_db","_dbAll","_playerUnit","_isRespawn"];
_playerUnit = player;

systemChat "client: init playerSpawn.sqf";

waitUntil { player getVariable ["playerDBstats",false] isEqualType [] };

_playerDBstats = _playerUnit getVariable "playerDBstats";
_db = _playerDBstats select 0;
_dbAll = _playerDBstats select 1;

if(!(_dbAll isEqualTo []))then{
    _isRespawn = false;
}else{
    _isRespawn = true;
};

// Player Setup
_playerUnit enableFatigue false;
enableCamShake true;

// Player Equipment Reset
removeAllWeapons _playerUnit;
removeAllAssignedItems _playerUnit;
removeBackpack _playerUnit;
removeVest _playerUnit;
removeHeadgear _playerUnit;
removeGoggles _playerUnit;
removeUniform _playerUnit;

if(!(_isRespawn))then{
	_playerPosition        = _db select 0;
	_playerStance          = _db select 1;

	_hunger                = _db select 2;
	_thirst                = _db select 3;
	_health                = _db select 4;
	_temperature           = _db select 5;
	_wet				   = _db select 6;
	_sick                  = _db select 7;
	_infected			   = _db select 8;

	_playerDirection       = _db select 9;
	_playerDamage          = _db select 10;
    _currentWeapon         = _db select 11;
    _loadout               = _db select 12;
    _playersDog			   = _db select 13;
    _poisoning	           = _db select 14;
    _radiation	           = _db select 15;


	// Player Variables
    _playerUnit setVariable ["playerHunger",_hunger,true];
    _playerUnit setVariable ["playerThirst",_thirst,true];
    _playerUnit setVariable ["playerHealth",_health,true];
    _playerUnit setVariable ["playerTemperature",_temperature,true];
    _playerUnit setVariable ["playerWet",_wet,true];
    _playerUnit setVariable ["playerSick",_sick,true];
    _playerUnit setVariable ["playerInfected",_infected,true];
    _playerUnit setVariable ["playerPoisoning",_poisoning,true];
    _playerUnit setVariable ["playerRadiation",_radiation,true];

    _playerUnit setUnitLoadout [_loadout, false];

    _playerUnit switchMove _playerStance;

    if(_currentWeapon == "")then{
        _playerUnit action["SwitchWeapon",_playerUnit,_playerUnit,100];
        _playerUnit switchCamera cameraView;
    };

	// Set Position
    _playerUnit setDir _playerDirection;
    _playerUnit setPosATL _playerPosition;

    // Player's Dog
    /*if(_playersDog != "")then{
        _playersDog = createAgent [_playersDog, getPos _playerUnit, [], 0, ""];
        _playersDog setVariable["dogID", 0,false];
        _playersDog setVariable["bestFriend", "76561197984281873",false];
        _playerUnit setVariable["playersDog",_playersDog,false];

        _markerstr = createMarker [format["dog %1",0], getPos _playersDog];
        _markerstr setMarkerType "c_unknown";
        _markerstr setMarkerColor "ColorPink";
        _markerstr setMarkerText format["_playersDog",_playersDog];

        // Dogbag
        _dogBag = createVehicle ["bde_dogbag", getPos _playersDog, [], 0, "can_collide"];
        _dogBag attachTo [_playersDog, [0,-0.6,-0.1],"Spine2"]; // Works: Head,Spine2
        _dogBag setVectorDirAndUp [[0,0,1],[0,1,0]];

        // Test Inventory Doggybag
        _dogBag addEventHandler ["ContainerClosed", {
            params["_bag","_player"];

            _items		= getItemCargo _bag;
            _weapons	= getWeaponCargo _bag;
            _magazines	= getMagazineCargo _bag;
            _backpacks	= getBackpackCargo _bag;

            systemChat str _magazines;
        }];

        _playerUnit addAction ["call dog", {
            _caller = _this select 1;
            _dog    = _this select 3;
            [_caller,"dogwhistle0",0,0] remoteExec ["bde_fnc_say3d",0,false];

            _dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
            _dog playMove "Dog_Sprint";
            while {alive _caller} do {
                if(_dog distance _caller < 3 || !(alive _caller)) exitWith {
                    _dog setVariable ["BIS_fnc_animalBehaviour_disable", false];
                    _dog playMove "Dog_Idle_Bark";
                    sleep 7;
                    _dog playMove "Dog_Sit";
                    sleep (10 + floor(random 20));
                    _dog playMove "Dog_Idle_Walk";
                };
                _dog moveTo (getPos _caller);
                sleep 0.5;
            };
        }, _playersDog,1,false,false,"","vehicle _this == _this",10000,false];

        _playersDog addEventHandler["AnimStateChanged",{
            params["_dog","_anim"];
            if(_anim == "dog_idle_bark")then{
                [_dog,"dogBarkAniSync",0,0.5] remoteExec ["bde_fnc_say3d",0,false];
            };
        }];

        _playersDog addEventHandler["Dammaged",{
            params["_dog"];
            [_dog,"dogWhine01",0,0] remoteExec ["bde_fnc_say3d",0,false];
        }];
    };*/

  	_hitPointNames	= _playerDamage select 0;
	_hitPointValues	= _playerDamage select 1;
	_hitPointsCount = count _hitPointNames;

	for "_i" from 0 to _hitPointsCount do {
		if(count(_hitPointNames select _i) > 0)then{
			_playerUnit setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
		};

      if(_i >= _hitPointsCount)then{
        _playerUnit setVariable["playerSetupReady",true,true];
      };
	};

}else{
    _playerUnit setVariable ["playerHunger",100,true];
    _playerUnit setVariable ["playerThirst",100,true];
    _playerUnit setVariable ["playerHealth",100,true];
    _playerUnit setVariable ["playerTemperature",100,true];
    _playerUnit setVariable ["playerWet",0,true];
    _playerUnit setVariable ["playerSick",0,true];
    _playerUnit setVariable ["playerInfected",0,true];
    _playerUnit setVariable ["playerPoisoning",0,true];
    _playerUnit setVariable ["playerRadiation",0,true];

    _playerUnit setDamage 0;
    _isRespawn = true;
    _forests = selectBestPlaces [worldCenter, worldHalfSize, "(1 + (forest * 2) + (trees * 2)) * (1 - sea) * (1 - (houses * 2)) * (1 -  (meadow * 2)) * (1 - (deadBody * 2))", 30, 20];
    _forestPlaces = _forests apply {_x select 0};
    _rdmSpawnPos = (_forestPlaces select 0) findEmptyPosition [0, 10, "C_man_1"];
    _playerUnit setPosATL _rdmSpawnPos;
    _playerUnit setVariable["playerSetupReady",true,true];
};

waitUntil {
    _playerUnit getVariable["playerSetupReady",false];
};

_playerUnit addAction["Arsenal",{
    ["Open",true] spawn BIS_fnc_arsenal;
},[],1,false,false,"",""];

// Player Init
[_playerUnit,_isRespawn] execVM "scripts\player\playerWhileAlive.sqf";

// Init BDE GUI
3 cutRsc ['playerStatusGUI', 'PLAIN',3,false];

// Action Eventhandler
actionHandler = compile preprocessFile "scripts\player\actionHandler.sqf";
inGameUISetEventHandler ["Action", "[_this] call actionHandler"];

// Inventory Items Actions
inventoryItems = compile preprocessFile "scripts\inventory\inventoryItems.sqf";
fnc_coordinateItemActions = {
    _idcData    = _this select 0;
    _bagType    = _this select 1;
    _clickPos   = _this select 2;

    _idc = ctrlIDC (_idcData select 0);
    _selectedIndex = _idcData select 1;

    [_idc,_selectedIndex,_bagType,_clickPos,_idcData] spawn inventoryItems;
    false
};

_initInventoryActionHandler = [_playerUnit] spawn {
    params["_playerUnit"];
	while {alive _playerUnit} do {
        invClickPos = [0,0];
		waituntil {!(isnull (finddisplay 602))};

        // Get Click Position
        ((findDisplay 602) displayCtrl 633) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];if(str ((findDisplay 602) displayCtrl 2501) != 'no Control')then{ctrlDelete ((findDisplay 602) displayCtrl 2501);};"]; // Uniform
        ((findDisplay 602) displayCtrl 638) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];if(str ((findDisplay 602) displayCtrl 2501) != 'no Control')then{ctrlDelete ((findDisplay 602) displayCtrl 2501);};"]; // Vest
        ((findDisplay 602) displayCtrl 619) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];if(str ((findDisplay 602) displayCtrl 2501) != 'no Control')then{ctrlDelete ((findDisplay 602) displayCtrl 2501);};"]; // Backpack

        // Items Action
        ((findDisplay 602) displayCtrl 633) ctrlSetEventHandler ["LBDblClick", "[_this,['Uniform',633],invClickPos] call fnc_coordinateItemActions"]; // Uniform
        ((findDisplay 602) displayCtrl 638) ctrlSetEventHandler ["LBDblClick", "[_this,['Vest',638],invClickPos] call fnc_coordinateItemActions"]; // Vest
        ((findDisplay 602) displayCtrl 619) ctrlSetEventHandler ["LBDblClick", "[_this,['Backpack',619],invClickPos] call fnc_coordinateItemActions"]; // Backpack

        if(!(alive _playerUnit)) exitWith {};
		waituntil {isnull (finddisplay 602)};
        if(!(alive _playerUnit)) exitWith {};
	};
};