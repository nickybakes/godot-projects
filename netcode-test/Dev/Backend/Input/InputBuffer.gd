class_name InputBuffer

const MAX_INPUT_BUFFER_TIME := .2

var inputs_pressed_this_frame := []
var inputs_pressed := []
var inputs_released := []
var inputs_held_time := []
var inputs_is_held := []
var inputs := ["_join", "_jump", "_leave", "_startgame"]

func _init() -> void:
	for i in inputs.size():
		inputs_pressed_this_frame.push_back(false);
		inputs_pressed.push_back(1.0);
		inputs_released.push_back(1.0);
		inputs_held_time.push_back(0.0);
		inputs_is_held.push_back(false);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta):
	for n in inputs.size():
		inputs_pressed_this_frame[n] = false;
		inputs_pressed[n] += delta
		inputs_released[n] += delta
		if(inputs_is_held[n]):
			inputs_held_time[n] += delta

func InputJustPressed(inputIndex : int):
	inputs_pressed_this_frame[inputIndex] = true;
	inputs_pressed[inputIndex] = 0.0
	inputs_held_time[inputIndex] = 0.0
	inputs_is_held[inputIndex] = true;
	
func InputJustReleased(inputIndex : int):
	inputs_held_time[inputIndex] = 0.0
	inputs_released[inputIndex] = 0.0
	inputs_is_held[inputIndex] = false;
	
func get_movement_direction() -> Vector2:
	return Vector2.ZERO;
			
func IsActionJustPressed(input : Enums.InputAction) -> bool:
	return inputs_pressed[input] < MAX_INPUT_BUFFER_TIME
	
func IsActionJustPressedThisFrame(input : Enums.InputAction) -> bool:
	return inputs_pressed_this_frame[input]
	
func IsActionJustReleased(input : Enums.InputAction) -> bool:
	return inputs_released[input] < MAX_INPUT_BUFFER_TIME
	
func IsActionPressed(input : Enums.InputAction) -> bool:
	return inputs_is_held[input]
	
func ActionHeldTime(input : Enums.InputAction) -> float:
	return inputs_held_time[input]
	
func OnInput(inputEvent : InputEvent):
	for index in inputs.size():
		var inputName = inputs[index] + str(inputEvent.device);
		if(InputMap.has_action(inputName)):
			if(Input.is_action_just_pressed_by_event(inputName, inputEvent)):
				InputJustPressed(index);
			if(Input.is_action_just_released_by_event(inputName, inputEvent)):
				InputJustReleased(index);
	
