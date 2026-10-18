extends Node
class_name InputDevice

var inUse : bool = false;
var disconnected : bool = false;
var device : int = -1;

#var primaryVectorInput := Vector2.ZERO;
#var secondaryVectorInput := Vector2.ZERO;

var vectorInput := Vector2.ZERO;
var moveInput := Vector2.ZERO;
var inputBuffer : InputBuffer;

var moveLeftString = "_move_left";
var moveRightString = "_move_right";
var moveDownString = "_move_down";
var moveUpString = "_move_up";


func _init():
	inputBuffer = InputBuffer.new();
	
func _process(delta: float) -> void:
	inputBuffer.Update(delta);

func _ready() -> void:
	pass;

func GetMoveInput():
	moveInput = Input.get_vector(GetInputString(moveLeftString), GetInputString(moveRightString), GetInputString(moveDownString), GetInputString(moveUpString));
	
func GetInputString(baseInputString : String) -> String:
	return baseInputString + str(device);
	
