private["_playerUnit","_respawnTime","_db"];
_playerUnit     = _this select 0;
_respawnTime    = _this select 1;

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

// Player Setup
_playerUnit enableFatigue false;

// Player Default Variables
playerHunger = 100;
playerThirst = 100;
playerHealth = 100;
playerTemperature = 100;
playerNoise = 0;
playerWet = 0;
playerSick = 0;
playerInfected = 0;

sleep _respawnTime;
_db = (_playerUnit getVariable["db",[]]);

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

	// Player Variables
	playerHunger = _hunger;
	playerThirst = _thirst;
	playerHealth = _health;
	playerTemperature = _temperature;
	playerWet = _wet;
	playerSick = _sick;
	playerInfected = _infected;

	// Set Position
	_playerUnit setPosATL _playerPosition;
	_playerUnit setDir _playerDirection;

	// Set Uniform
	if(count _playerUniform > 2)then{
		_playerUnit forceAddUniform _playerUniform;
	};

	// Set Vest
	if(count _playerVest > 2)then{
		_playerUnit addVest _playerVest;
	};

	// Set Backpack
	if(count _playerBackpack > 2)then{
		_playerUnit addBackpack _playerBackpack;
	};

    // Magazines loaded in weapons
	{
		_playerUnit addMagazine[_x,1];
	}forEach _primWeapMag;

	{
		_playerUnit addMagazine[_x,1];
	}forEach _secWeapMag;

	{
		_playerUnit addMagazine[_x,1];
	}forEach _handgunMag;

	// Set Weapons
	{
		_playerUnit addWeapon _x;
	}forEach _playerWeapons;

	_playerUnit setAmmo [primaryWeapon _playerUnit, _primWeapAmmo];
	_playerUnit setAmmo [secondaryWeapon _playerUnit, _secWeapAmmo];
	_playerUnit setAmmo [handgunWeapon _playerUnit, _handgunAmmo];

	// Weapon Attachments
	{
		_playerUnit addPrimaryWeaponItem _x;
	}forEach _primWeapItems;

	{
		_playerUnit addSecondaryWeaponItem _x;
	}forEach _secWeapItems;

	{
		_playerUnit addHandgunItem _x;
	}forEach _handgunItems;

	if(count _headgear > 2)then{
		_playerUnit addHeadgear _headgear;
	};

	{
		_playerUnit addItem _x;
		_playerUnit assignItem _x;
	}forEach _assignedItems;

	if(count _goggles > 2)then{
		_playerUnit addGoggles _goggles;
	};

    // Set Items Backpack
	{
		_playerUnit addItemToBackpack _x;
	}forEach _playerItemsBackpack;

	// Set Items Vest
	{
		_playerUnit addItemToVest _x;
	}forEach _playerItemsVest;

	// Set Items Uniform
	{
		_playerUnit addItemToUniform _x;
	}forEach _playerItemsUniform;

  	_hitPointNames	= _playerDamage select 0;
	_hitPointValues	= _playerDamage select 1;
	_hitPointsCount = count _hitPointNames;

	for "_i" from 0 to _hitPointsCount do {
		if(count(_hitPointNames select _i) > 0)then{
			_playerUnit setHit [_hitPointNames select _i, _hitPointValues select _i];
		};

      if(_i >= _hitPointsCount)then{
        _playerUnit setVariable["playerSetupReady",true];
      };
	};

    _playerUnit selectWeapon _currentWeapon;

    switch(_playerStance)do{
		case "CROUCH": {
			_playerUnit switchMove "AmovPcrhMstpSrasWpstDnon_AadjPcrhMstpSrasWpstDdown";
		};
		case "PRONE": {
			sleep 0.1;
			_playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
		};
	};

}else{
    _isRespawn = true;
	[_playerUnit] execVM "scripts\player\playerSpawnPosition.sqf";
};

waitUntil{_playerUnit getVariable["playerSetupReady",false]};

// Player UI Init
[_playerUnit] execVM "scripts\player\playerWhileAlive.sqf";

// Init Player UI
3 cutRsc ['playerStatusGUI', 'PLAIN',3];

// Inventory Items Actions
inventoryItemAction = compile preprocessFile "scripts\inventory\inventoryItems.sqf";

actionsEventHandler = [] spawn {
	fnc_coordinateItemActions = {
		_idc = ctrlIDC (_this select 0);
		_selectedIndex = _this select 1;
		[_idc,_selectedIndex] spawn inventoryItemAction;
		false
    };
	while {true} do {
		waituntil {!(isnull (finddisplay 602))};
        // Items Action
        ((findDisplay 602) displayCtrl 619) ctrlSetEventHandler ["LBDblClick", "_this call fnc_coordinateItemActions"]; // Backback
        ((findDisplay 602) displayCtrl 638) ctrlSetEventHandler ["LBDblClick", "_this call fnc_coordinateItemActions"]; // Vest
        ((findDisplay 602) displayCtrl 633) ctrlSetEventHandler ["LBDblClick", "_this call fnc_coordinateItemActions"]; // Uniform
		waituntil {isnull (finddisplay 602)};
	};
};

// Action Eventhandler
actionHandler = compile preprocessFile "scripts\player\actionHandler.sqf";
inGameUISetEventHandler ["Action", "[_this] call actionHandler"];

// Player Init Situation
if(_isRespawn)then{
    enableCamShake true;
	_playerUnit switchMove "AmovPpneMstpSnonWnonDnon";
	playSound "feeepSound0";
	addCamShake [(_respawnTime + 7), 10, 50];
};

// Init Barricading
[] execVM "scripts\barricading\initBarricading.sqf";

_respawnTime fadeSound 3;
_respawnTime fadeMusic 3;
titleCut ["", "BLACK IN", _respawnTime];
