extends Node3D
class_name CameraManager;

@export var camera : Camera3D;
@export var focuser : CameraFocuser;
@export var shaker : Shaker;

@export var blurCameraAttributes : CameraAttributesPractical;

static var CM : CameraManager;

var blurEnabled : bool;

func _ready() -> void:
	CM = self;
	SetBlur(false, true);

func SetBlur(enabled : bool, force = false):
	if(blurEnabled == enabled && !force):
		return;
	blurEnabled = enabled;
	if(enabled):
		camera.set_attributes(blurCameraAttributes);
	else:
		camera.set_attributes(null);
