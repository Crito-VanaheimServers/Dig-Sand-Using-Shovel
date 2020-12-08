ExileReborn_userActionTimeout = 30;
ExileReborn_userActionTimeout_lastCheck = time;
ExileReborn_userActionArray = [];
ExileReborn_userActions = [];

[] execVM "Client_scriptsAndFunctions\Scripts\JohnO_script_createPlayerActions.sqf";

[2, JohnO_fnc_handlePlayerActions, [], true] call ExileClient_system_thread_addtask;

