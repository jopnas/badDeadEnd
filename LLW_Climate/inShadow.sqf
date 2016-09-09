/*
	Author: Willem-Matthijs Crielaard, 1-2-2016

	Description:
	Script to check if a soldier or position is shielded from the sun.
	
	Parameter(s):
		0: OBJECT - Soldier
		
		When [OBJECT] is used as a parameter, the "body" selection is used as the point of reference
	
	Or:
		PositionASL
	
	Returns:
	BOOL - True is the soldier is shielded from the sun, otherwise false.

	Example:
	[player] call llw_fnc_inShadow
	
	Alternative syntax:
	getPosASL bacon call llw_fnc_inShadow
*/

// distance to check for occlusion by objects
#define CHECKDISTANCE		100
// distance to check for occlusion by terrain
#define CHECKTERRAINDIST	1000



/* =======================
		INITIALIZE
======================= */
private [	"_sunangle","_checkPos","_object","_sunVector"];

_sunangle = [] call llw_fnc_getSunAngle;
_checkPos = [0,0,0];
_object = objNull;

if (typeName (_this select 0)== "Object") then
{
	_checkPos = [ (getPosASL (_this select 0) select 0),(getPosASL (_this select 0) select 1),(getPosASL (_this select 0) select 2)+((_this select 0) selectionPosition "body" select 2)];
	_object = (_this select 0);
} else {
	_checkPos = _this;
	_object = objNull;
};

if (abs (_sunangle select 0) == 90) then
{
	_sunVector = [0,0,CHECKDISTANCE];
} else {
	// _sunVector = vectorNormalized [sin(_sunangle select 1),cos(_sunangle select 1),tan(_sunangle select 0)] vectorMultiply (CHECKDISTANCE) vectorAdd _checkPos;
	_sunVector = vectorNormalized [sin(_sunangle select 1),cos(_sunangle select 1),tan(_sunangle select 0)];
};


/* =======================
		MAIN
======================= */
_return = true;
if (sunOrMoon>=1) then
{
	// The command "lineIntersectsObjs" is used, because "lineIntersects" seems to be unreliable.
	_return = (count lineIntersectsObjs [ _checkPos, _sunVector vectorMultiply (CHECKDISTANCE) vectorAdd _checkPos, _object, objNull, false, 32] >0)
				or terrainIntersectASL [_checkPos, _sunVector vectorMultiply (CHECKTERRAINDIST) vectorAdd _checkPos ];
};

_return
