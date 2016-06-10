bde_fnc_say3d = { // [_sayobject,_audioclip,_maxdistance,_audiopitch] remoteExec ["bde_fnc_say3d",0,false];
    if(!isDedicated)then{
        _sayobject      = _this select 0;
        _audioclip      = _this select 1;
        _maxdistance    = _this select 2;

        _sayobject say3D [_audioclip, _maxdistance, random(2)];
    };
};

// Burn Dead Z
bde_fnc_addBurnAction = {
    _targetObject = _this select 0;
    burnAction = _targetObject addAction [ "Burn dead body", {
        _targetObject = _this select 0;
        _caller = _this select 1;
        if(("jii_zippo" in Magazines _caller || (rain < 0.2 && "jii_matches" in Magazines _caller))/* && "jii_fuelcan" in Magazines _caller*/)then{
            [_targetObject] remoteExec ["bde_fnc_removeBurnAction",0,false];
            [_targetObject] remoteExec ["fnc_burnDeadZ",0,false];
        };
    },[],6,true,true,"","_target distance _this < 4"];
};

bde_fnc_removeBurnAction = {
    _targetObject = _this select 0;
    _targetObject removeAction burnAction;
};

// Fetch available Weapons
bde_fetchWeapons = {
    private["_weapons_heavy","_weapons_medium","_weapons_light","_weaponsArray","_hardestHitPossible"];
    _weaponsArray   = [];
    _weapons_light  = [];
    _weapons_medium = [];
    _weapons_heavy  = [];
    {
        _weapon             = _x;
        _weaponType         = getNumber (configFile >> "CfgWeapons" >> _weapon >> "type");
        _weaponMagazines    = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
        _fromBI             = (getText (configFile >> "CfgWeapons" >> _weapon >> "author") == "Bohemia Interactive");
        if(getNumber (configFile >> "CfgWeapons" >> _weapon >> "scope") == 2 && _fromBI && count _weaponMagazines > 0 && _weaponType == 1 || _weaponType == 2)then{
            _hardestHitPossible = 0;
            {
        	    _ammo      = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
                _hitVal    = getNumber (configFile >> "cfgAmmo" >> _ammo >> "hit");
                if(_hitVal > _hardestHitPossible)then{
                    _hardestHitPossible = _hitVal;
                };
        	}forEach _weaponMagazines;

            if(_hardestHitPossible < 10)then {
                _weapons_light pushBack _weapon;
            }
            if(_hardestHitPossible >= 10 && _hardestHitPossible < 18)then {
                _weapons_medium pushBack _weapon;
            }
            if(_hardestHitPossible >= 18)then {
                _weapons_heavy pushBack _weapon;
            }
        };

    } forEach  ((configFile >> "CfgWeapons") call BIS_fnc_getCfgSubClasses);
    _weaponsArray = [_weapons_light,_weapons_medium,_weapons_heavy];
    _weaponsArray
    // ([] call bde_fetchWeapons) select 0; // Light Damage Weapons;
    // ([] call bde_fetchWeapons) select 1; // Medium Damage Weapons;
    // ([] call bde_fetchWeapons) select 2; // Heavy Damage Weapons;
};

/*
4, 8,
10, 12,14, 16,
18, 20, 24, 60
*/
