nextChangeWeather   = 0;
minChangeRate       = 600;
curChangeTime       = 86400;

wasRainingBefore    = false;

weatherInit = [] spawn {
	while{true}do{
        private["_acidRain"];
		if(time > nextChangeWeather)then{
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

        if(rain == 0 && wasRainingBefore)then{
            wasRainingBefore = false;
            if(random 100 > 90)then{
                _acidRain = true;
            }else{
                _acidRain = false;
            };
            {player setVariable ["rainIsAcid", _acidRain, false];} remoteExec ["bis_fnc_call",-2];
        };

        if(rain > 0 && !wasRainingBefore)then{
            wasRainingBefore = true;
        };
	};
};
