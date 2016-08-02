params["_dog","_dogData"];

_id         = _dogData select 0;
_type       = _dogData select 1;
_pos        = _dogData select 2;
_bestFriend = _dogData select 3;

_dog enableFatigue false;
_dog addRating -10000;

_dog disableConversation true;
enableSentences false;

//systemchat format["give dog behaviour to %1 (ID: %2)",typeOf _dog, _id];

_dog setVariable["dogID", _id,false];
_dog setVariable["bestFriend", _bestFriend,false];

/*_markerstr = createMarker [format["dog %1",_id], getPos _dog];
_markerstr setMarkerType "c_unknown";
_markerstr setMarkerColor "ColorPink";
_markerstr setMarkerText _type;*/

[_dog] call bde_fnc_saveDog;

[_dog,_id] spawn {
    params["_dog","_dogID"];
    while{alive _dog}do{
        //systemChat format["while dog %1 behaviour",_dogID];
        (format["dog %1",_dogID]) setMarkerPos (getPos _dog);
        sleep 1;
    };
};
