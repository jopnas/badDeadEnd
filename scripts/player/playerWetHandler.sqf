private["_playerWetness"];

_isInside 			= _this select 0;
_isInCar 			= _this select 1;
_nearestFireplaces 	= _this select 2;

_playerWetness  = playerWet;

if(rain > 0 && !_isInside && !_isInCar)then{
	_playerWetness = _playerWetness + (rain/100);
};

if(_isInside || _isInCar)then{
	_playerWetness = _playerWetness - 0.01;
};

if(inflamed (_nearestFireplaces select 0) && !_isInCar)then{
	_playerWetness = _playerWetness - 0.1;
};

if(_playerWetness < 0)then{
	_playerWetness = 0;
};

if(_playerWetness > 100)then{
	_playerWetness = 100;
};

playerWet = _playerWetness;