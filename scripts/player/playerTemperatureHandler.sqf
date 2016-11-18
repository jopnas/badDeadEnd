params["_isUnderCover","_isInside","_isInCar","_nearestFireplaces","_isInShadow","_sunRadiation"/**/,"_cooldownVal","_speed","_speedX","_speedY"];

_player             = player;

_playerUniform		= uniform _player;
_playerVest			= vest _player;
_playerBackpack		= backpack _player;
_headgear 		    = headgear _player;

_clothBonus       = 0;

_playerUnitTemperature = _player getVariable ["playerTemperature",100];
_playerWet = _player getVariable ["playerWet",100];

if(_playerWet >= 50)then{
    if(_isInShadow)then{
        _cooldownVal = (_playerWet/100);
    }else{
        _cooldownVal = (_playerWet/200);
    };
	_playerUnitTemperature = _playerUnitTemperature - _cooldownVal;
};

if(_playerWet < 50 && !_isInShadow)then{
    _playerUnitTemperature = _playerUnitTemperature + 0.5 + (_sunRadiation/10);
};

if((_isInside || _isInCar) && _playerWet < 20)then{
	_playerUnitTemperature = _playerUnitTemperature + 0.1;
};

if(count _nearestFireplaces > 0 && !_isInCar && _playerWet < 20)then{
	_playerUnitTemperature = _playerUnitTemperature + (count(_nearestFireplaces) / 2);
};

_speed  = 0;
_speedY	=  (velocityModelSpace player) select 0;
_speedX	=  (velocityModelSpace player) select 1;
if(_speedY >= _speedX)then{
    _speed = _speedY;
}else{
    _speed = _speedX;
};
_speed = abs floor(3.6 * _speed);
if(_speed > 0 && !_isInCar)then{
    _playerUnitTemperature = _playerUnitTemperature + (_speed/200);
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

_player setVariable ["playerTemperature",_playerUnitTemperature,true];

if(_playerUnitTemperature < 20)then{
    addCamShake [2,1,5];
};
