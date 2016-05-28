private["_playerUnitTemperature","_playerWetness","_nearestFireplaces"];

_playerUnit 		= player;
_isInside 			= _this select 0;
_nearestFireplaces 	= _this select 1;

_playerUnitTemperature = playerTemperature;

if(playerWet > 10)then{
	_playerUnitTemperature = _playerUnitTemperature - 0.3;
};

if(_isInside)then{
	_playerUnitTemperature = _playerUnitTemperature + 0.2;
};

if(count (_nearestFireplaces) > 0)then{
	_playerUnitTemperature = _playerUnitTemperature + (count (_nearestFireplaces) * 1);
};

if(_playerUnitTemperature < 0)then{
	_playerUnitTemperature = 0;
};

if(_playerUnitTemperature > 100)then{
	_playerUnitTemperature = 100;
};

playerTemperature = _playerUnitTemperature;
