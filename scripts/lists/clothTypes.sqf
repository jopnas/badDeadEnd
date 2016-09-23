headgears = "(
    (getText (_x >> 'ItemInfo' >> '_generalMacro') == 'HeadgearItem'
)" configClasses (configFile >> "CfgWeapons");

vests = "(
    (getText (_x >> 'ItemInfo' >> '_generalMacro') == 'VestItem'
)" configClasses (configFile >> "CfgWeapons");

uniforms = "(
    (getText (_x >> 'ItemInfo' >> 'uniformClass') isEqualType ''
)" configClasses (configFile >> "CfgWeapons");