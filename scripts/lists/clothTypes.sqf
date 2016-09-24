//headgears = "getText (_x >> 'ItemInfo' >> '_generalMacro') == 'HeadgearItem'" configClasses (configFile >> "CfgWeapons");
//vests = "getText (_x >> 'ItemInfo' >> '_generalMacro') == 'VestItem'" configClasses (configFile >> "CfgWeapons");
//uniforms = "getText (_x >> 'ItemInfo' >> 'uniformClass') isEqualType ''" configClasses (configFile >> "CfgWeapons");

headgears = [];
vests = [];
uniforms = [];
_weaponsList = (configFile >> "CfgWeapons") call BIS_fnc_getCfgSubClasses;
{
    private["_itemType"];
    _itemType = _x call bis_fnc_itemType;
    if(getnumber (configFile >> "cfgWeapons" >> _x >> "scope") > 0)then{
        if(_itemType select 1 == "Headgear")then{
            headgears pushBackUnique _x;
        };
        if(_itemType select 1 == "Vest")then{
            vests pushBackUnique _x;
        };
        if(_itemType select 1 == "Uniform" && _x != "U_BasicBody")then{
            uniforms pushBackUnique _x;
        };
    };
} forEach _weaponsList;