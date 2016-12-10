private["_exclude"];
backpacks = [];
_exclude = ["Bag_Base","B_Parachute"];
_vehicleList = (configFile >> "CfgVehicles") call BIS_fnc_getCfgSubClasses;
{
    //private["_itemType"];
    //_itemType = _x call bis_fnc_itemType;
    _countTransportMagazines = count((configFile >> 'CfgVehicles' >> _x >> 'TransportMagazines') call BIS_fnc_getCfgSubClasses);
    _countTransportWeapons = count((configFile >> 'CfgVehicles' >> _x >> 'TransportWeapons') call BIS_fnc_getCfgSubClasses);
    _countTransportItems = count((configFile >> 'CfgVehicles' >> _x >> 'TransportItems') call BIS_fnc_getCfgSubClasses);

    _countTransport = _countTransportMagazines + _countTransportWeapons + _countTransportItems;

    if( !(_x in _exclude) && _countTransport == 0 && getNumber (configFile >> 'CfgVehicles' >> _x >> 'maximumLoad') > 0 && getNumber (configFile >> 'CfgVehicles' >> _x >> 'isbackpack') == 1 && getNumber (configFile >> 'CfgVehicles' >> _x >> 'scope') > 0)then{
        backpacks pushBackUnique _x;
    };
} forEach _vehicleList;