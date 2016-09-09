/*
	Author: Willem-Matthijs Crielaard, 1-2-2016

	Description:
	Script to calculate solar elevation at noon (12:00AM)
	
		Based on information from http://www.pveducation.org/pvcdrom/properties-of-sunlight/elevation-angle

	Parameter(s):
		0: NUMBER - year
		1: NUMBER - month
		2: NUMBER - day
		3: NUMBER - hours
		4: NUMBER - minutes

	Returns:
	NUMBER - solar elevation angle

	Example:
	date call llw_fnc_getSunElevation

	Alternative to get maximum solar elevation for current in-game date:
	[] call llw_fnc_getSunElevationNoon
*/


// ARMA 3 seems to have its equinox off by a few days
#define EQUINOX_ERROR	2
// Equinox - 360 is the number of orbital degrees per year, 365 the number of days per year. 81 accounts for march equinox
#define EQUINOX_MAR		((360 * dateToNumber _date)-(360*(81+EQUINOX_ERROR)/365))
// current earth tilt irl to the sun in degrees
#define DECLINATION		(asin (sin 23.45 * sin EQUINOX_MAR))


/* =======================
		INITIALIZE
======================= */
private [	"_latitude","_hemisphere","_date"];
_latitude = -1*getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
_hemisphere = 1;	// variable to factor in northern or southern hemisphere seasonal effects
if (_latitude<0) then {_hemisphere=-1};

_date=_this;

if (isnil "_date") then
{
	_date = date;
} else {
	if (typeName _this != "ARRAY") then
	{
		_date = date;
	} else {
		if (count _date == 0) then
		{
			_date = date;
		} else {
			while {count _date < 5} do
			{
				_date pushBack 0;
			}
		};
	};
};


/* =======================
		MAIN
======================= */
(90 - _latitude*_hemisphere + DECLINATION*_hemisphere)