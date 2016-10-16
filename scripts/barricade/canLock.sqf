params["_building"/**/,"_closestDoorDist","_closestDoor","_doorCount","_closestDoorNo"];

_closestDoorDist = -1;
_closestDoor = "";
_closestDoorNo = 0;
_doorCount = getNumber (configFile >> "cfgVehicles" >> (typeOf _building) >> "numberOfDoors");
_closeEnough = false;

for "_i" from 1 to _doorCount do {
    _doorTriggerPos = _building selectionPosition format["Door_%1_trigger",_i];
    _relPlayerPos   = _building worldToModel getPosATL player;
    _thisDistance   = _doorTriggerPos distance _relPlayerPos;
    if(_thisDistance < _closestDoorDist || _closestDoorDist < 0)then{
        _closestDoorDist    = _thisDistance;
        _closestDoor        = format["door_%1",_i];
        _closestDoorNo      = _i;
    };
};

if(_closestDoorDist < 2)then{
    _closeEnough = true;
};

[_closestDoor,_closeEnough,_closestDoorDist,_closestDoorNo]
