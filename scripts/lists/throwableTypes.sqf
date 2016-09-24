/*grenades = "(
    (getText (_x >> 'ammo') == 'GrenadeHand')
)" configClasses (configFile >> "CfgMagazines");

chemlights = "(
    (getText (_x >> 'ammo') == 'Chemlight_yellow') ||
    (getText (_x >> 'ammo') == 'Chemlight_green') ||
    (getText (_x >> 'ammo') == 'Chemlight_red') ||
    (getText (_x >> 'ammo') == 'Chemlight_blue')
)" configClasses (configFile >> "CfgMagazines");*/

itemTypes = [];
nameSounds = [];

grenades = [];
chemlights = [];
_magazineList = (configFile >> "CfgMagazines") call BIS_fnc_getCfgSubClasses;
{
    private["_itemType"];
    _itemType = _x call bis_fnc_itemType;
    _nameSound = getText (configFile >> "CfgMagazines" >> _x >> "nameSound");

    if(_nameSound == "handgrenade")then{
        grenades pushBackUnique _x;
    };
    if(_nameSound == "Chemlight")then{
        chemlights pushBackUnique _x;
    };

    itemTypes pushBackUnique _itemType;
    nameSounds pushBackUnique _nameSound;
} forEach _magazineList;

