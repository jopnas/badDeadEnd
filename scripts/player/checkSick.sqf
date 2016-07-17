if(playerHealth < 5) then {
	_newVal = playerSick + 0.0001;
	if(_newVal < 0)then{
		_newVal = 0;
	};
	if(_newVal > 1)then{
		_newVal = 1;
	};
	playerSick = _newVal;
};
