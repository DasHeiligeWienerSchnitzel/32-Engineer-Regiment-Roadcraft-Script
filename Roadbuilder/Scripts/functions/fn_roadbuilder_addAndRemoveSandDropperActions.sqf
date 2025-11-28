params ["_vehicle"];

[_vehicle, 1, ["ACE_SelfActions","ER32_roadbuilder_sandDropper_loopActive"]] call ace_interact_menu_fnc_removeActionFromObject;
[_vehicle, 1, ["ACE_SelfActions"], ER32_roadbuilder_sandDropper_loopDeactive] call ace_interact_menu_fnc_addActionToObject;