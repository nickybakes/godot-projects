extends Node3D
class_name BallVisuals;

@export var ballController : BallMCC;
@export var ballCustomizationDirectory : BallCustomizationDirectory;
@export var profile : BallVisualProfile;
@export var shadowDecal : Decal;
@export var cameraTarget : CameraTarget;
@export var header : BallHeader;

var ballHubElement : BallHubElement;

@export_category("Meshes")
@export var ballMesh : MeshInstance3D;
@export var outlineMesh : MeshInstance3D;
@export var xrayMesh : MeshInstance3D;
@export var chargeAimMesh : MeshInstance3D;
@export var blockMesh : MeshInstance3D;

@export_category("Electric")
@export var electricParticles : GPUParticles3D;

@export_category("Clash")
@export var clashVisual : Node3D;

@export_category("Strike")
@export var strikeVisual : Node3D;

@export_category("Grab")
@export var grabVisual : Node3D;

@export_category("Messages")
@export var eliminatedVisual : Node3D;
@export var strikePriorityVisual : Node3D;
@export var unblockableVisual : Node3D;

var messageTime : float = 0.0;

@export_category("Transforms")
@export var spinner : Node3D;
@export var pitcher : Node3D;
@export var stretcher : Node3D;
@export var roller : Node3D;

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
	
	var electricColor = ballCustomizationDirectory.GetElectricColorFromPlayerNumber(playerNumber);
	electricParticles.material_override = electricParticles.material_override.duplicate();
	electricParticles.material_override.set_shader_parameter("color", electricColor);
	
	header.target = ballController;
	
	StopChargeVisual();
	StopBlockVisual();
	StopClashVisual();
	StopStrikeVisual();
	StopGrabVisual();
	StopGrabSuccessAimVisual();
	HideMessages();
	
func RollBall(currentSpeed : float, delta : float):
	roller.rotate_object_local(Vector3.LEFT, currentSpeed * profile.rollSpeedScalar * delta);
	pass;
	
func SpinFaceDirection(topDownDirection : Vector2):
	var targetRotation = atan2(-topDownDirection.x, -topDownDirection.y);
	spinner.rotation.y = lerp_angle(spinner.rotation.y, targetRotation, .5);
	pass;
	
func PitchBall(pitch : float, delta : float):
	pitcher.rotation.x = move_toward(wrap(pitcher.rotation.x, -TAU, TAU), pitch, profile.pitchChangeSpeed * delta);
	pass
	
func FaceDirection(direction : Vector3, delta : float):
	SpinFaceDirection(Vector2(direction.x, direction.z));
	PitchBall(direction.y * (PI * .5), delta)
	
#func FaceElectricBySpeed(currentSpeed : float):
	#electricMeshesParent.rotation.x = min(PI * .5, profile.electricRollSpeedScalar * currentSpeed);
	
func SpeedStretch(currentSpeed : float):
	var t = currentSpeed * profile.rollStretchSpeedScalar;
	stretcher.scale.z = lerp(1.0, profile.maxRollStretch, t);
	stretcher.scale.x = lerp(1.0, profile.rollMinThin, t);
	stretcher.scale.y = lerp(1.0, profile.rollMinThin, t);
	
func ChargeStretchBall(t : float):
	stretcher.scale.z = lerp(1.0, profile.maxStretchCharge, t);
	stretcher.scale.x = lerp(1.0, profile.minThinCharge, t);
	stretcher.scale.y = lerp(1.0, profile.minThinCharge, t);
	stretcher.position.z = lerp(0.0, profile.maxOffsetCharge, t);
	
func SoarStretchBall(currentSpeed : float, delta : float):
	stretcher.scale.z = clamp(stretcher.scale.z, 1.0, profile.maxStretch);
	
func UpdateElectricVisuals(percent : float, delta : float):
	electricParticles.amount_ratio = percent;
	pass;

var blinkTime := 0.0;

func UpdateInvulnVisuals(invulnAmount : float, delta : float):
	if(is_zero_approx(invulnAmount)):
		stretcher.visible = true;
	else:
		blinkTime += delta * invulnAmount * profile.invulnBlinkSpeed;
		if(blinkTime > 1.0):
			stretcher.visible = !stretcher.visible;
	pass;

func StartChargeVisual():
	chargeAimMesh.visible = true;
	
func StopChargeVisual():
	chargeAimMesh.visible = false;
	
func StartBlockVisual():
	blockMesh.visible = true;
	
func StopBlockVisual():
	blockMesh.visible = false;
	
func StartClashVisual():
	clashVisual.visible = true;
	
func StopClashVisual():
	clashVisual.visible = false;
	
func StartStrikeVisual():
	strikeVisual.visible = true;
	
func StopStrikeVisual():
	strikeVisual.visible = false;
	
func StartGrabVisual():
	grabVisual.visible = true;
	
func StopGrabVisual():
	grabVisual.visible = false;
	
	
func StartGrabSuccessAimVisual():
	chargeAimMesh.visible = true;
	
func StopGrabSuccessAimVisual():
	chargeAimMesh.visible = false;
	
func HideMessages():
	eliminatedVisual.visible = false;
	strikePriorityVisual.visible = false;
	unblockableVisual.visible = false;
	
func ShowEliminatedMessage():
	messageTime = profile.eliminatedMessageTime;
	HideMessages();
	eliminatedVisual.visible = true;
	ballHubElement.ShowEliminated();
	
func ShowStrikePriorityMessage():
	messageTime = profile.strikePriorityMessageTime;
	HideMessages();
	strikePriorityVisual.visible = true;
	
func ShowUnblockableMessage():
	messageTime = profile.unblockableMessageTime;
	HideMessages();
	unblockableVisual.visible = true;
	
func HideBall():
	spinner.visible = false;
	ballHubElement.trackerLine.visible = false;
	shadowDecal.visible = false;
	header.visible = false;
	
func ShowBall():
	spinner.visible = true;
	ballHubElement.trackerLine.visible = true;
	shadowDecal.visible = true;
	header.visible = true;
	
func _process(delta: float) -> void:
	messageTime = move_toward(messageTime, 0.0, delta);
	if(messageTime == 0):
		HideMessages();
	
	
