params["_isUnderCover","_isInside","_isInCar","_nearestFireplaces","_isInShadow","_sunRadiation"/**/,"_dryingVal","_getWetVal"];

_player             = player;

_playerUniform		= uniform _player;
_playerVest			= vest _player;
_playerBackpack		= backpack _player;
_headgear 		    = headgear _player;

_playerWetness  = playerWet;

if(rain > 0 && !_isUnderCover && !_isInCar)then{
    _getWetVal = 0.2;
    if(_playerUniform != "U_BasicBody")then{
	   _getWetVal = _getWetVal - 0.04;
    };
    if(_playerVest != "")then{
	   _getWetVal = _getWetVal - 0.04;
    };
    if(_playerBackpack != "")then{
	   _getWetVal = _getWetVal - 0.04;
    };
    if(_headgear != "")then{
	   _getWetVal = _getWetVal - 0.04;
    };

    _playerWetness = _playerWetness + _getWetVal;
};

if(_isUnderCover)then{
	_playerWetness = _playerWetness - 0.02;
};

if((_isUnderCover && _isInside) || _isInCar)then{
	_playerWetness = _playerWetness - 0.05;
};

if(count _nearestFireplaces > 0 && !(_isInCar))then{
	_playerWetness = _playerWetness - (count(_nearestFireplaces) / 2);
};

if(rain == 0)then{
    if(_isInShadow)then{
        _dryingVal = _sunRadiation/1000;
    }else{
        _dryingVal = _sunRadiation/100;
    };

    _playerWetness = _playerWetness - _dryingVal;
};

if(_playerWetness < 0)then{
	_playerWetness = 0;
};

if(_playerWetness > 100)then{
	_playerWetness = 100;
};

playerWet = _playerWetness;
