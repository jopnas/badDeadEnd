params["_cursorObject"/**/,"_doors"];
_selectionNames = selectionNames _cursorObject;
if(str _selectionNames find "door_" < 0)exitwith{false};
_doors = [];
{
  if(_x find "door_" && !(_x find "door_handle") )then{
    _doors pushback _x
  };
}foreach _selectionNames;
