extends Node

signal RegisterJoypad(device : int, deviceName : String);
signal DisconnectJoypad(device : int, deviceName : String);
signal ReconnectJoypad(device : int, deviceName : String);

var keyboardMouseInput : InputDeviceKeyboardMouse;

var joypadDevices : Dictionary[int, InputDeviceJoypad];


func _ready() -> void:
	Input.ignore_joypad_on_unfocused_application = true;
	keyboardMouseInput = InputDeviceKeyboardMouse.new();
	add_child(keyboardMouseInput);
	joypadDevices = {};
	for action in InputMap.get_actions():
		if(action.begins_with('_')):
			#print_rich("[b]", action, "[/b]");
			for event in InputMap.action_get_events(action):
				if(event.device == 16 || event.device == -1):
					if(!InputMap.has_action(action + str(16))):
						InputMap.add_action(action + str(16));
					InputMap.action_add_event(action + str(16), event);
					pass;
				elif(event.device == 0):
					for i in 8:
						if(!InputMap.has_action(action + str(i))):
							InputMap.add_action(action + str(i));
							
						var joyPadEvent = event.duplicate();
						joyPadEvent.device = i;
						InputMap.action_add_event(action + str(i), joyPadEvent);
						pass;

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if(!joypadDevices.has(event.device)):
			var newJoypadDevice : InputDeviceJoypad = InputDeviceJoypad.new();
			newJoypadDevice.SetupJoypad(event.device, false);
			add_child(newJoypadDevice);
			joypadDevices.set(event.device, newJoypadDevice);
			newJoypadDevice.inputBuffer.OnInput(event);
			pass;
		pass;
	pass;

func GetInputDevice(deviceId : int) -> InputDevice:
	if(joypadDevices.keys().has(deviceId)):
		return joypadDevices[deviceId];
	return keyboardMouseInput;
