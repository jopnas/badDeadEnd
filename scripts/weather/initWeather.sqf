nextChangeWeather   = 0;
minChangeRate       = 600;

curChangeTime = round(random 1800)+minChangeRate;
nextChangeWeather = nextChangeWeather + curChangeTime;

while{true}do{
    private["_acidRain"];
	if(time > nextChangeWeather)then{
        if(random 100 < 50)then{
            {acidRainPossible = true;} remoteExecCall ["bis_fnc_call", 0];
        }else{
            {acidRainPossible = false;} remoteExecCall ["bis_fnc_call", 0]; 
        };

		//skipTime -24;
		curChangeTime setOvercast random 1;
		//skipTime 24;
		0 = [] spawn {
			simulWeatherSync;
			sleep 0.1;
		};
		curChangeTime = (round(random 1800))+minChangeRate;
		nextChangeWeather = nextChangeWeather + curChangeTime;
	};

};
