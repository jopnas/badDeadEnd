airportBuildings    = ["Land_Hangar_F","Land_TentHangar_V1_dam_F","Land_TentHangar_V1_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No4_F","Land_MilOffices_V1_F""Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_F"];
militaryBuildings   = ["Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V1_F","Land_Cargo_HQ_V3_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V1_F","Land_Cargo_building_V3_F","Land_Cargo_building_V2_F","Land_Cargo_building_V1_F","Land_i_Barracks_V1_F","Land_i_Barracks_V1_dam_F","Land_i_Barracks_V2_F","Land_i_Barracks_V2_dam_F","Land_u_Barracks_V2_F","Land_Bunker_F","Land_BagBunker_Large_F","Land_BagBunker_Small_F","Land_BagBunker_Tower_F"];
researchBuildings   = ["Land_Hospital_main_F","Land_Hospital_side1_F","Land_Hospital_side2_F","Land_Research_HQ_F","Land_Research_house_V1_F","Land_Dome_Small_F","Land_Dome_Big_F","Land_Medevac_building_V1_F","Land_Medevac_HQ_V1_F"];
constructBuildings  = ["Land_u_Shed_Ind_F","Land_Unfinished_Building_02_F","Land_WIP_F","Land_Unfinished_Building_01_F"];

airportBuildings2   = [];
militaryBuildings2  = [];
researchBuildings2  = [];
constructBuildings2 = [];

/*
    vehicleClass:
        Structures_Town
        Structures_Military
        Structures_Transport
        Structures_Infrastructure (z.B. Hospitals)
        Structures_Commercial (z.B. Land_Dome_Small_F)
        Ruins

    editorSubcategory:
        EdSubcat_Military
        EdSubcat_Airports
        EdSubcat_Services (z.B. Hospitals)
        EdCat_Ruins
        EdSubcat_Residential_City
*/

_vecList = (configFile >> "cfgVehicles") call BIS_fnc_getCfgSubClasses;
{
    if(getnumber (configFile >> "cfgVehicles" >> _x >> "scope") == 2)then{
        _displayName        = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
        _vehicleClass       = getText (configFile >> "cfgVehicles" >> _x >> "vehicleClass");
        _editorSubcategory  = getText (configFile >> "cfgVehicles" >> _x >> "editorSubcategory");

        if(_vehicleClass != "Ruins" && _editorSubcategory != "EdCat_Ruins" && _displayName find "Unfinished" < 0)then{
            if(_vehicleClass == "Structures_Military")then{
                militaryBuildings2 pushBackUnique _x;
            };
            if(_editorSubcategory == "EdSubcat_Airports")then{
                airportBuildings2 pushBackUnique _x;
            };
            if(_editorSubcategory == "Structures_Infrastructure")then{
                researchBuildings2 pushBackUnique _x;
            };
        }else{
            if(_displayName find "Unfinished" > -1 && _vehicleClass != "Ruins" && _editorSubcategory != "EdCat_Ruins")then{
                constructBuildings2 pushBackUnique _x;
            };
        };
    };
} forEach _vecList;
