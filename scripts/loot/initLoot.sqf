fnc_spawnLoot = {
  private ["_buildingType"];

  _playerPosition 	= _this select 0;

  // Military Lootlists
  _ammoGrenades         = ["MiniGrenade","SmokeShell","SmokeShellYellow","SmokeShellGreen","SmokeShellRed","SmokeShellPurple","SmokeShellOrange","SmokeShellBlue","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
  _itemsMil             = ["ItemGPS","Rangefinder","NVGoggles","Laserdesignator","Laserdesignator_02","Laserdesignator_03"];
  _equipmentMil         = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_blk","V_BandollierB_oli"];

  // Civilian Lootlists
  _itemsCiv             = ["ItemWatch","ItemCompass","ItemMap","Binocular","FirstAidKit","Medikit","ToolKit"];
  _equipmentCiv         = ["V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier3_rgr","V_PlateCarrierGL_rgr","V_PlateCarrier1_blk","V_PlateCarrierSpec_rgr","V_Chestrig_khk","V_Chestrig_rgr","V_Chestrig_blk","V_Chestrig_oli","V_TacVest_khk","V_TacVest_brn","V_TacVest_oli","V_TacVest_blk","V_TacVest_camo","V_TacVest_blk_POLICE","V_TacVestIR_blk","V_TacVestCamo_khk","V_HarnessO_brn","V_HarnessOGL_brn","V_HarnessO_gry","V_HarnessOGL_gry","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_RebreatherB","V_RebreatherIR","V_RebreatherIA","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F","V_Press_F","H_HelmetB","H_HelmetB_camo","H_HelmetB_paint","H_HelmetB_light","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_indp","H_Booniehat_mcamo","H_Booniehat_grn","H_Booniehat_tan","H_Booniehat_dirty","H_Booniehat_dgtl","H_Booniehat_khk_hs","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetIA","H_HelmetIA_net","H_HelmetIA_camo","H_Helmet_Kerry","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_headphones","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_brn_SPECOPS","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_Raven","H_Cap_blk_ION","H_Cap_oli_hs","H_Cap_press","H_Cap_usblack","H_Cap_surfer","H_Cap_police","H_HelmetCrew_B","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_MilCap_ocamo","H_MilCap_mcamo","H_MilCap_oucamo","H_MilCap_rucamo","H_MilCap_gry","H_MilCap_dgtl","H_MilCap_blue","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_BandMask_blk","H_BandMask_khk","H_BandMask_reaper","H_BandMask_demon","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_khk_hs","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_Shemag_olive_hs","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Beret_blk","H_Beret_blk_POLICE","H_Beret_red","H_Beret_grn","H_Beret_grn_SF","H_Beret_brn_SF","H_Beret_ocamo","H_Beret_02","H_Beret_Colonel","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","H_TurbanO_blk","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_RacingHelmet_1_F","H_RacingHelmet_2_F","H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_red_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_RacingHelmet_1_orange_F","H_Cap_marshal","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_FullGhillie_ard","U_O_FullGhillie_lsh","U_O_FullGhillie_sard","U_O_FullGhillie_ard","U_I_FullGhillie_lsh","U_I_FullGhillie_sard","U_I_FullGhillie_ard","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierIAGL_oli","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_C_Commoner2_1","U_C_Commoner2_2","	U_C_Commoner2_3","U_C_Commoner_shorts","U_C_Farmer","U_C_Fisherman","U_C_FishermanOveralls","U_C_HunterBody_brn","U_C_HunterBody_grn","U_C_Novak","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poor_1","U_C_Poor_2","U_C_Poor_shorts_1","U_C_Poor_shorts_2","U_C_PriestBody","U_C_Scavenger_1","U_C_Scavenger_2","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_WorkerCoveralls","U_C_WorkerOveralls","U_Competitor","U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_IG_leader","U_IG_Menelaos","U_KerryBody","U_MillerBody","U_NikosBody","U_OI_Scientist","U_OrestesBody","Rangemaster_Suit"];

  // JII Mod Items
  _foodItems            = ["bde_apple","bde_canunknown","bde_canpasta","bde_sodacan_01","bde_sodacan_02","bde_matches","bde_hatchet","bde_antibiotics","bde_zippo","bde_ducttape","bde_vitamines","bde_bottleuseless","bde_bottleempty","bde_bottlefilled","bde_bottleclean","bde_canteenempty","bde_canteenfilled","bde_bakedbeans","bde_tacticalbacon"];
  _medicalItems	        = ["bde_antiradiationtablets","bde_waterpurificationtablets","bde_antibiotics","bde_vitamines"];
  _toolItems            = ["bde_matches","bde_lock","bde_hatchet","bde_stone","bde_wood","bde_ducttape"];

  _garageStuff          = ["bde_camonetSmallPacked","bde_camonetBigPacked","bde_camonetVehiclesPacked","bde_tentCamoPacked","bde_tentDomePacked","bde_wheel","bde_fuelCanisterEmpty","bde_fuelCanisterFilled"];

  _garagesNames         = ["Land_i_Garage_V1_F","Land_i_Garage_V1_dam_F","Land_i_Garage_V2_F","Land_i_Garage_V2_dam_F"];
  _pierNames         	= ["Land_Pier_F","Land_Pier_Box_F","Land_Pier_wall_F"];
  _bridgeNames         	= ["Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F"];
  _BuildingsExclude     = _pierNames + _bridgeNames;

  _furnituresCivil      =["Land_ChairWood_F","Land_Metal_rack_F","Land_Rack_F","Land_Metal_wooden_rack_F","Land_ShelvesWooden_khaki_F","Land_ShelvesWooden_F","Land_WoodenTable_small_F","Land_WoodenTable_large_F","Land_ChairPlastic_F"];

  _buildings = nearestObjects [_playerPosition, ["Building"], 50];
  {
    _building       = _x;
    _buildingClass  = typeOf _x;
    _position       = getPos _building;
    _posBuilPos     = count(_building call BIS_fnc_buildingPositions);

    if ( buildingsListReady && _posBuilPos > 0 && !(_buildingClass in _BuildingsExclude) && (_building getVariable["hasLoot",0]) == 0) then {

	  _building setVariable["hasLoot",1,false];

      if(_buildingClass in militaryBuildings)then {
        _buildingType = "MilitaryBuilding";
      };

      if(_buildingClass in airportBuildings)then {
        _buildingType = "AirportBuilding";
      };

      if(_buildingClass in researchBuildings)then {
        _buildingType = "ResearchBuilding";
      };

      if(_buildingClass in constructBuildings)then {
        _buildingType = "ConstructionBuilding";
      };

      if( !(_buildingClass in (researchBuildings + constructBuildings + militaryBuildings + airportBuildings)) )then {
        _buildingType = "CivilianBuilding";
      };

      if(_posBuilPos > 0) then {
        for "_i" from 0 to _posBuilPos step 1 do {

            // Create Holder

    		_holderPos = _building buildingPos _i;
    		//_spawn = "WeaponHolderSimulated" createVehicle _holderPos;
            _spawn = createVehicle ["WeaponHolderSimulated", [_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.15], [], 0, "CAN_COLLIDE"];

    		// Options
            //_spawn setDir round(random 360);
            //_spawn setVehiclePosition [[_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.15], [], 0, "CAN_COLLIDE"];

            if(_buildingClass in _garagesNames)then {
                _spawn addMagazineCargoGlobal [selectRandom _garageStuff, 1];
            };

            switch(_buildingType) do {
                case "MilitaryBuilding":{
                  // Attachments
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom attachments,1];
                  };

                  // Tools
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom _itemsMil,1];
                  };

                  // Ammo only
                  if(random 100 < 30) then {
                    _rdmWeaponAmmoMil  = selectRandom (heavyWeapons call BIS_fnc_arrayShuffle);
                    _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoMil >> "magazines");
                    _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)+1];
                  };

                  // Backpacks
                  if(random 100 < 30) then {
                    _spawn addBackpackCargoGlobal [selectRandom backpacks,1];
                  };
                  // Cloth
                  if(random 100 < 30) then {
                    _spawn addItemCargoGlobal [selectRandom _equipmentMil,1];
                  };

                  // Grenades
                  if(random 100 < 30) then {
                    _spawn addMagazineCargoGlobal [selectRandom _ammoGrenades, round(random 2)];
                  };

                  // Weapons
                  if(random 100 < 30) then {
                    _rdmWeaponWeapMil = selectRandom (heavyWeapons call BIS_fnc_arrayShuffle);
                    _spawn addWeaponCargoGlobal [_rdmWeaponWeapMil,1];
                    _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapMil >> "magazines");
                    _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)];
                  };
                };

                case "AirportBuilding":{
                    // Ammo only
                    if(random 100 < 30) then {
                      _rdmWeaponAmmoAir  = selectRandom mediumWeapons;
                      _rmags      = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoAir >> "magazines");
                      _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)+1];
                    };

                    // Weapons
                    if(random 100 < 30) then {
                      _rdmWeaponWeapAir = selectRandom mediumWeapons;
                      _spawn addWeaponCargoGlobal [_rdmWeaponWeapAir,1];
                      _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapAir >> "magazines");
                      _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)];
                    };

                    // Tools
                    if(random 100 < 30) then {
                        _spawn addMagazineCargoGlobal [selectRandom _toolItems,1];
                    };

                    // Food
                    if(random 100 < 30) then {
                      _spawn addMagazineCargoGlobal [selectRandom _foodItems, 1];
                    };
                };

                case "ResearchBuilding":{
                  // Medicals & Chemicals
                  if(random 100 < 30) then {
                    _spawn addMagazineCargoGlobal [selectRandom _medicalItems, 1];
                  };
                };

                case "ConstructionBuilding":{
                    // Tools
                    if(random 100 < 30) then {
                        _spawn addMagazineCargoGlobal [selectRandom _toolItems,1];
                    };
                    // xtra Stone
                    if(random 100 < 30) then {
                        _spawn addMagazineCargoGlobal ["bde_stone",round(random 3)];
                    };
                };

                case "CivilianBuilding":{
                    // Furnitures
                    if(random 100 < 20 && !(_buildingClass in ["Land_Hangar_F","Land_TentHangar_V1_F"])) then {
                        if([_holderPos] call bde_fnc_underCover)then{
                            _furniture = createVehicle[selectRandom _furnituresCivil, _holderPos, [], 0, "CAN_COLLIDE"];
                            _furniture setDir round(random 360);
                            _furniture setVehiclePosition [[_holderPos select 0,_holderPos select 1,(_holderPos select 2) + 0.1], [], 0, "CAN_COLLIDE"];
                        };
                    }else{

                        // Food
                        if(random 100 < 30) then {
                            _spawn addMagazineCargoGlobal [selectRandom _foodItems, 1];
                        };

                        // Items
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal [selectRandom _itemsCiv,1];
                        };

                        // Ammo only
                        if(random 100 < 30) then {
                            _rdmWeaponAmmoCiv  = selectRandom lightWeapons;
                            _rmags      = getArray(configfile >> "cfgWeapons" >> _rdmWeaponAmmoCiv >> "magazines");
                            _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)+1];
                        };

                        // Backpacks
                        if(random 100 < 30) then {
                            _spawn addBackpackCargoGlobal [selectRandom backpacks,1];
                        };

                        // Cloth
                        if(random 100 < 30) then {
                            _spawn addItemCargoGlobal [selectRandom _equipmentCiv,1];
                        };

                        // Weapons
                        if(random 100 < 30) then {
                            _rdmWeaponWeapCiv = selectRandom lightWeapons;
                            _spawn addWeaponCargoGlobal [_rdmWeaponWeapCiv,1];
                            _rmags = getArray(configfile >> "cfgWeapons" >> _rdmWeaponWeapCiv >> "magazines");
                            _spawn addMagazineCargoGlobal [selectRandom _rmags, round(random 3)];
                        };
                    };
                };

                default {};
            };

        };
      };
    };
  }forEach(_buildings);
};
