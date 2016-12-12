if(!isDedicated)then{
    playerReady = false;
    //startLoadingScreen ["prepare to survive ...", "bde_loadingScreen"];
    //progressLoadingScreen 0;
    [] execVM "LLW_Climate\loadFunctions.sqf";
    [] execVM "scripts\tools\globalFuncs.sqf";
    [] execVM "scripts\tools\burnObject.sqf";
    //progressLoadingScreen 0.2;
    [] execVM "scripts\player\playerGlobalFuncs.sqf";
    //progressLoadingScreen 0.4;
    [] execVM "scripts\player\playerGlobalVars.sqf";
    //progressLoadingScreen 0.6;
    //progressLoadingScreen 0.8;
    waitUntil { playerReady };
    systemChat format["playerReady %1",playerReady];
    //progressLoadingScreen 1;
    //endLoadingScreen;
};

