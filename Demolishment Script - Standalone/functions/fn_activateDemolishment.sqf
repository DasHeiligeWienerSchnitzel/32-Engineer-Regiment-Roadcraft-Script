params ["_object"];

//Sets and gets the Demolishment_State. Aka checks if demolishment is on or off.

_demolishment = true;
_object setVariable ["ER32_Demolishment_State", _demolishment, true];


/*
Aslong as demolishment is on, it will continuously destroy terrainObjects infront of the bulldozer.
*/

while {_demolishment == true} do {

	//Gets the relativ forward position of the bulldozer.
	
	_pos = [position _object, 5, getDir _object] call BIS_fnc_relPos;
	
	//Collects all nearbyTerrainObjects that are in a 4 meter radius infront of the bulldozer.
	
	_nearbyTerrainObjects = nearestTerrainObjects [_pos, [], 4, false, true];
	
	//Now gets every object in that array that is in a 2.5 meter cube infront of the bulldozer.
	
	_objectsInZone = _nearbyTerrainObjects inAreaArray [_pos,2.5,2.5,getDir _object,false,5];

	/*
	For each Object in this cube, damage will be implied, destroying the objects in the process.
	After 5 seconds the destroyed object will be deleted.
	*/
	
	{
		[_x] spawn {
			params ["_terrainObject"];
			_terrainObject setDamage 1;
			sleep 5;
			_terrainObject hideObjectGlobal true;
		};
	}forEach _objectsInZone;
	
	sleep 0.01;
	
	//Checks if demolishment is still on.
	
	_demolishment = _object getVariable ["ER32_Demolishment_State", true];
	
};
