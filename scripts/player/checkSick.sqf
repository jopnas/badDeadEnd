_playerSick    = player getVariable ["playerSick",0];
_playerHealth  = player getVariable ["playerHealth",0];
if(_playerHealth < 5) then {
	_newVal = _playerSick + 0.0001;
	if(_newVal < 0)then{
		_newVal = 0;
	};
	if(_newVal > 1)then{
		_newVal = 1;
	};
	player setVariable ["playerSick",_newVal,true];
};
