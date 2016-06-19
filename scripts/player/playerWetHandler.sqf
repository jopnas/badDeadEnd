_isUnderCover 		= _this select 0;
_isInCar 			= _this select 1;
_nearestFireplaces 	= _this select 2;

_playerWetness  = playerWet;

systemChat format["%1, %2, %3",rain,_isUnderCover,_isInCar];

if(rain > 0 && !_isUnderCover && !_isInCar)then{
	_playerWetness = _playerWetness + 0.2;
};

if(_isUnderCover || _isInCar)then{
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
