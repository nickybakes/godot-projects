extends Node3D
class_name RingCapture

@export_category("Ring")
@export var radius : float = 5.0;
@export var mesh : MeshInstance3D;

@export_category("Height Detectors")
@export var numDetectors : int = 12;
@export var numEaseSteps : int = 4;
@export var easing : float = -2.0;
@export var detectorPrefab : RingHeightDetector;
@export var detectorContainer : Node3D;
@export var radiusToDisableDetectors = 1.0;


var detectorsDisabled : bool = false;
var detectors : Array[RingHeightDetector];
var heights : Array[float];
var heightEased : Array[float];
var material : Material;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detectorPrefab.visible = false;
	mesh.material_override = mesh.material_override.duplicate();
	material = mesh.material_override;
	material.set_shader_parameter("arraySplit", 1.0/((numDetectors * numEaseSteps) as float));
	CreateDetectors();
	pass # Replace with function body.


func _process(delta):
	UpdateScaleAndPosition();
	
	
func SetDisabledDetectors(disabled : bool):
	if(detectorsDisabled == disabled || !detectors):
		return;
		
	detectorsDisabled = disabled;
		
	for detector in detectors:
		detector.visible = !disabled;	


func UpdateScaleAndPosition():
	scale.x = radius;
	scale.y = 1.0;
	scale.z = scale.x;
	SetDisabledDetectors(radius <= radiusToDisableDetectors);
	UpdateHeights();
	pass;
	
func UpdateHeights():
	for i in numDetectors:
		heights[i] = detectors[i].height;
	
	var easeIndex = 0;
	for i in numDetectors:
		var nextIndex = (i + 1) % detectors.size();
		for j in numEaseSteps:
			var p = (j as float)/(numEaseSteps as float);
			heightEased[easeIndex] = lerp(detectors[i].height, detectors[nextIndex].height, ease(p, easing));
			easeIndex += 1;
		
	material.set_shader_parameter("heightArray", heightEased);
	pass;
	
func CreateDetectors():
	detectors = [];
	heights = [];
	for i in numDetectors:
		var newDetector = detectorPrefab.duplicate() as RingHeightDetector;
		newDetector.visible = true;
		newDetector.index = i;
		var currentAngle = ((i as float/numDetectors as float)) * (PI*2.0);
		detectorContainer.add_child(newDetector, true);
		detectors.push_back(newDetector);
		heights.push_back(0.0);
		for j in numEaseSteps:
			heightEased.push_back(0.0);
		newDetector.position = Vector3(cos(currentAngle), 0, sin(currentAngle));
	pass;
