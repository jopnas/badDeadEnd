_pos = _this select 0;
_type = _this select 1;
//_vListCiv = ["B_G_Van_01_transport_F","C_Van_01_box_F","SUV_01_base_black_F","SUV_01_base_orange_F","SUV_01_base_red_F","C_SUV_01_F","C_Hatchback_01_sport_green_F","C_Hatchback_01_sport_grey_F","C_Hatchback_01_sport_white_F","C_Hatchback_01_sport_orange_F","C_Hatchback_01_sport_blue_F","C_Hatchback_01_sport_red_F","C_Hatchback_01_dark_F","C_Hatchback_01_black_F","C_Hatchback_01_white_F","C_Hatchback_01_yellow_F","C_Hatchback_01_beigecustom_F","C_Hatchback_01_bluecustom_F","C_Hatchback_01_blue_F","C_Hatchback_01_green_F","C_Hatchback_01_grey_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","C_Quadbike_01_white_F","C_Quadbike_01_red_F","C_Quadbike_01_blue_F","C_Quadbike_01_black_F","C_Quadbike_01_F","C_Offroad_stripped_F","C_Offroad_default_F","C_Offroad_luxe_F","C_Offroad_01_bluecustom_F","C_Offroad_01_darkred_F","C_Offroad_01_blue_F","C_Offroad_01_white_F","C_Offroad_01_sand_F","C_Offroad_01_red_F","C_Offroad_01_F"];
//_vListMil = ["I_Truck_02_fuel_F","I_Truck_02_medical_F","I_Truck_02_box_F","I_Truck_02_transport_F","I_Truck_02_covered_F","B_G_Offroad_01_F","B_G_Offroad_01_repair_F","B_MRAP_01_F","B_Quadbike_01_F","B_G_Quadbike_01_F","B_Truck_01_transport_F","B_Truck_01_covered_F","B_Truck_01_mover_F","B_Truck_01_Repair_F","B_Truck_01_fuel_F"];
//_vListSup = ["C_Van_01_fuel_white_v2_F","C_Van_01_fuel_red_F","B_G_Van_01_fuel_F","C_Offroad_01_repair_F"];
//_vListSpc = ["I_UGV_01_F"];

//_rdmCar = (_vListCiv + _vListMil + _vListSup + _vListSpc) call BIS_fnc_selectRandom;
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
