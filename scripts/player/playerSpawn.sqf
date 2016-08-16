private["_respawnTime","_db","_fnc_dogBehaviour"];
_playerUnit     = _this select 0;
_respawnTime    = 5;

sleep 5;
_db = (_playerUnit getVariable["db",[]]);

// Player Setup
_playerUnit enableFatigue false;
enableCamShake true;

_PlayerUID	= getPlayerUID _playerUnit;

_isRespawn = false;

// Player Equipment Reset
removeAllWeapons _playerUnit;
removeAllAssignedItems _playerUnit;
removeBackpack _playerUnit;
removeVest _playerUnit;
removeHeadgear _playerUnit;
removeGoggles _playerUnit;
removeUniform _playerUnit;

// Player Default Variables
playerHunger = 100;
playerThirst = 100;
playerHealth = 100;
playerTemperature = 100;
playerNoise = 0;
playerWet = 0;
playerSick = 0;
playerInfected = 0;

if(count _db > 0)then{
	_playerStats 			= _db;
	_playerWeapons			= _playerStats select 2;
	_playerPosition			= _playerStats select 3;

	_playerItemsBackpack	= _playerStats select 4;
	_playerItemsVest		= _playerStats select 5;
	_playerItemsUniform		= _playerStats select 6;

	_playerUniform			= _playerStats select 7;
	_playerVest				= _playerStats select 8;
	_playerBackpack			= _playerStats select 9;

	_playerStance			= _playerStats select 10;

	_hunger					= _playerStats select 11;
	_thirst					= _playerStats select 12;
	_health					= _playerStats select 13;
	_temperature			= _playerStats select 14;
	_wet					= _playerStats select 15;
	_sick					= _playerStats select 16;
	_infected				= _playerStats select 17;

	_primWeapItems			= _playerStats select 18;
	_secWeapItems			= _playerStats select 19;
	_handgunItems			= _playerStats select 20;

	_primWeapMag			= _playerStats select 21;
	_secWeapMag				= _playerStats select 22;
	_handgunMag				= _playerStats select 23;

	_headgear				= _playerStats select 24;
	_assignedItems			= _playerStats select 25;
	_goggles				= _playerStats select 26;

	_primWeapAmmo			= _playerStats select 27;
	_secWeapAmmo			= _playerStats select 28;
	_handgunAmmo			= _playerStats select 29;

	_playerDirection		= _playerStats select 30;
	_currentWeapon			= _playerStats select 31;
	_playerDamage			= _playerStats select 32;
    _loadout                = _playerStats select 33;
    _playersDog			    = _playerStats select 34;

    //systemChat str _loadout;

	// Player Variables
	playerHunger = _hunger;
	playerThirst = _thirst;
	playerHealth = _health;
	playerTemperature = _temperature;
	playerWet = _wet;
	playerSick = _sick;
	playerInfected = _infected;

    switch(_playerStance)do{
        case "CROUCH": {
            _playerUnit switchMove "AmovPcrhMstpSrasWpstDnon_AadjPcrhMstpSrasWpstDdown";
        };
        case "PRONE": {
            sleep 0.1;
            _playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
        };
    };


	// Set Position
    _playerUnit setDir _playerDirection;
    _playerUnit setPosATL _playerPosition;

	// Set Uniform
	if(_playerUniform != "")then{
		_playerUnit forceAddUniform _playerUniform;
	};

	// Set Vest
	if(_playerVest != "")then{
		_playerUnit addVest _playerVest;
	};

	// Set Backpack
	if(_playerBackpack != "")then{
		_playerUnit addBackpack _playerBackpack;
	};

    // Magazines loaded in weapons

    if(_playerBackpack == "" && _playerVest == "" && _playerUniform == "")then{ //add backpack for loaded magazines
        _playerUnit addBackpack "B_AssaultPack_khk";
    };

    if(str _primWeapMag != "[]" && str _primWeapMag != "")then{
    	{
    		_playerUnit addMagazine[_x,1];
    	}forEach _primWeapMag;
    };

    if(str _secWeapMag != "[]" && str _secWeapMag != "")then{
        {
    		_playerUnit addMagazine[_x,1];
    	}forEach _secWeapMag;
    };

    if(str _handgunMag != "[]" && str _handgunMag != "")then{
    	{
    		_playerUnit addMagazine[_x,1];
    	}forEach _handgunMag;
    };

	// Add Weapons
    if(str _playerWeapons != "[]" && str _playerWeapons != "")then{
    	{
    		_playerUnit addWeapon _x;
    	}forEach _playerWeapons;

        _playerUnit setAmmo [primaryWeapon _playerUnit, _primWeapAmmo];
        _playerUnit setAmmo [secondaryWeapon _playerUnit, _secWeapAmmo];
        _playerUnit setAmmo [handgunWeapon _playerUnit, _handgunAmmo];
    };

    if(_playerBackpack == "" && _playerVest == "" && _playerUniform == "")then{  //remove backpack for loaded magazines
            removeBackpack _playerUnit;
    };

    if(_currentWeapon != "")then{
        _playerUnit selectWeapon _currentWeapon;
    };

	// Weapon Attachments
    if(str _primWeapItems != "[]" && str _primWeapItems != "")then{
    	{
    		_playerUnit addPrimaryWeaponItem _x;
    	}forEach _primWeapItems;
    };

    if(str _secWeapItems != "[]" && str _secWeapItems != "")then{
    	{
    		_playerUnit addSecondaryWeaponItem _x;
    	}forEach _secWeapItems;
    };

    if(str _handgunItems != "[]" && str _handgunItems != "")then{
    	{
    		_playerUnit addHandgunItem _x;
    	}forEach _handgunItems;
    };

    if(_headgear != "")then{
    	_playerUnit addHeadgear _headgear;
	};

    if(str _assignedItems != "[]" && str _assignedItems != "")then{
    	{
    		//_playerUnit addItem _x;
    		_playerUnit addWeapon _x;
    		_playerUnit assignItem _x;
    	}forEach _assignedItems;
    };

    if(_goggles != "")then{
    	_playerUnit addGoggles _goggles;
    };

    // Set Items Backpack
    if(str _playerItemsBackpack != "[]" && str _playerItemsBackpack != "")then{
    	{
    		_playerUnit addItemToBackpack _x;
    	}forEach _playerItemsBackpack;
    };

	// Set Items Vest
    if(str _playerItemsVest != "[]" && str _playerItemsVest != "")then{
    	{
    		_playerUnit addItemToVest _x;
    	}forEach _playerItemsVest;
    };

	// Set Items Uniform
    if(str _playerItemsUniform != "[]" && str _playerItemsUniform != "")then{
    	{
    		_playerUnit addItemToUniform _x;
    	}forEach _playerItemsUniform;
    };

    // Player's Dog
    if(_playersDog != "")then{
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
                    //_dog playMove "Dog_Sit";
                    _dog playMove "Dog_Idle_Bark";
                    sleep (10 + floor(random 10));
                    _dog playMove "Dog_Idle_Walk";
                };
                _dog moveTo (getPos _caller);
                sleep 0.5;
            };
        }, _playersDog];

        //dogsChangedAnims = [];
        _playersDog addEventHandler["AnimStateChanged",{
            params["_dog","_anim"];
            //dogsChangedAnims pushBackUnique _anim;
            if(_anim == "dog_idle_bark")then{
                [_dog,"dogBarkAniSync",0,0.5] remoteExec ["bde_fnc_say3d",0,false];
            };
        }];

        _playersDog addEventHandler["Dammaged",{
            params["_dog"];
            [_dog,"dogWhine01",0,0] remoteExec ["bde_fnc_say3d",0,false];
        }];
    };

  	_hitPointNames	= _playerDamage select 0;
	_hitPointValues	= _playerDamage select 1;
	_hitPointsCount = count _hitPointNames;

	for "_i" from 0 to _hitPointsCount do {
		if(count(_hitPointNames select _i) > 0)then{
			_playerUnit setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
		};

      if(_i >= _hitPointsCount)then{
        _playerUnit setVariable["playerSetupReady",true,false];
      };
	};

}else{
    _playerUnit setDamage 0;
    _isRespawn = true;
    _forests = selectBestPlaces [worldCenter, worldHalfSize, "(1 + forest + trees) * (1 - sea) * (1 - houses) * (1 -  meadow) * (1 - deadBody)", 30, 20];
    _forestPlaces = _forests apply {_x select 0};
    _rdmSpawnPos = (_forestPlaces select 0) findEmptyPosition [0, 10, "C_man_1"];
    _playerUnit setPosATL _rdmSpawnPos;
    _playerUnit setVariable["playerSetupReady",true,false];
};

waitUntil{_playerUnit getVariable["playerSetupReady",false]};

// Player Init
[_playerUnit] execVM "scripts\player\playerWhileAlive.sqf";

// Init BDE GUI
3 cutRsc ['playerStatusGUI', 'PLAIN',3];

// Action Eventhandler
actionHandler = compile preprocessFile "scripts\player\actionHandler.sqf";
inGameUISetEventHandler ["Action", "[_this] call actionHandler"];

// Inventory Items Actions
inventoryItemAction = compile preprocessFile "scripts\inventory\inventoryItems.sqf";
fnc_coordinateItemActions = {
    _idcData    = _this select 0;
    _bagType    = _this select 1;
    _clickPos   = _this select 2;

    _idc = ctrlIDC (_idcData select 0);
    _selectedIndex = _idcData select 1;

    [_idc,_selectedIndex,_bagType,_clickPos,_idcData] spawn inventoryItemAction;
    systemChat str allDisplays;
    false
};

_initInventoryActionHandler = [_playerUnit] spawn {
    params["_playerUnit"];
    // replace with inventory open event
	while {alive _playerUnit} do {
        invClickPos = [0,0];
		waituntil {!(isnull (finddisplay 602))};
        // Get Click Position
        ((findDisplay 602) displayCtrl 633) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];"]; // Uniform
        ((findDisplay 602) displayCtrl 638) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];"]; // Vest
        ((findDisplay 602) displayCtrl 619) ctrlSetEventHandler ["MouseButtonDown", "invClickPos = [_this select 2,_this select 3];"]; // Backpack

        // Items Action
        ((findDisplay 602) displayCtrl 633) ctrlSetEventHandler ["LBDblClick", "[_this,'Uniform',invClickPos] call fnc_coordinateItemActions"]; // Uniform
        ((findDisplay 602) displayCtrl 638) ctrlSetEventHandler ["LBDblClick", "[_this,'Vest',invClickPos] call fnc_coordinateItemActions"]; // Vest
        ((findDisplay 602) displayCtrl 619) ctrlSetEventHandler ["LBDblClick", "[_this,'Backpack',invClickPos] call fnc_coordinateItemActions"]; // Backpack
		waituntil {isnull (finddisplay 602)};
        if(!(alive _playerUnit)) exitWith {};
	};
};

// Player Init Situation
if(_isRespawn)then{
	_playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
	playSound "feeepSound0";
    addCamShake [10, _respawnTime + 7, 50];
};

/*_playerUnit addEventHandler ["Respawn", {
    params["_unit","_corpse"];
    systemChat format["Respawn/_corpse uniform: %1",uniform  _corpse];
}];*/

_respawnTime fadeSound 3;
_respawnTime fadeMusic 3;

cutText ["Welcome to BadDeadEnd ...", "BLACK IN", _respawnTime];
