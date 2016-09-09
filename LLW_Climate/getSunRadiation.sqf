/*
	Author: Willem-Matthijs Crielaard, 1-2-2016

	Description:
	Script to estimate solar radiation energy per m² on an object or position.
	
		Based on http://www.wrds.uwyo.edu/sco/climateatlas/solar.html
		and https://en.wikipedia.org/wiki/Solar_energy
		and http://rredc.nrel.gov/solar/pubs/bluebook/interp.html
		and https://en.wikipedia.org/wiki/Albedo

	Parameter(s):
		0: OBJECT - Object
	
		When [OBJECT] is used as a parameter, the "body" selection is used as the point of reference

	Or:
		PositionASL
	
	Returns:
	NUMBER - Solar radiation energy in Watts per square meter (W/m²).

	Example:
	[player] call llw_fnc_getSunRadiation
	
	Alternative syntax:
	getPosASL mycar call llw_fnc_getSunRadiation
*/

// solar radiation energy for 90 degrees solar elevation angle, in Watts per square meter (W/m²)
#define MAXSOLARRADIATION	340
// current solar radiation energy in Watts per square meter (W/m²)
#define	SOLARRADIATION		((1+SIN(_sunangle select 0)-COS((_sunangle select 0)*2))*(MAXSOLARRADIATION/3))
// fraction of energy reduction that a maximum cloud cover at 10,000ft incurs
#define CLOUDABSORPTION		0.7
// fraction of energy reduction that maximum density fog incurs
#define FOGABSORPTION		0.8
// fraction of radiation energy reflected into shadows
#define GROUNDALBEDO		0.15
// distance to check for occlusion by objects
#define CHECKDISTANCE		100
// distance to check for occlusion by terrain
#define CHECKTERRAINDIST	1000
// distance to check for occlusion by clouds
#define CHECKCLOUDDIST		3000


/* =======================
		INITIALIZE
======================= */
private ["_sunangle","_checkPos","_object","_sunVector"];

_sunangle = [] call llw_fnc_getSunAngle;
_checkPos = [0,0,0];
_object = objNull;
_return = 0;

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


POS_A = _checkPos;
POS_B = _sunVector vectorMultiply (CHECKDISTANCE) vectorAdd _checkPos;

	
/* =======================
		MAIN
======================= */
if (sunOrMoon>=1) then
{
	// reduction of solar radiation caused by cloud occlusion
	_return = SOLARRADIATION 	* ([1,GROUNDALBEDO] select (
															(count lineIntersectsObjs [ _checkPos, _sunVector vectorMultiply (CHECKDISTANCE) vectorAdd _checkPos, _object, objNull, false, 32] >0)
															or terrainIntersectASL [_checkPos, _sunVector vectorMultiply (CHECKTERRAINDIST) vectorAdd _checkPos ]
															)
									)
								* ((1 - simulCloudOcclusion [_checkPos, _sunVector vectorMultiply (CHECKCLOUDDIST) vectorAdd _checkPos]*CLOUDABSORPTION) min (1 - fog*FOGABSORPTION));
};

_return
