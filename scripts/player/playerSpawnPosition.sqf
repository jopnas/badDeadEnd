_playerUnit = _this select 0;

_forests = selectBestPlaces [worldCenter, worldHalfSize, "(1 + forest + trees) * (1 - sea) * (1 - houses - houses) * (1 - meadow - meadow)", 30, 20];

_forests = _forests apply {_x select 0};
_rdmSpawnPos = (selectRandom _forests) findEmptyPosition [0, 10, "C_man_1"];

_playerUnit setPosATL _rdmSpawnPos;
_playerUnit setVariable["playerSetupReady",true,false];
