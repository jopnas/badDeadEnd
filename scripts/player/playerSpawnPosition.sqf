private["_playerUnit"];
_playerUnit = _this select 0;

while {true}do{
    _forests = selectBestPlaces [[16000,16000], 12000, "(1 + forest + trees) * (1 - sea) * (1 - houses)", 30, 20];
    _forests = _forests apply {_x select 0};
    _rdmSpawnPos = (selectRandom _forests) findEmptyPosition [0, 10, "C_man_1"];

    _nobodySeeSpawnPos = false;
    {
        _player = _x;
        if(alive _player && !([objNull, "VIEW"] checkVisibility [eyePos _player, _rdmSpawnPos]) )then{
            _nobodySeeSpawnPos = true;
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    if (_nobodySeeSpawnPos) exitWith {
        _playerUnit setPosATL getPos(_rdmSpawnPos);
        _playerUnit setVariable["playerSetupReady",true,false];
    };
};
