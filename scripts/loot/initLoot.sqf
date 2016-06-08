fnc_spawnLoot = {
  private ["_rdmPistol","_rdmRifle","_buildingType"];
  _playerPosition 	= _this select 0;
  _isPlayerSpawn 	= _this select 1;

  // Military Lootlists
  _itemBackpacksMil     = ["B_AssaultPack_blk","B_AssaultPack_dgtl","B_AssaultPack_khk","B_AssaultPack_rgr","B_AssaultPack_sgg","B_AssaultPack_cbr","B_AssaultPack_mcamo","B_Bergen_mcamo","B_Carryall_oucamo","B_Carryall_ocamo","B_Carryall_mcamo","B_FieldPack_oucamo","B_FieldPack_ocamo","B_Kitbag_mcamo"];
  _ammoGrenades         = ["MiniGrenade","SmokeShell","SmokeShellYellow","SmokeShellGreen","SmokeShellRed","SmokeShellPurple","SmokeShellOrange","SmokeShellBlue","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
  _weaponRiflesMil      = ["MMG_02_sand_F","MMG_01_hex_F","srifle_GM6_camo_SOS_F","srifle_GM6_camo_F","arifle_TRG20_F","arifle_TRG21_F","arifle_SDAR_F","arifle_MXM_Black_F","arifle_MX_SW_Black_F","arifle_MX_Black_F","arifle_MXC_Black_F","arifle_MXM_F","arifle_MX_SW_F","arifle_MX_F","arifle_MXC_F","arifle_Mk20C_F","arifle_Mk20_F","arifle_Katiba_F","srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_F","srifle_LRR_F","LMG_Mk200_F","LMG_Zafir_F"];
  _weaponPistolsMil     = ["SMG_01_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_01_MRD_F"];
  _itemsMil             = ["ItemGPS","Rangefinder","NVGoggles","Laserdesignator","Laserdesignator_02","Laserdesignator_03","Zasleh2","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_H_SW","optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_SOS","acc_flashlight","acc_pointer_IR","optic_MRCO","muzzle_snds_acp","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS","muzzle_snds_338_black","muzzle_snds_338_green","muzzle_snds_338_sand","muzzle_snds_93mmg","muzzle_snds_93mmg_tan","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp","bipod_02_F_blk","bipod_02_F_tan","bipod_02_F_hex","bipod_03_F_blk","bipod_03_F_oli"];
  _equipmentMil         = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_blk","V_BandollierB_oli"];

  // Civilian Lootlists
  _itemBackpacksCiv     = ["B_Bergen_blk","B_Bergen_rgr","B_Bergen_sgg","B_Carryall_khk","B_Carryall_oli","B_Carryall_cbr","B_FieldPack_blk","B_FieldPack_cbr","B_HuntingBackpack","B_Kitbag_sgg","B_Kitbag_cbr","B_OutdoorPack_blk","B_OutdoorPack_blu","B_OutdoorPack_tan"];
  _weaponRiflesCiv      = ["SMG_02_F","arifle_Mk20C_plain_F","arifle_Mk20_plain_F","arifle_Katiba_C_F"];
  _weaponPistolsCiv     = ["hgun_Pistol_Signal_F","hgun_PDW2000_F","hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F","hgun_Pistol_heavy_02_F"];
  _itemsCiv             = ["ItemWatch","ItemCompass","ItemMap","Binocular","FirstAidKit","Medikit","ToolKit"];
  _equipmentCiv         = ["V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier3_rgr","V_PlateCarrierGL_rgr","V_PlateCarrier1_blk","V_PlateCarrierSpec_rgr","V_Chestrig_khk","V_Chestrig_rgr","V_Chestrig_blk","V_Chestrig_oli","V_TacVest_khk","V_TacVest_brn","V_TacVest_oli","V_TacVest_blk","V_TacVest_camo","V_TacVest_blk_POLICE","V_TacVestIR_blk","V_TacVestCamo_khk","V_HarnessO_brn","V_HarnessOGL_brn","V_HarnessO_gry","V_HarnessOGL_gry","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_RebreatherB","V_RebreatherIR","V_RebreatherIA","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F","V_Press_F","H_HelmetB","H_HelmetB_camo","H_HelmetB_paint","H_HelmetB_light","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_indp","H_Booniehat_mcamo","H_Booniehat_grn","H_Booniehat_tan","H_Booniehat_dirty","H_Booniehat_dgtl","H_Booniehat_khk_hs","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetIA","H_HelmetIA_net","H_HelmetIA_camo","H_Helmet_Kerry","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_headphones","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_brn_SPECOPS","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_Raven","H_Cap_blk_ION","H_Cap_oli_hs","H_Cap_press","H_Cap_usblack","H_Cap_surfer","H_Cap_police","H_HelmetCrew_B","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_MilCap_ocamo","H_MilCap_mcamo","H_MilCap_oucamo","H_MilCap_rucamo","H_MilCap_gry","H_MilCap_dgtl","H_MilCap_blue","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_BandMask_blk","H_BandMask_khk","H_BandMask_reaper","H_BandMask_demon","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_khk_hs","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_Shemag_olive_hs","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Beret_blk","H_Beret_blk_POLICE","H_Beret_red","H_Beret_grn","H_Beret_grn_SF","H_Beret_brn_SF","H_Beret_ocamo","H_Beret_02","H_Beret_Colonel","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","H_TurbanO_blk","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_RacingHelmet_1_F","H_RacingHelmet_2_F","H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_red_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_RacingHelmet_1_orange_F","H_Cap_marshal","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_FullGhillie_ard","U_O_FullGhillie_lsh","U_O_FullGhillie_sard","U_O_FullGhillie_ard","U_I_FullGhillie_lsh","U_I_FullGhillie_sard","U_I_FullGhillie_ard","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierIAGL_oli","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_C_Commoner2_1","U_C_Commoner2_2","	U_C_Commoner2_3","U_C_Commoner_shorts","U_C_Farmer","U_C_Fisherman","U_C_FishermanOveralls","U_C_HunterBody_brn","U_C_HunterBody_grn","U_C_Novak","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poor_1","U_C_Poor_2","U_C_Poor_shorts_1","U_C_Poor_shorts_2","U_C_PriestBody","U_C_Scavenger_1","U_C_Scavenger_2","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_WorkerCoveralls","U_C_WorkerOveralls","U_Competitor","U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_IG_leader","U_IG_Menelaos","U_KerryBody","U_MillerBody","U_NikosBody","U_OI_Scientist","U_OrestesBody","Rangemaster_Suit"];

  // JII Mod Items
  _foodItems            = ["jii_canunknown","jii_canpasta","jii_canrusty","jii_matches","jii_hatchet","jii_antibiotics","jii_zippo","jii_ducttape","jii_vitamines","jii_bottleuseless","jii_bottleempty","jii_bottlefilled","jii_bottleclean","jii_canteenempty","jii_canteenfilled","jii_bakedbeans","jii_tacticalbacon"];
  _medicalItems	        = ["jii_waterpurificationtablets","jii_antibiotics","jii_vitamines"];
  _toolItems            = ["jii_matches","jii_hatchet","jii_stone","jii_wood","jii_ducttape","jii_tire"/*,"jii_fuelcan"*/];

  _garagesNames         = ["Land_i_Garage_V1_F","Land_i_Garage_V1_dam_F","Land_i_Garage_V2_F","Land_i_Garage_V2_dam_F"];
  _pierNames         	= ["Land_Pier_F","Land_Pier_Box_F","Land_Pier_wall_F"];
  _bridgeNames         	= ["Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F"];
  _BuildingsExclude     = _garagesNames + _pierNames + _bridgeNames;

  _buildings = nearestObjects [_playerPosition, ["Building"], 50];
  {
    _building     = _x;
    _position     = getPos _building;
    _strHouseType = str(typeOf _building);

	//systemChat format["loot: %1",_building getVariable["hasLoot",0]];

    if ( !(typeOf _building in _BuildingsExclude) && (_building getVariable["hasLoot",0]) == 0 && !(str _building find  "ruins" > -1)) then {

	  _building setVariable["hasLoot",1,true];

      if(typeOf _building in militaryBuildings)then {
        _buildingType = "MilitaryBuilding";
      };

      if(typeOf _building in researchBuildings)then {
        _buildingType = "ResearchBuilding";
      };

      if(typeOf _building in constructBuildings)then {
        _buildingType = "ConstructionBuilding";
      };

      if(!(typeOf _building in (researchBuildings+constructBuildings+militaryBuildings)))then {
        _buildingType = "CivilianBuilding";
      };

      _posBuilPos = count(_building call BIS_fnc_buildingPositions);
      if(_posBuilPos > 0) then {
        for "_i" from 0 to _posBuilPos step 1 do {

          // Create Holder

			_holderPos = _building buildingPos _i;
			_spawn = createVehicle ["groundWeaponHolder",_holderPos,[],0,"can_collide"];

			// Options
			_spawn setPosATL _holderPos;
			_spawn setDir round(random 180);

          switch(_buildingType) do {
            case "MilitaryBuilding":{
              // Attachments & Items
              if(random 100 < 30) then {
                _spawn addItemCargoGlobal [_itemsMil call BIS_fnc_selectRandom,1];
              };
              // Ammo for Pistols
              if(random 100 < 30) then {
                _rdmPistol = _weaponPistolsMil call BIS_fnc_selectRandom;
                _pmags = getArray(configfile >> "cfgWeapons" >> _rdmPistol >> "magazines");
                _spawn addMagazineCargoGlobal [_pmags call BIS_fnc_selectRandom, round(random 3)+2];
              };
              // Ammo for Rifles
              if(random 100 < 30) then {
                _rdmRifle = _weaponRiflesMil call BIS_fnc_selectRandom;
                _rmags = getArray(configfile >> "cfgWeapons" >> _rdmRifle >> "magazines");
                _spawn addMagazineCargoGlobal [_rmags call BIS_fnc_selectRandom, round(random 2)+2];
              };
              // Backpacks
              if(random 100 < 30) then {
                _spawn addBackpackCargoGlobal [_itemBackpacksMil call BIS_fnc_selectRandom,1];
              };
              // Cloth
              if(random 100 < 30) then {
                _spawn addItemCargoGlobal [_equipmentMil call BIS_fnc_selectRandom,1];
              };
              // Pistols
              if(random 100 < 20) then {
                _rdmPistol = _weaponPistolsMil call BIS_fnc_selectRandom;
                _spawn addWeaponCargoGlobal [_rdmPistol,1];
                _pmags = getArray(configfile >> "cfgWeapons" >> _rdmPistol >> "magazines");
                _spawn addMagazineCargoGlobal [_pmags call BIS_fnc_selectRandom, round(random 3)];
              };
              // Rifles
              if(random 100 < 30) then {
                _rdmRifle = _weaponRiflesMil call BIS_fnc_selectRandom;
                _spawn addWeaponCargoGlobal [_rdmRifle,1];
                _rmags = getArray(configfile >> "cfgWeapons" >> _rdmRifle >> "magazines");
                _spawn addMagazineCargoGlobal [_rmags call BIS_fnc_selectRandom, round(random 2)];
              };
            };

            case "ResearchBuilding":{
              // Medicals & Chemicals
              if(random 100 < 40) then {
                _spawn addMagazineCargoGlobal [_medicalItems call BIS_fnc_selectRandom, 1];
              };
            };

            case "ConstructionBuilding":{
                // Tools
                if(random 100 < 10) then {
                    _spawn addMagazineCargoGlobal [_toolItems call BIS_fnc_selectRandom,1];
                };
                // xtra Stone
                if(random 100 < 10) then {
                    _spawn addMagazineCargoGlobal ["jii_stone",round(random 3)];
                };
            };

            case "CivilianBuilding":{
              // Food
              if(random 100 < 40) then {
                _spawn addMagazineCargoGlobal [_foodItems call BIS_fnc_selectRandom, 1];
              };
              // Attachments & Items
              if(random 100 < 5) then {
                _spawn addItemCargoGlobal [_itemsCiv call BIS_fnc_selectRandom,1];
              };
              // Ammo for Pistols
              if(random 100 < 10) then {
                _rdmPistol = _weaponPistolsCiv call BIS_fnc_selectRandom;
                _pmags = getArray(configfile >> "cfgWeapons" >> _rdmPistol >> "magazines");
                _spawn addMagazineCargoGlobal [_pmags call BIS_fnc_selectRandom, round(random 3)+1];
              };
              // Ammo for Rifles
              if(random 100 < 10) then {
                _rdmRifle = _weaponRiflesCiv call BIS_fnc_selectRandom;
                _rmags = getArray(configfile >> "cfgWeapons" >> _rdmRifle >> "magazines");
                _spawn addMagazineCargoGlobal [_rmags call BIS_fnc_selectRandom, round(random 2)+1];
              };
              // Backpacks
              if(random 100 < 5) then {
                _spawn addBackpackCargoGlobal [_itemBackpacksCiv call BIS_fnc_selectRandom,1];
              };
              // Cloth
              if(random 100 < 10) then {
                _spawn addItemCargoGlobal [_equipmentCiv call BIS_fnc_selectRandom,1];
              };
              // Pistols
              if(random 100 < 5) then {
                _rdmPistol = _weaponPistolsCiv call BIS_fnc_selectRandom;
                _spawn addWeaponCargoGlobal [_rdmPistol,1];
                _pmags = getArray(configfile >> "cfgWeapons" >> _rdmPistol >> "magazines");
                _spawn addMagazineCargoGlobal [_pmags call BIS_fnc_selectRandom, round(random 3)];
              };
              // Rifles
              if(random 100 < 2) then {
                _rdmRifle = _weaponRiflesCiv call BIS_fnc_selectRandom;
                _spawn addWeaponCargoGlobal [_rdmRifle,1];
                _rmags = getArray(configfile >> "cfgWeapons" >> _rdmRifle >> "magazines");
                _spawn addMagazineCargoGlobal [_rmags call BIS_fnc_selectRandom, round(random 2)];
              };
            };

            default {};
          };

        };
      };
    };
  }forEach(_buildings);
};
