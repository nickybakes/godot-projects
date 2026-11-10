extends Node3D
class_name TrackerLine

const MAX_ANGLE = PI * .5;

@export var start : MeshInstance3D
@export var middle : MeshInstance3D
@export var end : MeshInstance3D

var currentMaterial : Material;

var startPointTarget : Control;
var endPointTarget : Node3D;

@export var zDepth : float;
@export var endPoint3DOffset := Vector3.ZERO;
@export var endPoint2DOffset := Vector2.ZERO;

@export var colors : Array[Color];
@export var pulseTimeOffset : float = .25;

@export var heartbeatTransitionSpeed : float = 1.0;
@export var alphaMultiplyTransitionSpeed : float = 1.0;

var heartbeat : float = 0.0;
var goalHeartbeat : float = 0.0;

var alphaMultiply : float = 1.0;
var goalAlphaMultiply : float = 1.0;
var maxAlphaMultiply : float = 13.0;

func Setup(playerNumber : int):
	currentMaterial = middle.material_override.duplicate();
	start.material_override = currentMaterial;
	middle.material_override = currentMaterial;
	end.material_override = currentMaterial;
	SetPulseOffset(playerNumber);
	
	reparent(CameraManager.CM.camera, false);
	
func SetColorIndex(colorIndex : int):
	currentMaterial.set_shader_parameter("color", colors[colorIndex]);
	
func SetPulseOffset(playerNumber : int):
	currentMaterial.set_shader_parameter("pulseOffset", (playerNumber - 1) * pulseTimeOffset);
	
	
func _process(delta: float) -> void:
	heartbeat = move_toward(heartbeat, goalHeartbeat, delta * heartbeatTransitionSpeed);
	alphaMultiply = move_toward(alphaMultiply, goalAlphaMultiply, delta * alphaMultiplyTransitionSpeed);
	if(visible):
		currentMaterial.set_shader_parameter("heartbeatFade", clamp(heartbeat, 0.0, 1.0));
		currentMaterial.set_shader_parameter("alphaMultiply", clamp(alphaMultiply, 0.0, maxAlphaMultiply));
	

func FollowTarget(delta : float):
	if(startPointTarget):
		var startPos = CameraManager.CM.camera.project_position(startPointTarget.global_position, zDepth);
		global_position = startPos;
		if(endPointTarget):
			var endPos = CameraManager.CM.camera.unproject_position(endPointTarget.global_position + endPoint3DOffset);
			endPos = CameraManager.CM.camera.project_position(endPos + endPoint2DOffset, zDepth);
			
			var direction = (endPos - startPos).normalized();
			direction = direction.rotated(Vector3.DOWN, CameraManager.CM.camera.global_rotation.y);
			direction = direction.rotated(Vector3.LEFT, CameraManager.CM.camera.global_rotation.x);
			direction = direction.rotated(Vector3.FORWARD, CameraManager.CM.camera.global_rotation.z);
			var targetAngle = atan2(-direction.x, direction.y)
			rotation = Vector3.ZERO;
			rotation.z = targetAngle;
			
			var distance = startPos.distance_to(endPos);
			middle.scale.y = (distance * 2.0) - 1.0;
			middle.position.y = (distance * .5);
			end.position.y = (distance);
			
		pass;
