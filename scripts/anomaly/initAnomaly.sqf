_anomalyLocats    = nearestLocations [worldCenter, ["Hill","FlatArea"], worldHalfSize];
_anomalyLocatsRdm = _anomalyLocats call BIS_fnc_arrayShuffle;

// Weaponslist
_longRangeLootWeap    = ["arifle_Katiba_C_F", "hgun_ACPC2_F"];
_longRangeLootWeap2   = ["SMG_01_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_01_MRD_F"];
_mediumRangeLootWeap  = ["hgun_Pistol_heavy_01_MRD_F","arifle_TRG21_F"];
_shortRangeLootWeap   = ["SMG_01_F","hgun_Pistol_Signal_F"];
_shortRangeLootWeap2  = ["MMG_02_sand_F","MMG_01_hex_F","srifle_GM6_camo_SOS_F","srifle_GM6_camo_F","arifle_TRG20_F","arifle_TRG21_F","arifle_SDAR_F","arifle_MXM_Black_F","arifle_MX_SW_Black_F","arifle_MX_Black_F","arifle_MXC_Black_F","arifle_MXM_F","arifle_MX_SW_F","arifle_MX_F","arifle_MXC_F","arifle_Mk20C_F","arifle_Mk20_F","arifle_Katiba_F","srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_F","srifle_LRR_F","LMG_Mk200_F","LMG_Zafir_F"];

// Items List
_longRangeLootItem    = ["V_BandollierB_blk","V_TacVest_blk_POLICE"];
_mediumRangeLootItem  = ["bipod_03_F_oli","optic_KHS_tan"];
_mediumRangeLootItem2 = ["MiniGrenade","SmokeShell","SmokeShellYellow","SmokeShellGreen","SmokeShellRed","SmokeShellPurple","SmokeShellOrange","SmokeShellBlue","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
_shortRangeLootItem   = ["Rangefinder","NVGoggles"];

for "_a" from 0 to 3 step 1 do {
	_anomaly    = _anomalyLocatsRdm select _a;
	anomalyPos = getPos _anomaly;

	_markerstr  = createMarker ["anomaly" + str _a , anomalyPos];
	_markerstr setMarkerShape "ICON";
	_markerstr setMarkerType "hd_dot";
	_markerstr setMarkerColor "ColorYellow";

	for "_i" from 0 to 19 step 1 do {

		// Add Loot
		_anomalyLoot = "GroundWeaponHolder" createVehicle anomalyPos;

		_newPos = [(getPos _anomalyLoot select 0) - 100 + random 200,(getPos _anomalyLoot select 1) - 100 + random 200,random 1];
		_anomalyLoot setPosATL _newPos;
		_anomalyLoot setDir round(random 359);
		_thisSpawnDistance =  getPos _anomalyLoot distance2d getPos _anomaly;

		// Add Short Range Loot
		if(_thisSpawnDistance < 33)then{
			if(random 100 < 50)then{
				if(random 100 < 50)then{
					_anomalyLoot addWeaponCargoGlobal [selectRandom _shortRangeLootWeap,1];
				}else{
					_anomalyLoot addWeaponCargoGlobal [selectRandom _shortRangeLootWeap2,1];
				};
			}else{
				_anomalyLoot addItemCargoGlobal [selectRandom _shortRangeLootItem,1];
			};
		};

		// Add Medium Range Loot
		if(_thisSpawnDistance >= 33 && _thisSpawnDistance < 66)then{
			if(random 100 < 50)then{
				_anomalyLoot addWeaponCargoGlobal [selectRandom _mediumRangeLootWeap,1];
			}else{
				if(random 100 < 50)then{
					_anomalyLoot addItemCargoGlobal [selectRandom _mediumRangeLootItem,1];
				}else{;
					_anomalyLoot addMagazineCargoGlobal [selectRandom _mediumRangeLootItem2,1];
				};
			};
		};

		// Add Long Range Loot
		if(_thisSpawnDistance >= 66)then{
			if(random 100 < 50)then{
				if(random 100 < 50)then{
					_anomalyLoot addWeaponCargoGlobal [selectRandom _longRangeLootWeap,1];
				}else{
					_anomalyLoot addWeaponCargoGlobal [selectRandom _longRangeLootWeap2,1];
				};
			}else{
				_anomalyLoot addItemCargoGlobal [selectRandom _longRangeLootItem,1];
			};
		};
	};
};
