// [_isUnderCover,_isInside,_isInCar,_inflamedFireplaces]
params["_isUnderCover","_isInside","_isInCar","_nearestFireplaces", /* private ->*/ "_getWetVal"];
/*_isUnderCover 		= _this select 0;
_isInside 		    = _this select 1;
_isInCar 			= _this select 2;
_nearestFireplaces 	= _this select 3;*/

_player             = player;

_PlayerUniform		= uniform _player;
_PlayerVest			= vest _player;
_PlayerBackpack		= backpack _player;
_headgear 		    = headgear _player;

_playerWetness  = playerWet;

if(rain > 0 && !_isUnderCover && !_isInCar)then{
    _getWetVal = 0.1;
    if(_PlayerUniform != "U_BasicBody")then{
	   _getWetVal = _getWetVal - 0.02;
    };
    if(_PlayerVest != "")then{
	   _getWetVal = _getWetVal - 0.02;
    };
    if(_PlayerBackpack != "")then{
	   _getWetVal = _getWetVal - 0.02;
    };
    if(_headgear != "")then{
	   _getWetVal = _getWetVal - 0.02;
    };

    _playerWetness = _playerWetness + _getWetVal;
};

if((_isUnderCover && _isInside) || _isInCar)then{
	_playerWetness = _playerWetness - 0.05;
};

if(count _nearestFireplaces > 0 && !(_isInCar))then{
	_playerWetness = _playerWetness - (count(_nearestFireplaces) / 2);
};

if(rain == 0)then{
    _playerWetness = _playerWetness - 0.02;
};

if(_playerWetness < 0)then{
	_playerWetness = 0;
};

if(_playerWetness > 100)then{
	_playerWetness = 100;
};

playerWet = _playerWetness;
