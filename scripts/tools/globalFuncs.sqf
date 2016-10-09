bde_fnc_say3d = { // [_sayobject,_audioclip,_maxdistance,_delay] remoteExec ["bde_fnc_say3d",0,false];
    params["_sayobject","_audioclip","_maxdistance","_delay"];
    if(!isDedicated)then{
        sleep _delay;
        _sayobject say3D [_audioclip, _maxdistance, 1];
    };
};

bde_fnc_playSound3D = { // [player,"eat01","configVol" or 0.5,"randomPitch" or "configPitch",max. distance] spawn bde_fnc_playSound3D;
    private["_usePitch","_useVol"];

    _source         = _this select 0;
    _audioClip      = _this select 1;
    _volume         = _this select 2;
    _pitch          = _this select 3;
    _distance       = _this select 4;
    _audioClipCfg   = getArray (missionConfigFile >> "CfgSounds" >> _audioClip >> "sound");

    switch(_pitch)do{
        case "randomPitch":{
            _usePitch = random 2;
        };
        case "configPitch":{
            _usePitch = _audioClipCfg select 2;
        };
        default {
            _usePitch = 1;
        };
    };

    if(_volume == "configVol")then{
        _useVol = _audioClipCfg select 1;
    }else{
        _useVol = _volume;
    };

    playSound3D [_audioClipCfg select 0, _source, false, getPosASL _source, _useVol, _usePitch, _distance];

    /*
    [filename, soundSource, isInside, soundPosition, volume, soundPitch, distance]: Array
    filename: String - see Arma_3:_SoundFiles for available filenames
    soundSource: Object - the object emitting the sound. If "sound position" is specified this param is ignored
    isInside: Boolean (optional) Default: false
    soundPosition: PositionASL (optional) - position for sound emitter, will override "sound source" position. Default: [0,0,0]
    volume: Number (optional) Default: 1
    soundPitch: Number (optional) - 1: Normal, 0.5: Darth Vader, 2: Chipmunks, etc. Default: 1
    distance: Number (optional) - How far is sound audible (0 = no max distance) Default: 0.
    */
};

// Burn Dead Z
bde_fnc_addBurnAction = {
    _targetObject = _this select 0;
    burnAction = _targetObject addAction [ "Burn dead body", {
        _targetObject = _this select 0;
        _caller = _this select 1;
        if(("bde_zippo" in Magazines _caller || (rain < 0.2 && "bde_matches" in Magazines _caller))/* && "bde_fuelcan" in Magazines _caller*/)then{
            [_targetObject] remoteExec ["bde_fnc_removeBurnAction",0,false];
            [_targetObject] remoteExec ["fnc_burnDeadZ",0,false];
        }else{
            if(!("bde_zippo" in Magazines _caller) || !("bde_matches" in Magazines _caller))then{
                [] remoteExec ["cutText ['need matches or lighter', 'PLAIN DOWN'];", _caller, false];
            };
            if(rain > 0.2 && !("bde_zippo" in Magazines _caller))then{
                [] remoteExec ["cutText ['need zippo while raining', 'PLAIN DOWN'];", _caller, false];
            };
        };
    },[],6,true,true,"","_target distance _this < 4"];
};

bde_fnc_removeBurnAction = {
    _targetObject = _this select 0;
    _targetObject removeAction burnAction;
};

bde_fnc_relDirNinty = {
    _building       = nearestBuilding player;
    _buildingDir    = getDir _building;
    _playerDir      = getDir player;
    _realRelDir     = floor (_buildingDir - _playerDir);

    if(_realRelDir < 0)then{
        _realRelDir = _realRelDir + 360;
    };
    _realRelDir
};

bde_fnc_underCover = {
    params["_object"/**/,"_startPosition","_ignoreObject1"];
    if(_object isEqualType [0,0,0])then{
        _startPosition  = _object;
        _ignoreObject1  = objNull;
    }else{
        _startPosition  = getPosASL _object;
        _ignoreObject1  = _object;
    };

    _endPosition    = [_startPosition select 0, _startPosition select 1, (_startPosition select 2 ) + 15];
    _intersections  = lineIntersectsSurfaces [_startPosition, _endPosition, _ignoreObject1, objNull, false, 1, "GEOM", "VIEW"];
    _isBelowRoof    = !(_intersections isEqualTo []);
    _isBelowRoof
};

bde_fnc_packTent = {
    _targetObject   = _this select 0;
    _caller         = _this select 1;
    _tentPackClass  = _this select 2;
    _tentPos        = getPosATL _targetObject;
    _tentID         = _targetObject getVariable["tentID","0"];

    systemChat _tentPackClass;

    [_caller,"toolSound1",10,1] remoteExec ["bde_fnc_say3d",0,false];
    [_tentID] remoteExec ["fnc_deleteTent",2,false];

    sleep 5;
    deleteVehicle _targetObject;
    _tentWph = createVehicle ["groundWeaponHolder",_tentPos,[],0,"can_collide"];
    _tentWph setVehiclePosition [[_tentPos select 0,_tentPos select 1,(_tentPos select 2) + 0.5], [], 0, "can_collide"];
    _tentWph addMagazineCargoGlobal [_tentPackClass,1];
};

bde_fnc_vehicleRepair = {
    params["_partName","_damage","_vehicle","_part","_action","_caller"];

    _allineed = false;
    if(_partName find "Wheel" > -1 && "bde_wheel" in Magazines _caller)then{
        _allineed = true;
        _caller removeMagazine "bde_wheel";
    };

    if(_partName find "Fuel" > -1 && "bde_ducttape" in Magazines _caller)then{
        _allineed = true;
        _caller removeMagazine "bde_ducttape";
    };

    // Fallback if condition to repair vehiclepart is not set
    if(_partName find "Wheel" < 0 && _partName find "Fuel" < 0)then{
        _allineed = true;
    };

    if(_allineed)then{
        _caller  say3D (selectRandom ["toolSound0","toolSound1"]);
        sleep 11;
        _vehicle setHit [_part, 0];
        _vehicle removeAction _action;
        _repairActionIDs = _vehicle getVariable ["repairActionIDs", []];
        _repairActionIDs = _repairActionIDs - [_action];
        _vehicle setVariable ["repairActionIDs", _repairActionIDs,false];
        sleep 1;
        [_vehicle] call fnc_saveVehicle;
        systemChat format["repaired %1s %2",typeOf _vehicle,_part];
    };
};

bde_fnc_removeRepairActions = {
    params["_vehicle"];
    _repairActionIDs = _vehicle getVariable ["repairActionIDs", []];
    if(count _repairActionIDs > 0)then{
        {
            _vehicle removeAction _x;
        }forEach _repairActionIDs;
        _vehicle setVariable ["repairActionIDs", [],false];
    };
};