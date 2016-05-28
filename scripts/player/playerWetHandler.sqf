private["_playerWetness"];

_isInside 			= _this select 0;
_nearestFireplaces 	= _this select 1;

_playerWetness  = playerWet;

if(rain > 0 && !_isInside)then{
	_playerWetness = _playerWetness + 0.1;
};

if(_isInside)then{
	_playerWetness = _playerWetness - 0.1;
};

if(inflamed (_nearestFireplaces select 0))then{
	_playerWetness = _playerWetness - 0.5;
};

if(_playerWetness < 0)then{
	_playerWetness = 0;
};

if(_playerWetness > 100)then{
	_playerWetness = 100;
};

playerWet = _playerWetness;