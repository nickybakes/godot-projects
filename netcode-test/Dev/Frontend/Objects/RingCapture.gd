extends RingOfFire
class_name RingCapture

@export_category("Ring")
@export var mesh : MeshInstance3D;

@export_category("Height Detectors")
@export var numDetectors : int = 12;
@export var numEaseSteps : int = 4;
@export var easing : float = -2.0;
#@export_range(0.0, 1.0, .01) var averageRangeNormalized : float = .25;
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
	material.set_shader_parameter("arraySplit", 1.0/((numDetectors) as float));
	CreateDetectors();
	emberPrefab.visible = false;
	CreateEmberParticles();
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
	if(position != currentPosition):
		currentPosition = position;
		RenderingServer.global_shader_parameter_set("ringPosition", Vector2(currentPosition.x, currentPosition.z));
	if(radius != currentRadius):
		currentRadius = radius;
		scale.x = radius;
		scale.y = 1.0;
		scale.z = scale.x;
		RenderingServer.global_shader_parameter_set("ringRadius", currentRadius);
	SetDisabledDetectors(radius <= radiusToDisableDetectors);
	UpdateHeights();
	UpdateParticleRatio();
	SetDisabledParticles(radius <= radiusToDisableParticles);
	pass;
	
func UpdateHeights():
	for i in numDetectors:
		heights[i] = detectors[i].height;
	
	for i in numDetectors:
		var nextIndex = (i + 1) % detectors.size();
		var averageHeight = 0.0;
		var range = (numEaseSteps as float) / (numDetectors as float);
		var base = i - (range * .5);
		for j in numEaseSteps:
			averageHeight += GetHeight(base + (ease((numEaseSteps as float) * (j as float), easing) * range));
		
		averageHeight /= numEaseSteps;
		heightEased[i] = averageHeight;
		
	material.set_shader_parameter("heightArray", heightEased);
	pass;


func GetHeight(i : float) -> float:
	var iInt = i as int;
	var index0 = iInt % detectors.size();
	var index1 = (index0 + 1) % detectors.size();
	var t = i - iInt;
	var value = lerp(heights[index0], heights[index1], t);
	return value;
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
		heightEased.push_back(0.0);
		newDetector.position = Vector3(cos(currentAngle), 0, sin(currentAngle));
	pass;
