/*
	Author: Willem-Matthijs Crielaard, 1-2-2016

	Description:
	Function to return formatted text containing current date and time.

	Parameter(s): none

	Returns:
	TEXT - formatted current date and time as YYYY-MM-DD (HH:MM:SS)

	Example:
	[] call llw_fnc_getSunElevation
*/
(
	str (date select 2)
	+ "-"
	+ str (date select 1)
	+ "-"
	+ str (date select 0)
	+ " ("
	+ str (date select 3)
	+ ":"
	+ str (date select 4)
	+ ":"
	+ str floor(((daytime mod 1)*60 mod 1) * 60)
	+ "h)"
)
