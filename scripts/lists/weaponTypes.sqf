// Fetch available Weapons

private["_hardestHitPossible"];
lightWeapons    = [];
mediumWeapons   = [];
heavyWeapons    = [];

weaponCaliber   = [];
weaponHitVal    = [];

_allWeaponTypes = ["AssaultRifle","Handgun","MachineGun","Shotgun","Rifle","SubmachineGun","SniperRifle"];
// AssaultRifle,BombLauncher,Cannon,GrenadeLauncher,Handgun,Launcher,MachineGun,Magazine,MissileLauncher,Mortar,RocketLauncher,Shotgun,Throw,Rifle,SubmachineGun,SniperRifle
//Full List: https://community.bistudio.com/wiki/BIS_fnc_itemType -> section Weapon
_allBannedWeapons=[];  //add banned weapons, make shure to use the base version of the weapon
_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
    if(getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2)then{
        _itemType = _x call bis_fnc_itemType;
        _itemAuthor = getText (configFile >> "CfgWeapons" >> _x >> "author");

        if (((_itemType select 0) == "Weapon") && ((_itemType select 1) in _allWeaponTypes) &&  _itemAuthor == "Bohemia Interactive") then {
            _baseName = _x	call BIS_fnc_baseWeapon;

            if (!(_baseName in lightWeapons) && !(_baseName in mediumWeapons) && !(_baseName in heavyWeapons) && !(_baseName in _allBannedWeapons)) then {
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
                    weaponCaliber pushBackUnique _cal;
                    weaponHitVal pushBackUnique _cal;
                }forEach _weaponMagazines;

                // Sort Weapon to Array
                if(_hardestHitPossible < 10)then {
                    lightWeapons pushBack _x;
                };
                if(_hardestHitPossible >= 10 && _hardestHitPossible < 15)then {
                    mediumWeapons pushBack _x;
                };
                if(_hardestHitPossible >= 15)then {
                    heavyWeapons pushBack _x;
                };
            };
        };
    };

} forEach _wpList;

/* Caliber
0.1,0.4,0.7,1,
1.6,1.8,2,
2.2,2.4,2.8,
3.6,*
4.6,
*/

/* HitDamage
4, 8,
10, 12,14,
16,18, 20, 24, 60
*/
