// Fetch available Weapons
bde_fetchWeapons = {
    private["_weapons_heavy","_weapons_medium","_weapons_light","_weaponsArray","_hardestHitPossible"];
    _weapons_light  = [];
    _weapons_medium = [];
    _weapons_heavy  = [];
    _weaponsArray   = [];
    _allWeaponTypes = ["AssaultRifle","Handgun","MachineGun","Shotgun","Rifle","SubmachineGun","SniperRifle"];
    // AssaultRifle,BombLauncher,Cannon,GrenadeLauncher,Handgun,Launcher,MachineGun,Magazine,,MissileLauncher,Mortar,RocketLauncher,Shotgun,Throw,Rifle,SubmachineGun,SniperRifle
    //Full List: https://community.bistudio.com/wiki/BIS_fnc_itemType -> section Weapon
    _allBannedWeapons=[];  //add banned weapons, make shure to use the base version of the weapon
    _wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
    {
        if(getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2)then{
            _itemType = _x call bis_fnc_itemType;
            
            if (((_itemType select 0) == "Weapon") && ((_itemType select 1) in _allWeaponTypes)) then {
                _baseName = _x	call BIS_fnc_baseWeapon;
                
                if (!(_baseName in _weapons_light) && !(_baseName in _weapons_medium) && !(_baseName in _weapons_heavy) && !(_baseName in _allBannedWeapons)) then {
                    // Get Magazines List
                    _hardestHitPossible = 0;
                    _weaponMagazines    = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
                    {
                        _ammo       = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
                        _hitVal     = getNumber (configFile >> "cfgAmmo" >> _ammo >> "hit");
                        if(_hitVal > _hardestHitPossible)then{
                            _hardestHitPossible = _hitVal;
                        };
                    }forEach _weaponMagazines;

                    // Sort Weapon to Array
                    if(_hardestHitPossible < 10)then {
                        _weapons_light pushBack _x;
                    };
                    if(_hardestHitPossible >= 10 && _hardestHitPossible < 18)then {
                        _weapons_medium pushBack _x;
                    };
                    if(_hardestHitPossible >= 18)then {
                        _weapons_heavy pushBack _x;
                    };
                };
            };
        };

    } forEach _wpList;
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

_sortedWeaponLists = [] call bde_fetchWeapons;
//["hgun_ACPC2_F","hgun_P07_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","hgun_Rook40_F","arifle_Mk20_F","arifle_Mk20_plain_F","arifle_Mk20C_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_F","arifle_Mk20_GL_plain_F","arifle_SDAR_F","arifle_TRG21_F","arifle_TRG20_F","arifle_TRG21_GL_F","hgun_PDW2000_F","SMG_01_F","SMG_02_F","hgun_Pistol_Signal_F"]
lightWeapons     = _sortedWeaponLists select 0; // Light Damage Weapons;
mediumWeapons    = _sortedWeaponLists select 1; // Medium Damage Weapons;
heavyWeapons     = _sortedWeaponLists select 2; // Heavy Damage Weapons;
