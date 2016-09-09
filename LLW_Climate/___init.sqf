[] call compile preprocessFile "fnc\loadFunctions.sqf";



/* ================================================================================================================ */


X=true;
while {X} do
{
	sleep 0.01;
	
	hintsilent (
			"\n\n\n\n" + ([] call llw_fnc_getDateTime)
			+ "\nSunrise hour: " + str ([] call llw_fnc_getSunrise select 0)
			+ "\nSunset hour: " + str ([] call llw_fnc_getSunrise select 1)
			+ "\nSolar azimuth: " + str ([] call llw_fnc_getSunAngle select 1)+"°"
			+ "\nSolar elevation: " + str ([] call llw_fnc_getSunAngle select 0)+"°"
			+ "\nElevation at noon: " + str ([] call llw_fnc_getSunElevationNoon)+"°"
			+ "\nSolar radiation: " + str ([player] call llw_fnc_getSunRadiation) + " W/m²"
			+ "\nAir: " + str ([] call llw_fnc_getTemperature select 0) +"°C"
			+ "\nSea: " + str ([] call llw_fnc_getTemperature select 1) +"°C"
			+ "\nPlayer in shadow: " + str ([player] call llw_fnc_inShadow)
			+ "\n\nTry fiddling with time, date, overcast, and fog."
		);

};
