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

func Setup(colorIndex : int):
	currentMaterial = middle.material_override.duplicate();
	start.material_override = currentMaterial;
	middle.material_override = currentMaterial;
	end.material_override = currentMaterial;
	SetColorIndex(colorIndex);
	
func SetColorIndex(colorIndex : int):
	currentMaterial.set_shader_parameter("color", colors[colorIndex]);

func FollowTarget(delta : float):
	if(startPointTarget):
		var startPos = CameraManager.CM.camera.project_position(startPointTarget.global_position, zDepth);
		global_position = startPos;
		if(endPointTarget):
			var endPos = CameraManager.CM.camera.unproject_position(endPointTarget.global_position + endPoint3DOffset);
			endPos = CameraManager.CM.camera.project_position(endPos + endPoint2DOffset, zDepth);
			var direction = (endPos - startPos).normalized();
			var targetAngle = atan2(-direction.x, direction.y)
			rotation.z = (targetAngle);
			var distance = startPos.distance_to(endPos);
			middle.scale.y = (distance * 2.0) - 1.0;
			middle.position.y = (distance * .5);
			end.position.y = (distance);
			
		pass;
