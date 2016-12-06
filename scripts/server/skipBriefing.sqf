if (hasInterface) then {
    if (!isNumber (missionConfigFile >> "briefing")) exitWith {};
    if (getNumber (missionConfigFile >> "briefing") == 1) exitWith {};
    0 = [] spawn {
        private ["_d"];
        _d = (getNumber (configfile >> "RscDisplayServerGetReady" >> "idd"));
        waitUntil{
            if (getClientState == "BRIEFING READ") exitWith {true};
            if (!isNull findDisplay _d) exitWith {
                ctrlActivate (findDisplay _d displayCtrl 1);
                findDisplay _d closeDisplay 1;
                true
            };
            false
       };
    };
};