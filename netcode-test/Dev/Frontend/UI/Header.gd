extends Control
class_name Header;

@export var targetOffset := Vector3.ZERO;

@export var headerOffset := Vector2.ZERO;

var target : Node3D;

func FollowTarget(delta : float):
	var targetPosition = target.global_position + targetOffset;
	position = CameraManager.CM.camera.unproject_position(targetPosition);
	pass;
