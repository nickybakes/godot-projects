extends Node3D
class_name BallVisuals;

@export var ballController : BallMCC;
@export var ballCustomizationDirectory : BallCustomizationDirectory;
@export var profile : BallVisualProfile;

@export_category("Meshes")
@export var ballMesh : MeshInstance3D;
@export var outlineMesh : MeshInstance3D;
@export var xrayMesh : MeshInstance3D;
@export var chargeAimMesh : MeshInstance3D;
@export var blockMesh : MeshInstance3D;

@export_category("Transforms")
@export var spinner : Node3D;
@export var pitcher : Node3D;
@export var stretcher : Node3D;
@export var roller : Node3D;

const headerPrefab = preload("uid://u6oslcx36ah4");
var header : BallHeader;

func Setup(playerNumber : int):
	var color = ballCustomizationDirectory.GetColorFromPlayerNumber(playerNumber);
	var ballMaterial = ballCustomizationDirectory.ballMaterialBasic.duplicate();
	var outlineMaterial = ballCustomizationDirectory.outlineMaterial.duplicate();
	var xrayMaterial = ballCustomizationDirectory.xrayMaterial.duplicate();
	var chargeAimMaterial = ballCustomizationDirectory.chargeAimMaterial.duplicate();
	ballMaterial.set_shader_parameter("color", color);
	outlineMaterial.set_shader_parameter("color", color);
	xrayMaterial.set_shader_parameter("color", color);
	chargeAimMaterial.set_shader_parameter("color", color);
	ballMesh.material_override = ballMaterial;
	outlineMesh.material_override = outlineMaterial;
	xrayMesh.material_override = xrayMaterial;
	chargeAimMesh.material_override = chargeAimMaterial;
	
	StopChargeVisual();
	StopBlockVisual();
	CreateHeader();
	
func CreateHeader():
	header = headerPrefab.instantiate();
	get_parent().add_child.call_deferred(header);
	header.target = self;
	header.DisplayStaminaMax(ballController.staminaStat.maxValue);
	
func RollBall(currentSpeed : float, delta : float):
	roller.rotate_object_local(Vector3.LEFT, currentSpeed * profile.rollSpeedScalar * delta);
	pass;
	
func SpinFaceDirection(topDownDirection : Vector2):
	var targetRotation = atan2(-topDownDirection.x, -topDownDirection.y);
	spinner.rotation.y = lerp_angle(spinner.rotation.y, targetRotation, .5);
	pass;
	
func PitchBall(pitch : float):
	pitcher.rotation.x = lerp_angle(pitcher.rotation.x, pitch, .5);
	pass
	
func FaceDirection(direction : Vector3):
	SpinFaceDirection(Vector2(direction.x, direction.z));
	PitchBall(direction.y * (PI * .5))
	
func ChargeStretchBall(t : float):
	stretcher.scale.z = lerp(1.0, profile.maxStretchCharge, t);
	stretcher.position.z = lerp(0.0, profile.maxOffsetCharge, t);
	
func SoarStretchBall(currentSpeed : float, delta : float):
	stretcher.scale.z = clamp(stretcher.scale.z, 1.0, profile.maxStretch);

func StartChargeVisual():
	chargeAimMesh.visible = true;
	
func StopChargeVisual():
	chargeAimMesh.visible = false;
	
func StartBlockVisual():
	blockMesh.visible = true;
	
func StopBlockVisual():
	blockMesh.visible = false;
