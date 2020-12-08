ExileReborn_hasFillSandBagAction = false;

ExileReborn_filLSandBagAction =
["Fill sandbags",
{
    ExileReborn_hasFillSandBagAction = true;

    _caller = _this select 0;
    _action = _this select 2;
    _caller removeAction _action;

    if (ExileClientActionDelayShown) exitWith { false };
    ExileClientActionDelayShown = true;
    ExileClientActionDelayAbort = false;

    _animation = "Exile_Shovel_Dig01";
    disableSerialization;
    ("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutRsc ["RscExileActionProgress", "PLAIN", 1, false];

    _keyDownHandle = (findDisplay 46) displayAddEventHandler ["KeyDown","_this call ExileClient_action_event_onKeyDown"];
    _mouseButtonDownHandle = (findDisplay 46) displayAddEventHandler ["MouseButtonDown","_this call ExileClient_action_event_onMouseButtonDown"];

    player switchMove _animation;
    ["switchMoveRequest", [netId player, _animation]] call ExileClient_system_network_send;

    _startTime = diag_tickTime;
    _duration = 10;
    _sleepDuration = _duration / 100;
    _progress = 0;

    _display = uiNamespace getVariable "RscExileActionProgress";
    _label = _display displayCtrl 4002;
    _label ctrlSetText "0%";
    _progressBarBackground = _display displayCtrl 4001;
    _progressBarMaxSize = ctrlPosition _progressBarBackground;
    _progressBar = _display displayCtrl 4000;
    _progressBar ctrlSetPosition [_progressBarMaxSize select 0, _progressBarMaxSize select 1, 0, _progressBarMaxSize select 3];
    _progressBar ctrlSetBackgroundColor [0, 0.78, 0.93, 1];
    _progressBar ctrlCommit 0;
    _progressBar ctrlSetPosition _progressBarMaxSize;
    _progressBar ctrlCommit _duration;
    try
    {
        while {_progress < 1} do
        {
            if (ExileClientActionDelayAbort) then
            {
                throw 1;
            };
            uiSleep _sleepDuration;
            _progress = ((diag_tickTime - _startTime) / _duration) min 1;
            _label ctrlSetText format["%1%2", round (_progress * 100), "%"];
        };
        throw 0;
    }
    catch
    {
        _progressBarColor = [];
        switch (_exception) do
        {
            case 0:
            {
                _progressBarColor = [0.7, 0.93, 0, 1];

                _dir = direction player + 10;
                _pos = getPos player;
                _dist = 1;

                _pos = (_pos getPos [_dist, _dir] select [0, 2]) + ([[],[_pos select 2]] select (count _pos > 2));
                _holder = "GroundWeaponHolder" createVehicle _pos;

                [_holder, "Exile_Item_Sand"] call ExileClient_util_containerCargo_add;

                [
                    "InfoTitleAndText",
                    ["Digging", "You have filled a sandbag"]
                ] call ExileClient_gui_toaster_addTemplateToast;
            };
            case 1:
            {
                [
                    "InfoTitleAndText",
                    ["Digging", "Do not move while digging"]
                ] call ExileClient_gui_toaster_addTemplateToast;
                _progressBarColor = [0.82, 0.82, 0.82, 1];
            };
        };
        player switchMove "";
        ["switchMoveRequest", [netId player, ""]] call ExileClient_system_network_send;
        _progressBar ctrlSetBackgroundColor _progressBarColor;
        _progressBar ctrlSetPosition _progressBarMaxSize;
        _progressBar ctrlCommit 0;
    };

    ("ExileActionProgressLayer" call BIS_fnc_rscLayer) cutFadeOut 2;
    (findDisplay 46) displayRemoveEventHandler ["KeyDown", _keyDownHandle];
    (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", _mouseButtonDownHandle];
    ExileClientActionDelayShown = false;
    ExileClientActionDelayAbort = false;
    ExileReborn_hasFillSandBagAction = false;
    ExileReborn_digSandAction_current = nil;

},"",0,false,true,"",""];

ExileReborn_userActions pushBack 
[
    [
        ExileReborn_filLSandBagAction,
        "ExileReborn_hasFillSandBagAction",
        "ExileReborn_digSandAction_current",
        "(((surfaceType (getPos player)) in _types) && !(ExileReborn_hasFillSandBagAction) && ('Exile_Melee_Shovel' isEqualTo (currentWeapon player)))",
        false
    ]    
];

