/*
	Author: Willem-Matthijs Crielaard, 9-2-2016

	Description:
	Script to calculate solar elevation and azimuth angles at a given time and date
	This script ignores the offset generated by Longitude within a timezone.
	Based on information from:
		http://www.pveducation.org/pvcdrom/properties-of-sunlight/elevation-angle
		https://en.wikipedia.org/wiki/Solar_azimuth_angle
		
	Parameters (optional):
		0: NUMBER - year
		1: NUMBER - month
		2: NUMBER - day
		3: NUMBER - hours
		4: NUMBER - minutes

	Returns:
		ARRAY
			0: NUMBER - solar elevation angle in degrees
			1: NUMBER - solar azimuth angle in degrees
	
	Example:
	date call llw_fnc_getSunAngle

	Alternative to get current solar elevation:
	call llw_fnc_getSunAngle
*/


// ARMA 3 seems to have its equinox off by a few days
#define EQUINOX_ERROR	2
// Equinox - 360 is the number of orbital degrees per year, 365 the number of days per year. 81 accounts for march equinox
#define EQUINOX_MAR		((360 * dateToNumber _date)-(360*(81+EQUINOX_ERROR)/365))


/* =======================
		INITIALIZE
======================= */
private [	"_date","_latitude","_declination","_hra","_return"];

// verify and cleanup input parameters
_date=[];
if (isnil "_this") then
{
	_date = date;
} else {
	if (typeName _this != "ARRAY") then
	{
		_date = date;
	} else {
		if (count _this == 0) then
		{
			_date = date;
		} else {
			_date = _this;
		};
	};
};

// lookup and calculate input variables
_latitude = -1*getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
_declination = (asin (sin 23.45 * sin EQUINOX_MAR));				// current earth tilt irl to the sun in degrees
_hra = (360 * ((_date select 3) + (_date select 4)/60 - 12) / 24);	// solar hour angle in degrees; 360 degrees per 24 hours, times the current hour
_return = [];


/* =======================
		MAIN
======================= */
// calculate solar elevation angle
_return pushBack asin( sin _declination * sin _latitude + cos _declination * cos _latitude * cos _hra );

// calculate solar zentih angle
if ( sin (90-(_return select 0)) != 0) then
{
	if (dayTime <=12) then
	{
		_return pushBack (acos ( ((sin _declination) * (cos _latitude) - (cos _hra) * (cos _declination) * (sin _latitude))/ sin (90-(_return select 0)) ));
	} else {
		_return pushBack (360-acos ( ((sin _declination) * (cos _latitude) - (cos _hra) * (cos _declination) * (sin _latitude))/ sin (90-(_return select 0)) ));
	};
} else {
	_return pushBack 90;
};

_return
