milBuildings = [];
_patchesList = (configFile >> "CfgPatches") call BIS_fnc_getCfgSubClasses;
{
    if(getText (configFile >> "CfgPatches" >> _x >> "addonRootClass") == "A3_Structures_F_Mil")then{
        private["_classnames"];
        _classnames = getArray (configFile >> "CfgPatches" >> _x >> "units");
        milBuildings append _classnames;
    };
} forEach _patchesList;