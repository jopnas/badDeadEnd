nextChangeWeather   = 0;
minChangeRate       = 600;
curChangeTime       = 86400;

rainBefore  = 0;

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

        if(rainBefore > rain)then{
            if(rain == 0)then{
                if(random 100 > 50)then{
                    _acidRain = true;
                }else{
                    _acidRain = false;
                };
                {
                    _x setVariable ["rainIsAcid", _acidRain, true];
                    systemChat str _acidRain;
                }forEach allPlayers;
            };
            rainBefore = rain;
        };
	};
};
