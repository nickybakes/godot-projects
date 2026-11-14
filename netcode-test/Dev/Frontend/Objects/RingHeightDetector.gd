extends Node3D
class_name RingHeightDetector

@export var moveTime : float = 1.0;
@export var raycast : RayCast3D;

var index : int = 0;
var clock : float = 0.0;
var prevHeight : float = 0.0;
var newHeight : float = 0.0;
var height : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!visible):
		return;
		
	clock += delta;
	height = lerp(prevHeight, newHeight, clock/moveTime);
	if(clock >= moveTime):
		SampleNewHeight();
		clock = 0.0;
	pass

func SampleNewHeight():
	raycast.enabled = true;
	raycast.force_raycast_update();
	prevHeight = newHeight;
	if(raycast.is_colliding()):
		newHeight = raycast.get_collision_point().y;
		pass;
	pass;
