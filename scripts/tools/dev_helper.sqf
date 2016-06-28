// TODO: helper functions like "spawn some zombies"
if(!isServer)then{
    player addEventHandler ["MapSingleClick",{
        _units  = _this select 0; // Array - leader selected units, same as groupSelectedUnits (same as _units param)
        _pos    = _this select 1; // Array - world Position3D of the click in format [x,y,0] (same as _pos param)
        _alt    = _this select 2; // Boolean - true if Alt key was pressed (same as _alt param)
        _shift  = _this select 3; // Boolean - true if Shift key was pressed (same as _shift param)
        if(_alt)then{
            player setPosATL _pos;
        };
    }];
};
