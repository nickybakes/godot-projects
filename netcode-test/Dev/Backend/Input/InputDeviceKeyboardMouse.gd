extends InputDevice
class_name InputDeviceKeyboardMouse

var mouseScale := .001;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	device = 16;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta);
	pass
	
func _input(event: InputEvent) -> void:
	if(event.device == 16 || event.device == 32):
		inputBuffer.OnInput(event);
		GetMoveInput();
		pass;

#func _unhandled_input(event: InputEvent) -> void:	
	#if(event is InputEventMouseMotion):
		#vectorInput.x = event.relative.x * mouseScale
		#vectorInput.y = event.relative.y * mouseScale
