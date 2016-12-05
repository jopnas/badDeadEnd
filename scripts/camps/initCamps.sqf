_campLocats         = selectBestPlaces [[16000,16000],12000,"(5 * forest) + (4 * trees) + (3 * meadow) - (20 * houses) - (30 * sea)", 30, 10];
_campLocatsRdm      = _campLocats call BIS_fnc_arrayShuffle;

// Camp Components
_tents              = ["bde_tentCamo","bde_tentDome"];
_fireplaces         = ["Land_Campfire_F","Land_FirePlace_F"];
_campstuff          = ["Land_WoodPile_large_F","Land_WoodenLog_F","Land_CampingTable_small_F","Land_CampingChair_V2_F","Land_CampingChair_V1_folded_F","Land_CampingChair_V1_F","Land_WoodPile_F","Land_Camping_Light_off_F"];
_garbageTypes       = ["Land_Garbage_square3_F","Land_Garbage_square5_F"];

// Loot
_foodItems          = ["bde_hatchet","bde_antibiotics","bde_ducttape","bde_ducttape_empty","bde_ducttape_6","bde_ducttape_5","bde_ducttape_4","bde_ducttape_3","bde_ducttape_2","bde_ducttape_1","bde_vitamines","bde_bottleuseless","bde_bottleempty","bde_bottledirty","bde_bottleclean","bde_canteenempty","bde_canteenfilled"];
// Military Lootlists
_itemBackpacksMil   = ["B_AssaultPack_blk","B_AssaultPack_dgtl","B_AssaultPack_khk","B_AssaultPack_rgr","B_AssaultPack_sgg","B_AssaultPack_cbr","B_AssaultPack_mcamo","B_Bergen_mcamo","B_Carryall_oucamo","B_Carryall_ocamo","B_Carryall_mcamo","B_FieldPack_oucamo","B_FieldPack_ocamo","B_Kitbag_mcamo"];
_weaponRiflesMil    = ["bde_spas12","MMG_02_sand_F","MMG_01_hex_F","srifle_GM6_camo_SOS_F","srifle_GM6_camo_F","arifle_TRG20_F","arifle_TRG21_F","arifle_SDAR_F","arifle_MXM_Black_F","arifle_MX_SW_Black_F","arifle_MX_Black_F","arifle_MXC_Black_F","arifle_MXM_F","arifle_MX_SW_F","arifle_MX_F","arifle_MXC_F","arifle_Mk20C_F","arifle_Mk20_F","arifle_Katiba_F","srifle_DMR_01_F","srifle_EBR_F","srifle_GM6_F","srifle_LRR_F","LMG_Mk200_F","LMG_Zafir_F"];
_weaponPistolsMil   = ["SMG_01_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_01_MRD_F"];
_itemsMil           = ["ItemGPS","Rangefinder","NVGoggles","Laserdesignator","Laserdesignator_02","Laserdesignator_03","Zasleh2","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","muzzle_snds_H_MG","muzzle_snds_H_SW","optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Holosight","optic_Holosight_smg","optic_SOS","acc_flashlight","acc_pointer_IR","optic_MRCO","muzzle_snds_acp","optic_NVS","optic_Nightstalker","optic_tws","optic_tws_mg","optic_DMS","optic_Yorris","optic_MRD","optic_LRPS","muzzle_snds_338_black","muzzle_snds_338_green","muzzle_snds_338_sand","muzzle_snds_93mmg","muzzle_snds_93mmg_tan","optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan","bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp","bipod_02_F_blk","bipod_02_F_tan","bipod_02_F_hex","bipod_03_F_blk","bipod_03_F_oli"];
_equipmentMil       = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_blk","V_BandollierB_oli"];
// Civilian Lootlists
_itemBackpacksCiv   = ["B_Bergen_blk","B_Bergen_rgr","B_Bergen_sgg","B_Carryall_khk","B_Carryall_oli","B_Carryall_cbr","B_FieldPack_blk","B_FieldPack_cbr","B_HuntingBackpack","B_Kitbag_sgg","B_Kitbag_cbr","B_OutdoorPack_blk","B_OutdoorPack_blu","B_OutdoorPack_tan"];
_weaponRiflesCiv    = ["SMG_02_F","arifle_Mk20C_plain_F","arifle_Mk20_plain_F","arifle_Katiba_C_F"];
_weaponPistolsCiv   = ["hgun_Pistol_Signal_F","hgun_PDW2000_F","hgun_ACPC2_F","hgun_P07_F","hgun_Rook40_F","hgun_Pistol_heavy_02_F"];
_itemsCiv           = ["ItemWatch","bde_compass","bde_map","Binocular","FirstAidKit","Medikit"];
_equipmentCiv       = ["V_PlateCarrier1_rgr","V_PlateCarrier2_rgr","V_PlateCarrier3_rgr","V_PlateCarrierGL_rgr","V_PlateCarrier1_blk","V_PlateCarrierSpec_rgr","V_Chestrig_khk","V_Chestrig_rgr","V_Chestrig_blk","V_Chestrig_oli","V_TacVest_khk","V_TacVest_brn","V_TacVest_oli","V_TacVest_blk","V_TacVest_camo","V_TacVest_blk_POLICE","V_TacVestIR_blk","V_TacVestCamo_khk","V_HarnessO_brn","V_HarnessOGL_brn","V_HarnessO_gry","V_HarnessOGL_gry","V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl","V_PlateCarrierIAGL_dgtl","V_RebreatherB","V_RebreatherIR","V_RebreatherIA","V_PlateCarrier_Kerry","V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG","V_I_G_resistanceLeader_F","V_Press_F","H_HelmetB","H_HelmetB_camo","H_HelmetB_paint","H_HelmetB_light","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_indp","H_Booniehat_mcamo","H_Booniehat_grn","H_Booniehat_tan","H_Booniehat_dirty","H_Booniehat_dgtl","H_Booniehat_khk_hs","H_HelmetB_plain_mcamo","H_HelmetB_plain_blk","H_HelmetSpecB","H_HelmetSpecB_paint1","H_HelmetSpecB_paint2","H_HelmetSpecB_blk","H_HelmetIA","H_HelmetIA_net","H_HelmetIA_camo","H_Helmet_Kerry","H_HelmetB_grass","H_HelmetB_snakeskin","H_HelmetB_desert","H_HelmetB_black","H_HelmetB_sand","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_headphones","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_brn_SPECOPS","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_Raven","H_Cap_blk_ION","H_Cap_oli_hs","H_Cap_press","H_Cap_usblack","H_Cap_surfer","H_Cap_police","H_HelmetCrew_B","H_HelmetCrew_O","H_HelmetCrew_I","H_PilotHelmetFighter_B","H_PilotHelmetFighter_O","H_PilotHelmetFighter_I","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O","H_PilotHelmetHeli_I","H_CrewHelmetHeli_B","H_CrewHelmetHeli_O","H_CrewHelmetHeli_I","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_MilCap_ocamo","H_MilCap_mcamo","H_MilCap_oucamo","H_MilCap_rucamo","H_MilCap_gry","H_MilCap_dgtl","H_MilCap_blue","H_HelmetB_light_grass","H_HelmetB_light_snakeskin","H_HelmetB_light_desert","H_HelmetB_light_black","H_HelmetB_light_sand","H_BandMask_blk","H_BandMask_khk","H_BandMask_reaper","H_BandMask_demon","H_HelmetO_oucamo","H_HelmetLeaderO_oucamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_khk_hs","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Shemag_khk","H_Shemag_tan","H_Shemag_olive","H_Shemag_olive_hs","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Beret_blk","H_Beret_blk_POLICE","H_Beret_red","H_Beret_grn","H_Beret_grn_SF","H_Beret_brn_SF","H_Beret_ocamo","H_Beret_02","H_Beret_Colonel","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_Watchcap_sgg","H_TurbanO_blk","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_RacingHelmet_1_F","H_RacingHelmet_2_F","H_RacingHelmet_3_F","H_RacingHelmet_4_F","H_RacingHelmet_1_black_F","H_RacingHelmet_1_blue_F","H_RacingHelmet_1_green_F","H_RacingHelmet_1_red_F","H_RacingHelmet_1_white_F","H_RacingHelmet_1_yellow_F","H_RacingHelmet_1_orange_F","H_Cap_marshal","U_B_FullGhillie_lsh","U_B_FullGhillie_sard","U_B_FullGhillie_ard","U_O_FullGhillie_lsh","U_O_FullGhillie_sard","U_O_FullGhillie_ard","U_I_FullGhillie_lsh","U_I_FullGhillie_sard","U_I_FullGhillie_ard","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierIAGL_oli","U_C_Commoner1_1","U_C_Commoner1_2","U_C_Commoner1_3","U_C_Commoner2_1","U_C_Commoner2_2","	U_C_Commoner2_3","U_C_Commoner_shorts","U_C_Farmer","U_C_Fisherman","U_C_FishermanOveralls","U_C_HunterBody_brn","U_C_HunterBody_grn","U_C_Novak","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poor_1","U_C_Poor_2","U_C_Poor_shorts_1","U_C_Poor_shorts_2","U_C_PriestBody","U_C_Scavenger_1","U_C_Scavenger_2","U_C_ShirtSurfer_shorts","U_C_TeeSurfer_shorts_1","U_C_TeeSurfer_shorts_2","U_C_WorkerCoveralls","U_C_WorkerOveralls","U_Competitor","U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_IG_leader","U_IG_Menelaos","U_KerryBody","U_MillerBody","U_NikosBody","U_OI_Scientist","U_OrestesBody","Rangemaster_Suit"];

_weaponsList        = _weaponRiflesMil + _weaponPistolsMil + _weaponRiflesCiv + _weaponPistolsCiv;
_weaponsList        = _weaponsList call BIS_fnc_arrayShuffle;

_backpacksList      = _itemBackpacksMil + _itemBackpacksCiv;
_backpacksList      = _backpacksList call BIS_fnc_arrayShuffle;

_itemsList          = _itemsMil + _itemsCiv;
_itemsList          = _itemsList call BIS_fnc_arrayShuffle;

_equipmentList      = _equipmentMil + _equipmentCiv;
_equipmentList      = _equipmentList call BIS_fnc_arrayShuffle;

_minCamps = 4; // from 0 to 3 // 4 times
if(count _campLocatsRdm < 4) then {
	_minCamps = count _campLocatsRdm;
};

for "_a" from 0 to _minCamps step 1 do {
	_campSelf          = _campLocatsRdm select _a;
	_campCenter        = (_campSelf select 0) findEmptyPosition [0, 100, "Land_House_Big_01_V1_ruins_F"];

	_tent              = createVehicle [selectRandom _tents,_campCenter,[],0,""];
	_garbage           = createVehicle [selectRandom _garbageTypes,_campCenter,[],0,"CAN_COLLIDE"];

	// Add Items to Tent
    for "_i" from 0 to round(random 3) step 1 do {
        // Weapon
        _rdmWeapon      = selectRandom _weaponsList;
        _rdmWeaponMags  = getArray(configfile >> "cfgWeapons" >> _rdmWeapon >> "magazines");
        _tent addWeaponCargoGlobal [_rdmWeapon,1];
        _tent addMagazineCargoGlobal [selectRandom _rdmWeaponMags, round(random 2)+1];
        // Backpack
        _tent addBackpackCargoGlobal [selectRandom _backpacksList,1];
        // Items
        _tent addItemCargoGlobal [selectRandom _itemsList, round(random 1)+1];
        // Equipment
        _tent addItemCargoGlobal [selectRandom _equipmentList,round(random 1)+1];
    };

    // Add Fireplace
	_fireplacePos  = [(_campCenter select 0)+6+(random 2),(_campCenter select 1)+6+(random 2)];
	_fireplace     = createVehicle [selectRandom _fireplaces,_fireplacePos,[],0,""];
	_tent setPos _fireplacePos;

	_markerstr  = createMarker ["camp" + str _a, _campCenter];
	_markerstr setMarkerShape "ICON";
	_markerstr setMarkerType "hd_dot";
    _markerstr setMarkerColor "ColorBrown";

    _addedDeadHumans    = 0;
    _maxRdmDeadHumans   = floor(random 6) + 1;
	for "_i" from 1 to 8 step 1 do {
	    _stuffPos = _fireplacePos;
	    switch(_i)do{
            case 1: {
                _stuffPos = [(_fireplacePos select 0)+(random 1),(_fireplacePos select 1)-4+(random 1)];
            };
            case 2: {
                _stuffPos = [(_fireplacePos select 0)+3+(random 1),(_fireplacePos select 1)-3+(random 1)];
            };
            case 3: {
                _stuffPos = [(_fireplacePos select 0)+4+(random 1),(_fireplacePos select 1)+(random 1)];
            };
            case 4: {
                _stuffPos = [(_fireplacePos select 0)+3+(random 1),(_fireplacePos select 1)+3+(random 1)];
            };
            case 5: {
                _stuffPos = [(_fireplacePos select 0)+(random 1),(_fireplacePos select 1)+4+(random 1)];
            };
            case 6: {
                _stuffPos = [(_fireplacePos select 0)-3+(random 1),(_fireplacePos select 1)+3+(random 1)];
            };
            case 7: {
                _stuffPos = [(_fireplacePos select 0)-4+(random 1),(_fireplacePos select 1)+(random 1)];
            };
            case 8: {
                _stuffPos = [(_fireplacePos select 0)-3+(random 1),(_fireplacePos select 1)-3+(random 1)];
            };
    	    default{};
    	};
		_stuff = createVehicle [selectRandom _campstuff,_stuffPos,[],0,""];
        _stuff setDir (random 40);
		//_tent setPos _stuffPos;

        if((1 + floor(random 8)) == _i && _addedDeadHumans < _maxRdmDeadHumans)then{
            _deadType = selectRandom  ["Land_HumanSkeleton_F","Land_HumanSkull_F"];
            _deadType createVehicle (_stuffPos findEmptyPosition [0, 100, _deadType]);
            _addedDeadHumans = _addedDeadHumans + 1;
        };

        // Add Items on Camp Ground
        _loot = createVehicle ["GroundWeaponHolder",[((_stuffPos select 0)-1)+random 1,((_stuffPos select 1)-1)+random 1],[],0,""];
        for "_l" from 1 to (1+round(random 3)) step 1 do {
            _loot addMagazineCargoGlobal[selectRandom _foodItems,1];
        };
	};
};
