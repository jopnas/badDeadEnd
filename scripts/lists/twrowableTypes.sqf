grenades = "(
    (getText (_x >> 'ammo') == 'GrenadeHand'
)" configClasses (configFile >> "CfgMagazines");

chemlights = "(
    (getText (_x >> 'ammo') == 'Chemlight_yellow' ||
    (getText (_x >> 'ammo') == 'Chemlight_green' ||
    (getText (_x >> 'ammo') == 'Chemlight_red' ||
    (getText (_x >> 'ammo') == 'Chemlight_blue'
)" configClasses (configFile >> "CfgMagazines");

