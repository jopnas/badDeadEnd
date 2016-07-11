/*
airportBuildings    = ["Land_Hangar_F","Land_TentHangar_V1_dam_F","Land_TentHangar_V1_F","Land_Cargo_Tower_V3_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No4_F","Land_MilOffices_V1_F""Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_F"];
militaryBuildings   = ["Land_Cargo_Patrol_V3_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V1_F","Land_Cargo_HQ_V3_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V1_F","Land_Cargo_building_V3_F","Land_Cargo_building_V2_F","Land_Cargo_building_V1_F","Land_i_Barracks_V1_F","Land_i_Barracks_V1_dam_F","Land_i_Barracks_V2_F","Land_i_Barracks_V2_dam_F","Land_u_Barracks_V2_F","Land_Bunker_F","Land_BagBunker_Large_F","Land_BagBunker_Small_F","Land_BagBunker_Tower_F"];
researchBuildings   = ["Land_Hospital_main_F","Land_Hospital_side1_F","Land_Hospital_side2_F","Land_Research_HQ_F","Land_Research_house_V1_F","Land_Dome_Small_F","Land_Dome_Big_F","Land_Medevac_building_V1_F","Land_Medevac_HQ_V1_F"];
constructBuildings  = ["Land_u_Shed_Ind_F","Land_Unfinished_Building_02_F","Land_WIP_F","Land_Unfinished_Building_01_F"];
*/

/*  https://configs.arma3.ru/
    vehicleClass:
        Structures_Commercial (z.B. Land_Dome_Small_F)
        Structures_Cultural
        Structures_Industrial
        Structures_Infrastructure (z.B. Hospitals)
        Structures_Military
        Structures_Town
        Structures_Transport
        Structures_Village
        Structures_Walls
        Structures_Fences
        Structures_Slums
        Structures_Airport
        Structures_Sports
        Ruins

    editorSubcategory:
        EdSubcat_Military
        EdSubcat_Airports
        EdSubcat_Services (z.B. Hospitals)
        EdCat_Ruins
        EdSubcat_Residential_City
*/

airportBuildings   = [];
militaryBuildings  = [];
researchBuildings  = [];
constructBuildings = [];
buildingsListReady = false;

_vecList = (configFile >> "cfgVehicles") call BIS_fnc_getCfgSubClasses;
{
    if(getnumber (configFile >> "cfgVehicles" >> _x >> "scope") == 2)then{
        _vehicleClass       = getText (configFile >> "cfgVehicles" >> _x >> "vehicleClass");
        _displayName        = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
        _editorSubcategory  = getText (configFile >> "cfgVehicles" >> _x >> "editorSubcategory");
        if(_vehicleClass != "Ruins" && _editorSubcategory != "EdCat_Ruins" && _displayName find "Unfinished" < 0)then{
            if(_vehicleClass == "Structures_Military")then{
                militaryBuildings pushBackUnique _x;
            };
            if(_vehicleClass == "Structures_Sports")then{
                airportBuildings pushBackUnique _x;
            };
            if(_vehicleClass == "Structures_Infrastructure")then{
                researchBuildings pushBackUnique _x;
            };
        }else{
            if(_displayName find "Unfinished" > -1 && _vehicleClass != "Ruins" && _editorSubcategory != "EdCat_Ruins")then{
                constructBuildings pushBackUnique _x;
            };
        };
    };
    if(count _vecList == (_forEachIndex + 1))then{
        buildingsListReady = true;
    };
} forEach _vecList;
