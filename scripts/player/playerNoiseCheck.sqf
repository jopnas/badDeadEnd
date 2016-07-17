private["_playerUnit","_noise","_noiseLevel","_surfaceName","_surfaceLevel","_stanceLevel","_speed"];
_playerUnit  = player;
_noise	= _this select 0;
_noiseLevel = 1;

if(vehicle _playerUnit == _playerUnit)then{
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

    _speedY	=  velocityModelSpace _playerUnit select 0;
    _speedX	=  velocityModelSpace _playerUnit select 1;
    if(_speedY >= _speedX)then{
        _speed = _speedY;
    }else{
        _speed = _speedX;
    };
    _speed = abs floor(3.6 * _speed);

    // Surfaces

    // run,walk,sprint,crawl
    _movementType = "";
    if(_speed > 1  && _stanceLevel == 1)then{
        _movementType = "crawl";
    };

    if(_stanceLevel == 2)then{
        if(_speed > 1 && _speed <= 13)then{
            _movementType = "walk";
        };
        if(_speed > 13)then{
            _movementType = "run";
        };
    };

    if( _stanceLevel == 3)then{
        if(_speed > 1 && _speed <= 15)then{
            _movementType = "run";
        };
        if(_speed > 15)then{
            _movementType = "sprint";
        };
    };

    _type = surfaceType (getPosATL _playerUnit);
    _typeA = toArray _type;
    _typeA set [0,"DEL"];
    _typeA = _typeA - ["DEL"];
    _type = toString _typeA;

    _soundType = getText (configFile >> "CfgSurfaces" >> _type >> "soundEnviron");
    _soundVal = getArray (configFile >> "CfgVehicles" >> "CAManBase" >> "SoundEnvironExt" >> _soundType);

    _surfaceLevel = 1;
    {
        if(_x select 0 == _movementType)then{
            _surfaceLevel = (_x select 1) select 3;
        };
    }forEach _soundVal;

    // Calculate Noise
    _noiseLevel = round(_surfaceLevel * _stanceLevel * _speed);
    _noiseLevel = (_noiseLevel/64)*10;
    _noiseLevel = floor(_noiseLevel) * 10;

}else{
    _speed	=  abs floor(speed (vehicle _playerUnit));
    _noiseLevel = floor(100 + (_speed / 2));
};

// Limitations cause GUI-Values
if(_noiseLevel < 0)then{
    _noiseLevel = 0;
};

if(_noiseLevel > 100)then{
    _noiseLevel = 100;
};

playerNoise = _noiseLevel;

[_playerUnit,getPos _playerUnit,_noiseLevel] remoteExec ["bde_fnc_receivePlayersNoise",2,false];
