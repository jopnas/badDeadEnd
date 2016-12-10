// Fetch available Weapons https://configs.arma3.ru/

private["_hardestHitPossible","_ammo","_cal","_hitVal"];
lightWeapons    = [];
mediumWeapons   = [];
heavyWeapons    = [];

attachments     = [];

_allWeaponTypes = ["AssaultRifle","Handgun","MachineGun","Shotgun","Rifle","SubmachineGun","SniperRifle","Melee"];
// AssaultRifle,BombLauncher,Cannon,GrenadeLauncher,Handgun,Launcher,MachineGun,Magazine,MissileLauncher,Mortar,RocketLauncher,Shotgun,Throw,Rifle,SubmachineGun,SniperRifle
//Full List: https://community.bistudio.com/wiki/BIS_fnc_itemType -> section Weapon
_allBannedWeapons=[];  //add banned weapons, make shure to use the base version of the weapon
_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
    if(getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2)then{
        _itemType = _x call bis_fnc_itemType;
        _itemAuthor = getText (configFile >> "CfgWeapons" >> _x >> "author");

        if (((_itemType select 0) == "Weapon") && ((_itemType select 1) in _allWeaponTypes) /*&&  _itemAuthor == "Bohemia Interactive"*/) then {
            _baseName = _x	call BIS_fnc_baseWeapon;

            if (!(_baseName in lightWeapons) && !(_baseName in mediumWeapons) && !(_baseName in heavyWeapons) && !(_baseName in _allBannedWeapons)) then {
                // Get Attachments List
                _compatibles = [];
                _compatibles append (getArray (configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems"));
                _compatibles append (getArray (configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems"));
                _compatibles append (getArray (configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems"));
                _compatibles append (getArray (configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems"));
                {
                    attachments pushBackUnique _x;
                } forEach _compatibles;

                // Get Magazines List
                _hardestHitPossible = 0;
                _weaponMagazines    = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
                {
                    _ammo       = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
                    _cal        = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");
                    _hitVal     = getNumber (configFile >> "cfgAmmo" >> _ammo >> "hit");
                    if(_hitVal > _hardestHitPossible)then{
                        _hardestHitPossible = _hitVal;
                    };
                }forEach _weaponMagazines;

                // Sort Weapon to Array
                if(_cal < 1 /*_hardestHitPossible < 10*/)then {
                    lightWeapons pushBack _x;
                };
                if(_cal >= 1 && _cal < 2/*_hardestHitPossible >= 10 && _hardestHitPossible < 15*/)then {
                    mediumWeapons pushBack _x;
                };
                if(_cal >= 2/*_hardestHitPossible >= 15*/)then {
                    heavyWeapons pushBack _x;
                };
            };
        };
    };

} forEach _wpList;