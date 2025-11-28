params ["_droppedSand"];

waitUntil {!isNull _droppedSand};
_droppedSand hideObject false;
_droppedSand setObjectScale 0.25;
