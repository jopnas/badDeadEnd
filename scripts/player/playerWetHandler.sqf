_isUnderCover 		= _this select 0;
_isInside 		    = _this select 1;
_isInCar 			= _this select 2;
_nearestFireplaces 	= _this select 3;

_playerWetness  = playerWet;

if(rain > 0 && !_isUnderCover && !_isInCar)then{
	_playerWetness = _playerWetness + 0.2;
};

if(_isUnderCover || _isInCar)then{
	_playerWetness = _playerWetness - 0.01;
};

if(count _nearestFireplaces > 0 && _isInCar)then{
	_playerWetness = _playerWetness - (count(_nearestFireplaces) / 2);
};

if(_playerWetness < 0)then{
	_playerWetness = 0;
};

if(_playerWetness > 100)then{
	_playerWetness = 100;
};

playerWet = _playerWetness;
