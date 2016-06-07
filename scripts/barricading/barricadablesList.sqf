_barricadableArray = [
    ["Land_i_Stone_HouseSmall_V1_F",
        [
            [90,"window",[20,5,20]],
            [270,"window",[20,5,20]],
            [0,"door",[20,5,20]]
        ]
    ],
    ["Land_CarService_F",
        [
            [0,"window",[20,5,20]],
            [900,"gate",[20,5,20]],
            [0,"door",[20,5,20]]
        ]
    ]
]

getBarricadePos = {
    private["_typesData"];
    _type = _this select 0;
    {
        if(_type == _x select 0)exitWith{
            _typesData = _x select 1;
        };
    } forEach _barricadableArray;
    _typesData
};
