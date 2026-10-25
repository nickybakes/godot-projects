extends Node3D
class_name CameraManager;

@export var camera : Camera3D;

static var CM : CameraManager;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CM = self;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
