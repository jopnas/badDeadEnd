nextChangeWeather = 0;
minChangeRate = 600;
curChangeTime = 86400;
weatherInit = [] spawn {
	while{true}do{
		if(time > nextChangeWeather)then{
			skipTime -24;
			curChangeTime setOvercast random 1;
			skipTime 24;
			0 = [] spawn {
				simulWeatherSync;
				sleep 0.1;
			};
			curChangeTime = (round(random 1800))+minChangeRate;
			nextChangeWeather = nextChangeWeather + curChangeTime;
		};
	};
};
