extends Node3D
class_name CameraManager;

@export var camera : Camera3D;
@export var focuser : CameraFocuser;
@export var shaker : Shaker;

static var CM : CameraManager;

func _ready() -> void:
	CM = self;

	
	
	
	
	
