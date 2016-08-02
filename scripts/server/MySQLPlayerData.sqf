fnc_deletePlayerStats = {
	private["_playerUnit","_PlayerUID"];
	_playerUnit	= _this select 0;
	_PlayerUID	= getPlayerUID _playerUnit;

	if(_PlayerUID == "_SP_PLAYER_")then{
		_PlayerUID = 12345;
	};

	"extDB2" callExtension format["0:SQL_PL_DEL:DELETE FROM player WHERE PlayerUID='%1'",_PlayerUID];
};

fnc_loadPlayerStats = {
	private["_playerUnit","_PlayerUID","_result"];
	_playerUnit	= _this select 0;
	_PlayerUID	= _this select 1;

    if(_PlayerUID == "_SP_PLAYER_")then{
        _PlayerUID = 12345;
    };

	_result = call compile ("extDB2" callExtension format["0:SQL_PL_LOAD:SELECT * FROM player WHERE PlayerUID='%1'",_PlayerUID]);
    waitUntil{count _result > 0 && _result select 0 > 0};
	_playerUnit setVariable["db",(_result select 1) select 0,true];
};

fnc_savePlayerStats = {
	private["_player","_PlayerUID","_PlayerPosition","_sick","_PlayerWeapons","_PlayerUniformItems","_PlayerVestItems","_PlayerBackpackItems","_QueryCheck","_QuerySave","_QueryAdd"];
	_player 				= _this select 0;
	_playerStats			= _this select 1;
	_PlayerUID  			= getPlayerUID _player;
	_PlayerPosition 		= getPosATL _player;
	_playerDirection 		= getDir _player;
    _PlayerStance			= stance _player;

	_PlayerWeapons 			= weapons _player;
	_currentWeapon 			= currentWeapon _player;

    _PlayerUniform			= uniform _player;
	_PlayerVest				= vest _player;
	_PlayerBackpack			= backpack _player;

	_PlayerBackpackItems	= backpackItems _player;
	_PlayerVestItems		= vestItems _player;
	_PlayerUniformItems		= uniformItems _player;

	_hunger      	= _playerStats select 0;
	_thirst      	= _playerStats select 1;
	_health      	= _playerStats select 2;
	_temperature 	= _playerStats select 3;
	_wet         	= _playerStats select 4;
	_sick        	= _playerStats select 5;
	_infected    	= _playerStats select 6;

	_primWeapItems	= primaryWeaponItems _player;
	_secWeapItems	= secondaryWeaponItems _player;
	_handgunItems	= handgunItems _player;

	_primWeapMag	= primaryWeaponMagazine _player;
	_secWeapMag		= secondaryWeaponMagazine _player;
	_handgunMag		= handgunMagazine _player;

	_primWeapAmmo 	= _player ammo(primaryWeapon _player);
	_secWeapAmmo 	= _player ammo(secondaryWeapon _player);
	_handgunAmmo 	= _player ammo(handgunWeapon _player);

	_headgear 		= headgear _player;
	_assignedItems	= assignedItems _player;
	_assignedItems	= _assignedItems - ["Binocular"] - ["Laserdesignator"] - ["Laserdesignator_02"] - ["Laserdesignator_03"] - ["Rangefinder"] - ["NVGoggles"];
	_goggles		= goggles _player;

    _playerDamages  = getAllHitPointsDamage _player;
	_playerDamage   = [_playerDamages select 0,_playerDamages select 2];

	if(_PlayerUID == "_SP_PLAYER_")then{
		_PlayerUID = 12345;
	};

    _QueryInsUpd = format["0:SQL_PL_SAVE:INSERT INTO player (PlayerUID,PlayerWeapons,PlayerPosition,PlayerItemsUniform,PlayerItemsVest,PlayerItemsBackpack,PlayerUniform,PlayerVest,PlayerBackpack,PlayerStance,hunger,thirst,health,temperature,wet,sick,infected,primWeapItems,secWeapItems,handgunItems,primWeapMag,secWeapMag,handgunMag,headgear,assignedItems,goggles,primWeapAmmo,secWeapAmmo,handgunAmmo,playerDirection,currentWeapon,playerDamage) VALUES('%1','%2','%3','%4','%5','%6','%7','""%8""','""%9""','""%10""','%11','%12','%13','%14','%15','%16','%17','%18','%19','%20','%21','%22','%23','""%24""','%25','""%26""','%27','%28','%29','%30','""%31""','%32') ON DUPLICATE KEY UPDATE playerWeapons='%2', PlayerPosition='%3',PlayerItemsUniform='%4',PlayerItemsVest='%5',PlayerItemsBackpack='%6',PlayerUniform='""%7""',PlayerVest='""%8""',PlayerBackpack='""%9""',PlayerStance='""%10""',hunger='%11',thirst='%12',health='%13',temperature='%14',wet='%15',sick='%16',infected='%17',primWeapItems='%18',secWeapItems='%19',handgunItems='%20',primWeapMag='%21',secWeapMag='%22',handgunMag='%23',headgear='""%24""',assignedItems='%25',goggles='""%26""',primWeapAmmo='%27',secWeapAmmo='%28',handgunAmmo='%29',playerDirection='%30',currentWeapon='""%31""', playerDamage='%32'",
		_PlayerUID,
		_PlayerWeapons,
		_PlayerPosition,
		_PlayerUniformItems,
		_PlayerVestItems,
		_PlayerBackpackItems,
		_PlayerUniform,
		_PlayerVest,
		_PlayerBackpack,
		_PlayerStance,
		_hunger,
		_thirst,
		_health,
		_temperature,
		_wet,
		_sick,
		_infected,
		_primWeapItems,
		_secWeapItems,
		_handgunItems,
		_primWeapMag,
		_secWeapMag,
		_handgunMag,
		_headgear,
		_assignedItems,
		_goggles,
		_primWeapAmmo,
		_secWeapAmmo,
		_handgunAmmo,
		_playerDirection,
		_currentWeapon,
        _playerDamage];
    _saveIs = "extDB2" callExtension _QueryInsUpd;
};

fnc_saveVehicle = {
    private["_vehicle","_id","_position","_rotation","_fuel","_damages","_damage","_items","_weapons","_magazines","_backpacks","_destroyed","_type","_QuerySave","_saveIs"];
	_vehicle 	= _this select 0;
    _id         = _vehicle getVariable["id",-1];
	_position	= getPos _vehicle;
	_rotation	= getDir _vehicle;
	_fuel		= fuel _vehicle;
	_damages	= getAllHitPointsDamage _vehicle;
    _damage		= [_damages select 0, _damages select 2];
	_items		= getItemCargo _vehicle;
	_weapons	= getWeaponCargo _vehicle;
	_magazines	= getMagazineCargo _vehicle;
	_backpacks	= getBackpackCargo _vehicle;

    _destroyed  = _vehicle getVariable ["destroyed","0"];
    _type       = _vehicle getVariable ["type",""];

    // Vehicle Save
    _QuerySave 	= format["0:SQL_VH_SAVE:UPDATE vehicles SET position='%2', rotation='%3', fuel='%4', damage='%5', items='%6', weapons='%7', magazines='%8', backpacks='%9', destroyed='%10', type='""%11""' WHERE id='%1'",_id,_position,_rotation,_fuel,_damage,_items,_weapons,_magazines,_backpacks,_destroyed,_type];
    _saveIs     = "extDB2" callExtension _QuerySave;
};

    // Tent Save
fnc_saveTent = {
    _tent       = _this select 0;
    _tentID     = _tent getVariable ["tentID","0"];
    _position   = getPosATL _tent;
    _rotation   = getDir _tent;
    _type       = typeOf _tent;
    _items		= getItemCargo _tent;
    _weapons	= getWeaponCargo _tent;
    _magazines	= getMagazineCargo _tent;
    _backpacks	= getBackpackCargo _tent;
    _QuerySaveTent = format["0:SQL_TE_SAVE:INSERT INTO tents (tentid,pos,rot,type,items,weapons,magazines,backpacks) VALUES('""%1""','%2','%3','""%4""','%5','%6','%7','%8') ON DUPLICATE KEY UPDATE pos='%2',rot='%3',type='""%4""',items='%5',weapons='%6',magazines='%7',backpacks='%8'",_tentID,_position,_rotation,_type,_items,_weapons,_magazines,_backpacks];
    _saveIs     = "extDB2" callExtension _QuerySaveTent;
};

// Dogs Load
fnc_loadDogs = {
    _result             = call compile ("extDB2" callExtension "0:SQL_DOG_LOAD:SELECT id,type,position,bestFriend,alive FROM dogs");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

bde_fnc_saveDog = {
    params ["_dog"/**/,"_alive"];

    _dogID      = _dog getVariable ["dogID",0];
    _position   = getPosATL _dog;
    _bestFriend = _dog getVariable ["bestFriend",""];
    if(alive _dog)then{
        _alive  = 1;
    }else{
        _alive  = 0;
    };
    _QuerySaveDog 	= format["0:SQL_DOG_SAVE:UPDATE dogs SET position='%2',bestFriend='""%3""',alive='%4' WHERE id='%1'",_dogID,_position,_bestFriend,_alive];
    _saveIs     = "extDB2" callExtension _QuerySaveDog;
};

// Tent Load
fnc_loadTents = {
    _result             = call compile ("extDB2" callExtension "0:SQL_TE_LOAD:SELECT id,tentid,pos,rot,type,items,weapons,magazines,backpacks FROM tents");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

fnc_deleteTent = {
    params["_tentID"];
	"extDB2" callExtension format["0:SQL_TE_DEL:DELETE FROM tents WHERE tentid='""%1""'",_tentID];
};
    // Barricade Save
fnc_saveBarricade = {
    _barricade      = _this select 0;
    _barricadeID    = _barricade getVariable ["barricadeID","0"];
    _health         = _barricade getVariable ["health","0"];
    _position       = getPosAtL _barricade;
    _rotation       = getDir _barricade;
    _type           = typeOf _barricade;
    _QuerySaveBarricade  = format["0:SQL_BC_SAVE:INSERT INTO barricades (barricadeid,pos,rot,type,health) VALUES('""%1""','%2','%3','""%4""','%5') ON DUPLICATE KEY UPDATE pos='%2',rot='%3',type='""%4""',health='%5'",_barricadeID,_position,_rotation,_type,_health];
    _saveIs         = "extDB2" callExtension _QuerySaveBarricade;
};

// Barricades Load
fnc_loadBarricades = {
    _result             = call compile ("extDB2" callExtension "0:SQL_BC_LOAD:SELECT id,barricadeid,pos,rot,type,health FROM barricades");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

fnc_deleteBarricade = {
    params["_barricadeID"];
	"extDB2" callExtension format["0:SQL_BC_DEL:DELETE FROM barricades WHERE barricadeid='""%1""'",_barricadeID];
};
