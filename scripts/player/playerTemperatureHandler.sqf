_isUnderCover 		= _this select 0;
_isInside 		    = _this select 1;
_isInCar 			= _this select 2;
_nearestFireplaces 	= _this select 3;

_playerUnitTemperature = playerTemperature;

if(playerWet > 0)then{
	_playerUnitTemperature = _playerUnitTemperature - (playerWet/100);
};

if(_isInside || _isInCar)then{
	_playerUnitTemperature = _playerUnitTemperature + 0.1;
};

if(count _nearestFireplaces > 0 && !_isInCar)then{
	_playerUnitTemperature = _playerUnitTemperature + (count(_nearestFireplaces) / 2);
};

if(_playerUnitTemperature < 0)then{
	_playerUnitTemperature = 0;
};

if(_playerUnitTemperature > 100)then{
	_playerUnitTemperature = 100;
};

playerTemperature = _playerUnitTemperature;


if(_playerUnitTemperature < 20)then{
    addCamShake [2,1,80];
};
