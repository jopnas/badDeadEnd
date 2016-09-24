handgrenades = [];
chemlights = [];
smokeshells = [];
_throwablesList = (configFile >> "CfgWeapons" >> "Throw") call BIS_fnc_getCfgSubClasses;
{
    _magazinesArray = getArray (configFile >> "CfgWeapons" >> "Throw" >> _x >> "magazines");
    if( count _magazinesArray > 0 )then{

        {
            _nameSound = getText (configFile >> "CfgMagazines" >> _x >> "nameSound");
            if( _nameSound == "Chemlight")then{
                chemlights pushBackUnique _x;
            };
            if( _nameSound == "handgrenade")then{
                handgrenades pushBackUnique _x;
            };
            if( _nameSound == "smokeshell")then{
                smokeshells pushBackUnique _x;
            };
        } forEach _magazinesArray;

    };
} forEach _throwablesList;

