extends InputDevice
class_name InputDeviceJoypad

var deviceName : String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.joy_connection_changed.connect(OnJoyConnectionChanged);
	pass # Replace with function body.
	
func SetupJoypad(_device : int, isReconnect : bool = false):
	disconnected = false;
	device = _device;
	deviceName = Input.get_joy_name(device);
	if(isReconnect):
		InputManager.ReconnectJoypad.emit(device, deviceName);
	else:
		InputManager.RegisterJoypad.emit(device, deviceName);
	
func OnJoyConnectionChanged(_device : int, connected : bool):
	if(_device != device):
		return;
		
	if(connected && disconnected):
		disconnected = false;
		SetupJoypad(device, true)
	elif(!connected && !disconnected):
		disconnected = true;
		InputManager.DisconnectJoypad.emit(device, deviceName);
	pass;
	
func _input(event: InputEvent) -> void:
	if(event.device == device):
		inputBuffer.OnInput(event);
		GetMoveInput();
		pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta);
	pass
