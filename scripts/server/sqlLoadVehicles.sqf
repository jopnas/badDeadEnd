_result = call compile ("extDB2" callExtension "0:SQL_VH_LOAD:SELECT * FROM vehicles");

waitUntil{count _result > 0 && _result select 0 > 0};
_vehiclesQueryStatus  = _result select 0;
_vehiclesInDB         = _result select 1;

{
    private["_spawnedVehicle","_type","_vehPosition"];
	_id        = _x select 0;
	_classname = _x select 1;
	_position  = _x select 2;
	_rotation  = _x select 3;
	_fuel      = _x select 4;
	_destroyed = _x select 5;
	_type      = _x select 6;
	_damage    = _x select 7;
	_items     = _x select 8;
	_weapons   = _x select 9;
	_magazines = _x select 10;
	_backpacks = _x select 11;

    _bde_fnc_randRoadPos = {
        params["_classname"];
        _towns = nearestLocations [worldCenter, ["NameVillage","NameCity","NameCityCapital"], worldHalfSize];
        _roads = getPos selectRandom(_towns) nearRoads 1000;
        _roadPosition = getPos selectRandom(_roads);
        _position1 = _roadPosition findEmptyPosition [0,100,_classname];
        _position1
    };

    _bde_fnc_randAirfieldPos = {
        /*params["_classname"];
        _airports = nearestLocations [worldCenter, ["Airport"], worldHalfSize];
        _airfields = getPos selectRandom(_airports) nearRoads 500;
        __airfieldPosition = getPos selectRandom(_airfields);
        _position2 = _airfieldPosition findEmptyPosition [0,100,_classname];
        _position2*/


    };

    _bde_fnc_randHeliportPos = {
        params["_classname"];
        _helipads = nearestObjects [worldCenter, ["Land_HelipadSquare_F","Land_HelipadRescue_F","Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F"], worldHalfSize];
        _rdmHelipad = selectRandom _helipads;
        _heliportPosition = getPosATL _rdmHelipad;
        _heliportPosition
    };

    if(_destroyed == 1) then {
        _vehPosition = [0,0,0];
        if(_type == "heli")then{
            _vehPosition = [_classname] call _bde_fnc_randHeliportPos;
        };
        if(_type == "car")then{
            _vehPosition = [_classname] call _bde_fnc_randRoadPos;
        };
        if(_type == "plane")then{
            _vehPosition = [_classname] call _bde_fnc_randRoadPos; //_bde_fnc_randAirfieldPos;
        };

        //systemchat str _vehPosition;

        _spawnedVehicle = _classname createVehicle _vehPosition;
        _spawnedVehicle setVariable["id",_id,true];
        _spawnedVehicle setDir random 180;
        _spawnedVehicle setFuel random 1;

        _allHitPoints = getAllHitPointsDamage _spawnedVehicle;
        _hitPointNames	= _allHitPoints select 0;
        _hitPointsCount = count _hitPointNames;
        for "_i" from 0 to _hitPointsCount do {
            if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, 0.3 + (random 0.7)];
            };
        };

        clearWeaponCargoGlobal _spawnedVehicle;
        clearMagazineCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

        [_spawnedVehicle] call fnc_saveVehicle;

    }else{
        _spawnedVehicle = createVehicle [_classname,_position,[],0,"can_collide"];
        _spawnedVehicle setVectorDirAndUp  _rotation;
        _spawnedVehicle setVehiclePosition [_position, [], 0, "can_collide"];

        _spawnedVehicle setVariable["id",_id,true];
        _spawnedVehicle setVariable["type",_type,true];

        clearMagazineCargoGlobal _spawnedVehicle;
        clearBackpackCargoGlobal _spawnedVehicle;
        clearWeaponCargoGlobal _spawnedVehicle;
        clearItemCargoGlobal _spawnedVehicle;

    	_spawnedVehicle setFuel _fuel;

        if(str _items != "[[],[]]")then{
        	{
        		_count_items = (_items select 1) select _foreachindex;
        		_spawnedVehicle addItemCargoGlobal[_x,_count_items];
        	} forEach (_items select 0);
        };

        if(str _weapons != "[[],[]]")then{
        	{
        		_count_weapons = (_weapons select 1) select _foreachindex;
        		_spawnedVehicle addWeaponCargoGlobal [_x,_count_weapons];
        	} forEach (_weapons select 0);
        };

        if(str _magazines != "[[],[]]")then{
        	{
        		_count_magazines = (_magazines select 1) select _foreachindex;
        		_spawnedVehicle addMagazineCargoGlobal [_x,_count_magazines];
        	} forEach (_magazines select 0);
        };

        if(str _backpacks != "[[],[]]")then{
        	{
        		_count_backpacks = (_backpacks select 1) select _foreachindex;
        		_spawnedVehicle addBackpackCargoGlobal [_x, _count_backpacks];
        	} forEach (_backpacks select 0);
        };

    	_hitPointNames	= _damage select 0;
    	_hitPointValues	= _damage select 1;
    	_hitPointsCount = count _hitPointNames;

    	for "_i" from 0 to _hitPointsCount do {
    		if(count(_hitPointNames select _i) > 0)then{
                _spawnedVehicle setHitPointDamage [_hitPointNames select _i, _hitPointValues select _i];
    		};
    	};
    };

    // EventHandlers for saving vehicle to db
    _spawnedVehicle addEventHandler ["ContainerClosed", {
        params["_vehicle","_player"];
        [_vehicle] call fnc_saveVehicle;
        systemChat format["closed inventory of %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["Hit", {
        params["_vehicle","_causedBy","_damage"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        systemChat format["hit %1 by %2",typeOf _vehicle,_causedBy];
    }];
    _spawnedVehicle addEventHandler ["Killed", {
        params["_vehicle","_killer"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        deleteMarker format["vehicle %1",_vehicle getVariable "id"];
        systemChat format["destroyed %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["Fuel", {
        params["_vehicle","_fuelState"];
        [_vehicle] call fnc_saveVehicle;
        systemChat format["fuel state changed from %1",typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["GetOut", {
        params["_vehicle","_position","_unit","_turret"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        systemChat format["%1 exit %2",_unit,typeOf _vehicle];
    }];
    _spawnedVehicle addEventHandler ["GetIn", {
        params["_vehicle","_position","_unit","_turret"];
        [_vehicle] call bde_fnc_removeRepairActions;
        [_vehicle] call fnc_saveVehicle;
        systemChat format["%1 enters %2",_unit,typeOf _vehicle];
    }];

    // Actions (repair etc.)
    _spawnedVehicle setVariable ["repairActionIDs", [], false];
    _spawnedVehicle addAction[format["repair %1",_type],{
        _spawnedVehicle = _this select 3;
        [_spawnedVehicle] execVM "scripts\vehicles\repairVehicleActions.sqf";
    },_spawnedVehicle,0,false,false,"","'ToolKit' in Items _this && vehicle _this == _this && count (_target getVariable ['repairActionIDs', []]) == 0",3,false];

    _spawnedVehicle addAction[format["refuel %1",_type],{
        _target = _this select 0;
        _caller = _this select 1;
        _type   = _this select 3;
        if(fuel _target + 0.5 > 1)then{
            _target setFuel 1;
        }else{
            _target setFuel (fuel _target + 0.5);
        };
        _caller removeMagazine "bde_fuelCanisterFilled";
        _caller addMagazine "bde_fuelCanisterEmpty";
    },_type,0,false,false,"","'bde_fuelCanisterFilled' in Magazines _this && vehicle _this == _this && fuel _target < 1",3,false];

    // Debug
    if(_type == "heli")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_air";
        _markerstr setMarkerColor "ColorGreen";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };
    if(_type == "car")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_car";
        _markerstr setMarkerColor "ColorBlue";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };
    if(_type == "plane")then{
        _markerstr = createMarker [format["vehicle %1",_id], getPos _spawnedVehicle];
        _markerstr setMarkerType "c_plane";
        _markerstr setMarkerColor "ColorBlue";
        _markerstr setMarkerText format["class: %1, id: %2",_classname,_id];
    };

    sleep 0.5;
} forEach _vehiclesInDB;

/* Apex
-----------------------
Vehicles
-----------------------
"C_Offroad_02_unarmed_F"    // JEEP
"B_T_LSV_01_armed_F"        // HUMMER, offen, 2 x MGs
"B_T_LSV_01_unarmed_F"      // HUMMER, offen
"O_T_LSV_02_armed_F"        // HUMMER, offen, Vulcan, sixtaedon tarn
"O_T_LSV_02_unarmed_F"      // HUMMER, offen, sixtaedon tarn
"B_T_UAV_03_F"              // Heli Drone , bewaffnet, div. Raketen
"C_Plane_Civil_01_F"        // Cessna, unbewaffnet ;-)
"O_T_UAV_04_CAS_F"          // Jet Drone, bewaffnet, div. Raketen
"B_T_VTOL_01_armed_F"       // Großer Senkrechtstarter
"B_T_VTOL_01_infantry_F"    // Großer Senkrechtstarter
"O_T_VTOL_02_infantry_F"    // Großer Senkrechtstarter, Jet
"I_C_Boat_Transport_02_F"   // Boot :-p
"C_Scooter_Transport_01_F" // WaterScooter


-----------------------
Rifles
-----------------------
{ "arifle_AK12_F" },
{ "arifle_AK12_GL_F" },
{ "arifle_AKM_F" },
{ "arifle_AKM_FL_F" },
{ "arifle_AKS_F" },
{ "arifle_ARX_blk_F" },
{ "arifle_ARX_ghex_F" },
{ "arifle_ARX_hex_F" },
{ "arifle_CTAR_blk_F" },
{ "arifle_CTAR_GL_blk_F" },
{ "arifle_CTARS_blk_F" },
{ "arifle_MX_GL_khk_F" },
{ "arifle_MX_khk_F" },
{ "arifle_MX_SW_khk_F" },
{ "arifle_MXC_khk_F" },
{ "arifle_MXM_khk_F" },
{ "arifle_SPAR_01_blk_F" },
{ "arifle_SPAR_01_khk_F" },
{ "arifle_SPAR_01_snd_F" },
{ "arifle_SPAR_01_GL_blk_F" },
{ "arifle_SPAR_01_GL_khk_F" },
{ "arifle_SPAR_01_GL_snd_F" },
{ "arifle_SPAR_02_blk_F" },
{ "arifle_SPAR_02_khk_F" },
{ "arifle_SPAR_02_snd_F" },
{ "arifle_SPAR_03_blk_F" },
{ "arifle_SPAR_03_khk_F" },
{ "arifle_SPAR_03_snd_F" }

-----------------------
LMG
-----------------------
{ "LMG_03_F" }


-----------------------
SMG
-----------------------
{ "SMG_05_F" }


-----------------------
Snipers
-----------------------
{ "srifle_DMR_07_blk_F" },
{ "srifle_DMR_07_ghex_F" },
{ "srifle_DMR_07_hex_F" },
{ "srifle_GM6_ghex_F" },
{ "srifle_LRR_tna_F" }


-----------------------
Pistols
-----------------------
{ "hgun_P07_khk_F" },
{ "hgun_Pistol_01_F" }


-----------------------
Muzzles
-----------------------
{ "muzzle_snds_65_TI_blk_F" },
{ "muzzle_snds_58_wdm_F" },
{ "muzzle_snds_B_snd_F" },
{ "muzzle_snds_B_khk_F" },
{ "muzzle_snds_H_MG_khk_F" },
{ "muzzle_snds_H_MG_blk_F" },
{ "muzzle_snds_65_TI_ghex_F" },
{ "muzzle_snds_65_TI_hex_F" }


-----------------------
Headgear
-----------------------
{ "H_Helmet_Skate" },
{ "H_HelmetB_TI_tna_F" },
{ "H_HelmetB_tna_F" },
{ "H_HelmetB_Enh_tna_F" },
{ "H_HelmetB_Light_tna_F" },
{ "H_HelmetSpecO_ghex_F" },
{ "H_HelmetLeaderO_ghex_F" },
{ "H_HelmetO_ghex_F" },
{ "H_HelmetCrew_O_ghex_F" },
{ "H_MilCap_tna_F" },
{ "H_MilCap_ghex_F" },
{ "H_Booniehat_tna_F" },
{ "H_Beret_gen_F" },
{ "H_MilCap_gen_F" }


-----------------------
Clothes
-----------------------
{ "U_B_T_Soldier_F" },
{ "U_B_T_Soldier_AR_F" },
{ "U_B_T_Soldier_SL_F" },
{ "U_B_T_Sniper_F" },
{ "U_B_T_FullGhillie_tna_F" },
{ "U_B_CTRG_Soldier_F" },
{ "U_B_CTRG_Soldier_2_F" },
{ "U_B_CTRG_Soldier_3_F" },
{ "U_B_GEN_Soldier_F" },
{ "U_B_GEN_Commander_F" },
{ "U_O_T_Soldier_F" },
{ "U_O_T_Officer_F" },
{ "U_O_T_Sniper_F" },
{ "U_O_T_FullGhillie_tna_F" },
{ "U_O_V_Soldier_Viper_F" },
{ "U_O_V_Soldier_Viper_hex_F" },
{ "U_I_C_Soldier_Para_1_F" },
{ "U_I_C_Soldier_Para_2_F" },
{ "U_I_C_Soldier_Para_3_F" },
{ "U_I_C_Soldier_Para_4_F" },
{ "U_I_C_Soldier_Para_5_F" },
{ "U_I_C_Soldier_Bandit_1_F" },
{ "U_I_C_Soldier_Bandit_2_F" },
{ "U_I_C_Soldier_Bandit_3_F" },
{ "U_I_C_Soldier_Bandit_4_F" },
{ "U_I_C_Soldier_Bandit_5_F" },
{ "U_I_C_Soldier_Camo_F" },
{ "U_C_man_sport_1_F" },
{ "U_C_man_sport_2_F" },
{ "U_C_man_sport_3_F" },
{ "U_C_Man_casual_1_F" },
{ "U_C_Man_casual_2_F" },
{ "U_C_Man_casual_3_F" },
{ "U_C_Man_casual_4_F" },
{ "U_C_Man_casual_5_F" },
{ "U_C_Man_casual_6_F" },
{ "U_B_CTRG_Soldier_urb_1_F" },
{ "U_B_CTRG_Soldier_urb_2_F" },
{ "U_B_CTRG_Soldier_urb_3_F" }


-----------------------
Backpacks
-----------------------
{ "B_ViperLightHarness_khk_F" },
{ "B_ViperLightHarness_blk_F" },
{ "B_ViperLightHarness_hex_F" },
{ "B_ViperLightHarness_oli_F" },
{ "B_ViperLightHarness_ghex_F" },
{ "B_ViperHarness_oli_F" },
{ "B_ViperHarness_khk_F" },
{ "B_ViperHarness_ghex_F" },
{ "B_ViperHarness_blk_F" },
{ "B_FieldPack_ghex_F" },
{ "B_AssaultPack_tna_F" },
{ "B_vehicleryall_ghex_F" },
{ "B_Bergen_tna_F" },
{ "B_Bergen_hex_F" },
{ "B_Bergen_dgtl_F" },
{ "B_Bergen_mcamo_F" },
{ "B_ViperHarness_hex_F" }


-----------------------
Vests
-----------------------
{ "V_PlateCarrier1_tna_F" },
{ "V_PlateCarrier2_tna_F" },
{ "V_PlateCarrierSpec_tna_F" },
{ "V_PlateCarrierGL_tna_F" },
{ "V_HarnessO_ghex_F" },
{ "V_HarnessOGL_ghex_F" },
{ "V_BandollierB_ghex_F" },
{ "V_TacVest_gen_F" },
{ "V_PlateCarrier1_rgr_noflag_F" },
{ "V_PlateCarrier2_rgr_noflag_F" }
*/
