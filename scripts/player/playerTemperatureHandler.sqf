_isUnderCover 		= _this select 0;
_isInside 		    = _this select 1;
_isInCar 			= _this select 2;
_nearestFireplaces 	= _this select 3;

_player             = player;

_playerUniform		= uniform _player;
_playerVest			= vest _player;
_playerBackpack		= backpack _player;
_headgear 		    = headgear _player;

_clothBonus       = 0;

_playerUnitTemperature = playerTemperature;

if(playerWet > 0)then{
	_playerUnitTemperature = _playerUnitTemperature - (playerWet/200);
};

if(playerWet == 0)then{
    _playerUnitTemperature = _playerUnitTemperature + 0.5;
};

if(_isInside || _isInCar)then{
	_playerUnitTemperature = _playerUnitTemperature + 0.1;
};

if(count _nearestFireplaces > 0 && !_isInCar)then{
	_playerUnitTemperature = _playerUnitTemperature + (count(_nearestFireplaces) / 2);
};


if(_playerUniform != "U_BasicBody")then{
   _clothBonus = _clothBonus  + 0.06;
};
if(_playerVest != "")then{
   _clothBonus = _clothBonus  + 0.04;
};
if(_playerBackpack != "")then{
   _clothBonus = _clothBonus  + 0.05;
};
if(_headgear != "")then{
   _clothBonus = _clothBonus  + 0.02;
};

_playerUnitTemperature = _playerUnitTemperature + _clothBonus;

if(_playerUnitTemperature < 0)then{
	_playerUnitTemperature = 0;
};

if(_playerUnitTemperature > 100)then{
	_playerUnitTemperature = 100;
};

playerTemperature = _playerUnitTemperature;

if(_playerUnitTemperature < 20)then{
    addCamShake [2,1,5];
};
