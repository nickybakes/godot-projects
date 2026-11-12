extends Node
class_name AppGlobal

var currentWindowSettingIndex = 0; 

var windowSettings = [DisplayServer.WINDOW_MODE_MAXIMIZED, DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]

signal WindowModeChanged(newMode : int);

func _ready() -> void:
	DisplayServer.window_set_mode(windowSettings[currentWindowSettingIndex]);
	pass;

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("fullscreentoggle")):
		if(currentWindowSettingIndex == windowSettings.size() - 1):
			currentWindowSettingIndex = 0;
		else:
			currentWindowSettingIndex += 1;
		DisplayServer.window_set_mode(windowSettings[currentWindowSettingIndex]);
		WindowModeChanged.emit(windowSettings[currentWindowSettingIndex]);
