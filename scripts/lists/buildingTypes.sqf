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

militaryBuildings  = [];
airportBuildings   = [];
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
