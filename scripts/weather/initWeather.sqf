nextChangeWeather   = 0;
minChangeRate       = 600;

curChangeTime = floor(random 1800) + minChangeRate;
nextChangeWeather = nextChangeWeather + curChangeTime;

acidRain = false;

while{true}do{
	if(time > nextChangeWeather)then{
        _rdmOvercast = random 1;

        if(random 100 < 50 && _rdmOvercast > 0.6)then{
            {acidRain = true;} remoteExecCall ["bis_fnc_call", 0];
        }else{
            {acidRain = false;} remoteExecCall ["bis_fnc_call", 0];
        };

		curChangeTime setOvercast _rdmOvercast;

        0 = [] spawn {
        	sleep 0.1;
        	simulWeatherSync;
        };
		curChangeTime = floor(random 1800) + minChangeRate;
		nextChangeWeather = nextChangeWeather + curChangeTime;
	};
};
