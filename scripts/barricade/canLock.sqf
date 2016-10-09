params["_building"/**/,"_closestDoorDist","_closestDoor","_doorCount"];

_closestDoorDist = -1;
_closestDoor = "";
_doorCount = getNumber (configFile >> "cfgVehicles" >> (typeOf _building) >> "numberOfDoors");
_closeEnough = false;

for "_i" from 1 to _doorCount do {
    //systemchat format["%1, %2",_doorCount,_i];
    if((_building selectionPosition format["Door_%1_trigger",_i]) distance (_building worldToModel getPosATL player) < _closestDoorDist || _closestDoorDist < 0)then{
        _closestDoorDist = (_building selectionPosition format["Door_%1_trigger",_i]) distance (_building worldToModel getPosATL player);
        _closestDoor = format["door_%1",_i];
    };
};

if(_closestDoorDist < 2)then{
    _closeEnough = true;
};

[_closestDoor,_closeEnough]
