_fnc_zombieBehaviour = compile preprocessFile "scripts\zombies\zombieBehaviour.sqf";
bde_fnc_spawnZombie = {
  _type     = _this select 0;
  _count    = _this select 1;
  _radius   = _this select 2;
  _pos      = _this select 3;
  _group    = _this select 4
  _spawner  = _this select 5;
  for "_i" from 1 to _count do {
    _spawnPos = [((_pos select 0)-_radius) + random (_radius*2),((_pos select 1)-_radius) + random (_radius*2),0];
    if([objNull, "VIEW"] checkVisibility [eyePos _spawner, [_pos select 0,_pos select 1,(_pos select 2) + 1]] == 0 && _spawner distance _pos > zMinSpawnRange)then{
        _z = selectRandom _useZlist;
        _z createUnit [_pos, _group,"[this] call _fnc_zombieBehaviour", 0, "NONE"];
        _z setVariable ["creatorPlayer", _spawner, false];
    };
  };
};
