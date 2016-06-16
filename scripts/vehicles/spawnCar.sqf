_pos = _this select 0;
_type = _this select 1;

_spawnedCar = _type createVehicle _pos;
_spawnedCar setDir random 180;
_spawnedCar setFuel random 1;

_hitPointsList = [(configfile >> "CfgVehicles" >> _type  >> "HitPoints"),0] call BIS_fnc_returnChildren;
{
	_xHitPoint = _x;
	_hitName = getText (_xHitPoint >> "name");

	_rdmDam = random 0.5;
	_spawnedCar setHit [_hitName, _rdmDam];

}forEach _hitPointsList;

_allHitPoints = getAllHitPointsDamage _spawnedCar;
_hitPointNames	= _allHitPoints select 0;
_hitPointsCount = count _hitPointNames;
for "_i" from 0 to _hitPointsCount do {
	if(count(_hitPointNames select _i) > 0)then{
		_spawnedCar setHitPointDamage [_hitPointNames select _i, 0.3 + (random 0.7)];
	};
};

clearWeaponCargoGlobal _spawnedCar;
clearMagazineCargoGlobal _spawnedCar;
clearItemCargoGlobal _spawnedCar;
