backpacks = "(
    (getNumber (_x >> 'isbackpack') == 1) &&
    (getNumber (_x >> 'scope') > 0)
)" configClasses (configFile >> "CfgVehicles");
