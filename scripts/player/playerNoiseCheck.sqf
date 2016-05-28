private["_playerUnit","_noiseLevel","_surfaceName","_surfaceLevel","_silentSurfaces","_mediumSurfaces","_noisySurfaces","_stanceLevel","_playerVelocity","_speedLevel"];
_playerUnit  = player;
_noise	= _this select 0;
_noiseLevel = 1;

// Surfaces

/*
private ["_type","_typeA","_test","_soundType","_soundVal","_soundval"];
_type = surfaceType getPosATL _this;
_typeA = toArray _type;
_typeA set [0,"DEL"];
_typeA = _typeA - ["DEL"];
_type = toString _typeA;
//_test = 0;
_soundType = getText (configFile >> "CfgSurfaces" >> _type >> "soundEnviron");
_soundVal = getArray (configFile >> "CfgVehicles" >> "CAManBase" >> "SoundEnvironExt" >> _soundType);
if ((isNil "_soundval") or {(count _soundval == 0)}) then {
    _soundval = 25;
}
else {
    _soundVal = _soundVal select 0;
    if ((isNil "_soundval") or {(count _soundval <= 3)}) then {
        _soundval = 25;
    }
    else {
        _soundVal = parseNumber format["%1",_soundVal select 3];
        if (_soundVal == 0) then {
            _soundVal = 25;
        };
    };
};
//diag_log format["Type: %1, SoundType: %2, SoundVal: %3",_type,_soundType,_soundVal];
[_soundType,_soundVal]
*/

_silentSurfaces = ["#GdtGrassGreen","#GdtBeach","#GdtMarsh","#GdtSeabed"];
_mediumSurfaces = ["#GdtGrassDry","#GdtDirt","#GdtThorn","#GdtSoil"];
_noisySurfaces  = ["#GdtConcrete","#GdtDead","#GdtStony"];
_surfaceName    = surfaceType position _playerUnit;

_surfaceLevel   = 1; // Default
if(_surfaceName in _silentSurfaces)then{
    _surfaceLevel = 1;
};
if(_surfaceName in _mediumSurfaces)then{
    _surfaceLevel = 2;
};
if(_surfaceName in _noisySurfaces || isOnRoad player)then{
    _surfaceLevel = 3;
};

// Player Position
switch(stance _playerUnit)do{
    case "PRONE": {
        _stanceLevel = 1;
    };
    case "CROUCH": {
        _stanceLevel = 2;
    };
    case "STAND": {
        _stanceLevel = 3;
    };
    default {
        _stanceLevel = 1;
    };
};

// Player Speed
_playerVelocity = velocityModelSpace _playerUnit;

_speedLevel1	=  abs (floor(_playerVelocity select 0));
_speedLevel2	=  abs (floor(_playerVelocity select 1));

if(_speedLevel1 > _speedLevel2)then{
	_speedLevel = round _speedLevel1;
}else{
	_speedLevel = round _speedLevel2;
};

// Calculate Noise
_noiseLevel = round(_surfaceLevel * _stanceLevel * _speedLevel);

_noiseLevel = (_noiseLevel/64)*10;

_noiseLevel = floor(_noiseLevel) * 10;

if(_noiseLevel < 0)then{
	_noiseLevel = 0;
};

if(_noiseLevel > 100)then{
	_noiseLevel = 100;
};

playerNoise = _noiseLevel;
