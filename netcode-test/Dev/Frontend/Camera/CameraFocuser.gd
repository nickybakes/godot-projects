extends Node3D
class_name CameraFocuser

@export var cameraRotation : Node3D;

@export var mapCenter : Node3D;
@export var mapMax : Node3D;
@export var mapMin : Node3D;

@export var camMax : Node3D;
@export var camMin : Node3D;

@export var radiusMultiplier : Vector3 = Vector3(1.0, 1.667, 1.0);

@export var zoomSizeCurve : Curve;
@export var heightOffsetByZoomCurve : Curve;
@export var heightOffsetByTotalStrengthCurve : Curve;
@export var singleTargetHeightOffset : float;

var mapSize : Vector3;
var mapTopDownRatio : float;
var mapRadius : float;

var targets : Array[CameraTarget];


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targets = [];
	mapSize = abs(mapMax.global_position - mapMin.global_position);
	mapTopDownRatio = mapSize.x / mapSize.z;
	mapRadius = mapSize.length();
	pass # Replace with function body.


func AddTarget(target : CameraTarget):
	targets.push_back(target);

func _process(delta: float) -> void:
	
	var center = mapCenter.global_position;
	
	var boundsMin = mapMax.global_position;
	var boundsMax = mapMin.global_position;
	
	var totalStrength : float = 0.0;
	
	for target in targets:
		var strength = target.GetStrength();
		totalStrength += strength;
		var position = target.global_position;
		#position = clamp(position, mapMin.global_position, mapMax.global_position);
		center += lerp(Vector3.ZERO, position, strength);

		var targetBoundsMin = lerp(mapMax.global_position, position, strength);
		var targetBoundsMax = lerp(mapMin.global_position, position, strength);
		
		boundsMin.x = min(targetBoundsMin.x, boundsMin.x);
		boundsMin.y = min(targetBoundsMin.y, boundsMin.y);
		boundsMin.z = min(targetBoundsMin.z, boundsMin.z);
		
		boundsMax.x = max(targetBoundsMax.x, boundsMax.x);
		boundsMax.y = max(targetBoundsMax.y, boundsMax.y);
		boundsMax.z = max(targetBoundsMax.z, boundsMax.z);
		
		pass;
	pass
	
	if(totalStrength != 0):
		center = center / totalStrength;

	var boundsSize : Vector3 = abs(boundsMax - boundsMin);
	boundsSize *= radiusMultiplier;
	var radius = boundsSize.length();
	
	center.x = clamp(center.x, camMin.global_position.x, camMax.global_position.x);
	center.y = clamp(center.y, camMin.global_position.y, camMax.global_position.y);
	center.z = clamp(center.z, camMin.global_position.z, camMax.global_position.x);
	var finalPos = Vector3(center.x, center.y, center.z);
	var radiusPercentage = radius / mapRadius;
	
	
	var zoom = zoomSizeCurve.sample(radiusPercentage);
	
	position.z = zoom;
	var heightOffset = heightOffsetByZoomCurve.sample(radiusPercentage);
	heightOffset = lerp(singleTargetHeightOffset, heightOffset, heightOffsetByTotalStrengthCurve.sample(totalStrength));
	finalPos.y += heightOffset;
	
	cameraRotation.position = lerp(cameraRotation.position, finalPos, .5);
