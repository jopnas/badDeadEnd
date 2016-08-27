params["_playerUnit","_db","_dbAll","_fnc_dogBehaviour"];

// Player Setup
_playerUnit enableFatigue false;
enableCamShake true;

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
playerHunger        = 100;
playerThirst        = 100;
playerHealth        = 100;
playerTemperature   = 100;
playerNoise         = 0;
playerWet           = 0;
playerSick          = 0;
playerInfected      = 0;

if(!(_dbAll isEqualTypeArray []))then{
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
    _loadout               = _db select 11;
    _playersDog			   = _db select 12;

	// Player Variables
	playerHunger           = _hunger;
	playerThirst           = _thirst;
	playerHealth           = _health;
	playerTemperature      = _temperature;
	playerWet              = _wet;
	playerSick             = _sick;
	playerInfected         = _infected;

    _playerUnit setUnitLoadout [_loadout, false];

    switch(_playerStance)do{
        case "CROUCH": {
            _playerUnit switchMove "AmovPcrhMstpSrasWpstDnon_AadjPcrhMstpSrasWpstDdown";
        };
        case "PRONE": {
            _playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
        };
    };

	// Set Position
    _playerUnit setDir _playerDirection;
    _playerUnit setPosATL _playerPosition;

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
    _forests = selectBestPlaces [worldCenter, worldHalfSize, "(1 + (forest * 2) + (trees * 2)) * (1 - sea) * (1 - (houses * 2)) * (1 -  (meadow * 2)) * (1 - (deadBody * 2))", 30, 20];
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

// Player Init Situation
if(_isRespawn)then{
	_playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
	playSound "feeepSound0";
    addCamShake [10, 10, 50];
};


5 fadeSound 3;
5 fadeMusic 3;

cutText ["Welcome to BadDeadEnd ...", "BLACK IN", 5];
