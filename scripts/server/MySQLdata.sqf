"extDB3" callExtension "9:ADD_DATABASE:sid110451_1";
"extDB3" callExtension "9:ADD_DATABASE_PROTOCOL:sid110451_1:SQL:SQL";

fnc_deletePlayerStats = {
	_PlayerUID	= _this select 0;

	if(_PlayerUID == "_SP_PLAYER_")then{
		_PlayerUID = 12345;
	};

	"extDB3" callExtension format["0:SQL:DELETE FROM player WHERE PlayerUID='%1'",_PlayerUID];
};

fnc_loadPlayerStats = {
	params["_playerUnit","_PlayerUID","_result","_resultData"];

    systemChat format["server: MySQLdata loadPlayerStats %1",_playerUnit];

    if(_PlayerUID == "_SP_PLAYER_")then{
        _PlayerUID = 12345;
    };

	_result = call compile ("extDB3" callExtension format["0:SQL:SELECT PlayerPosition,PlayerStance,hunger,thirst,health,temperature,wet,sick,infected,playerDirection,playerDamage,currentWeapon,loadout,dog,poisoning,radiation FROM player WHERE PlayerUID='%1'",_PlayerUID]);

    waitUntil { (count _result > 0 && _result select 0 > 0) };
    _playerUnit setVariable ["playerDBstats", [(_result select 1) select 0,_result select 1], true];
};

fnc_savePlayerStats = {
	private["_player","_PlayerUID","_PlayerPosition","_QueryCheck","_QuerySave","_QueryAdd"];
	_player 				= _this select 0;
	_playerStats			= _this select 1;
	_PlayerUID  			= getPlayerUID _player;
	_PlayerPosition 		= getPosATL _player;
	_playerDirection 		= getDir _player;
    _PlayerStance           = animationState _player;
    _PlayerWeapon           = currentWeapon _player;

	_hunger                 = _playerStats select 0;
    _thirst                 = _playerStats select 1;
    _health                 = _playerStats select 2;
    _temperature            = _playerStats select 3;
    _wet                    = _playerStats select 4;
    _sick                   = _playerStats select 5;
    _infected               = _playerStats select 6;
    _poisoning              = _playerStats select 7;
    _radiation              = _playerStats select 8;

    _playerDamages          = getAllHitPointsDamage _player;
    _playerDamage           = [_playerDamages select 0,_playerDamages select 2];

    _playerLoadout          = getUnitLoadout _player;

	if(_PlayerUID == "_SP_PLAYER_")then{
		_PlayerUID = 12345;
	};

    _QueryInsUpd = format["0:SQL:INSERT INTO player (PlayerUID,PlayerPosition,PlayerStance,hunger,thirst,health,temperature,wet,sick,infected,playerDirection,playerDamage,currentWeapon,loadout,poisoning,radiation) VALUES('%1','%2','""%3""','%4','%5','%6','%7','%8','%9','%10','%11','%12','""%13""','%14','%15','%16') ON DUPLICATE KEY UPDATE PlayerPosition='%2',PlayerStance='""%3""',hunger='%4',thirst='%5',health='%6',temperature='%7',wet='%8',sick='%9',infected='%10',playerDirection='%11', playerDamage='%12', currentWeapon='""%13""', loadout='%14', poisoning='%15', radiation='%16'",
		_PlayerUID,
		_PlayerPosition,
		_PlayerStance,
		_hunger,
		_thirst,
		_health,
		_temperature,
		_wet,
		_sick,
		_infected,
		_playerDirection,
        _playerDamage,
        _PlayerWeapon,
        _playerLoadout,
        _poisoning,
        _radiation];
    _saveIs = "extDB3" callExtension _QueryInsUpd;
};

fnc_saveVehicle = {
    private["_vehicle","_id","_position","_rotation","_fuel","_damages","_damage","_items","_weapons","_magazines","_backpacks","_destroyed","_QuerySave","_saveIs"];
	_vehicle 	= _this select 0;
    _id         = _vehicle getVariable["id",-1];
	_position	= getPos _vehicle;
	_rotation	= [vectorDir _vehicle,vectorUp _vehicle];
	_fuel		= fuel _vehicle;
	_damages	= getAllHitPointsDamage _vehicle;
    _damage		= [_damages select 0, _damages select 2];
	_items		= getItemCargo _vehicle;
	_weapons	= getWeaponCargo _vehicle;
	_magazines	= getMagazineCargo _vehicle;
	_backpacks	= getBackpackCargo _vehicle;
    if(alive _vehicle)then{
        _destroyed  = 0;
    }else{
        _destroyed  = 1;
    };

    // Vehicle Save
    _QuerySave 	= format["0:SQL:UPDATE vehicles SET position='%2', rotation='%3', fuel='%4', damage='%5', items='%6', weapons='%7', magazines='%8', backpacks='%9', destroyed='%10' WHERE id='%1'",_id,_position,_rotation,_fuel,_damage,_items,_weapons,_magazines,_backpacks,_destroyed];
    //systemchat  _QuerySave;
    _saveIs     = "extDB3" callExtension _QuerySave;
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
    _QuerySaveTent = format["0:SQL:INSERT INTO tents (tentid,pos,rot,type,items,weapons,magazines,backpacks) VALUES('""%1""','%2','%3','""%4""','%5','%6','%7','%8') ON DUPLICATE KEY UPDATE pos='%2',rot='%3',type='""%4""',items='%5',weapons='%6',magazines='%7',backpacks='%8'",_tentID,_position,_rotation,_type,_items,_weapons,_magazines,_backpacks];
    _saveIs     = "extDB3" callExtension _QuerySaveTent;
};

// Dogs Load
fnc_loadDogs = {
    _result             = call compile ("extDB3" callExtension "0:SQL:SELECT id,type,position,bestFriend,alive FROM dogs");
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
    _QuerySaveDog 	= format["0:SQL:UPDATE dogs SET position='%2',bestFriend='""%3""',alive='%4' WHERE id='%1'",_dogID,_position,_bestFriend,_alive];
    _saveIs     = "extDB3" callExtension _QuerySaveDog;
};

// Tent Load
fnc_loadTents = {
    _result             = call compile ("extDB3" callExtension "0:SQL:SELECT id,tentid,pos,rot,type,items,weapons,magazines,backpacks FROM tents");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

fnc_deleteTent = {
    params["_tentID"];
	"extDB3" callExtension format["0:SQL:DELETE FROM tents WHERE tentid='""%1""'",_tentID];
};
    // Barricade Save
fnc_saveBarricade = {
    _barricade      = _this select 0;
    _barricadeID    = _barricade getVariable ["barricadeID","0"];
    _health         = _barricade getVariable ["health",0];
    _position       = getPosAtL _barricade;
    _rotation       = getDir _barricade;
    _type           = typeOf _barricade;
    _level          = _barricade getVariable["barricadeLevel",1];
    _QuerySaveBarricade  = format["0:SQL:INSERT INTO barricades (barricadeid,pos,rot,type,health,level) VALUES('""%1""','%2','%3','""%4""','%5','%6') ON DUPLICATE KEY UPDATE pos='%2',rot='%3',type='""%4""',health='%5',level='%6'",_barricadeID,_position,_rotation,_type,_health,_level];
    _saveIs         = "extDB3" callExtension _QuerySaveBarricade;
};

// Barricades Load
fnc_loadBarricades = {
    _result             = call compile ("extDB3" callExtension "0:SQL:SELECT id,barricadeid,pos,rot,type,health,level FROM barricades");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

fnc_deleteBarricade = {
    params["_barricadeID"];
	"extDB3" callExtension format["0:SQL:DELETE FROM barricades WHERE barricadeid='""%1""'",_barricadeID];
};

// Doors Load
fnc_loadDoors = {
    _result             = call compile ("extDB3" callExtension "0:SQL:SELECT id,doorid,houseid,code,owner,locked FROM doors");
    _resultQueryStatus  = _result select 0;
    _resultInDB         = _result select 1;
    waitUntil { _resultQueryStatus > 0 };
    _resultInDB
};

// Doors Save
bde_fnc_saveDoor = {
    params["_id","_doorid","_houseid","_code","_owner","_locked"];

    _QuerySaveDoor  = format["0:SQL:INSERT INTO doors (id,doorid,houseid,code,owner,locked) VALUES('""%1""','%2','%3','%4','%5','%6') ON DUPLICATE KEY UPDATE doorid='%2',houseid='%3',code='%4',owner='%5',locked='%6'",_id,_doorid,_houseid,_code,_owner,_locked];
    _saveIs         = "extDB3" callExtension _QuerySaveDoor;
};

fnc_deleteDoor = {
    params["_id"];
	"extDB3" callExtension format["0:SQL:DELETE FROM doors WHERE id='""%1""'",_id];
};
