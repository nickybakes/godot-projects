extends NetObject
class_name NetBall

@export var ballController : BallMCC;

@export var position : Vector3;
@export var velocity : Vector3;
@export var requestedMoveDirection : Vector3;
@export var stateIndex : int;
@export var stamina : float;
@export var health : float;
@export var electric : float;
@export var invuln : float;

var playerNumber : int;
var playerToken : PlayerToken;
var inputDevice : InputDevice;
var currentStateIndex : int = -1;

func DoSpawnParams():
	if(spawnParams.has("playerNumber")):
		playerNumber = spawnParams["playerNumber"];
	if(spawnParams.has("position")):
		position = spawnParams["position"];
		ballController.position = position;
	if(spawnParams.has("velocity")):
		velocity = spawnParams["velocity"];
		ballController.velocity = velocity;
		
	playerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
	ballController.playerToken = playerToken;
	
	ballController.playerNumber = playerNumber;
	ballController.updatePhysics = !isDummy;
	ballController.visuals.Setup(playerNumber);
	
	if(!isDummy):
		inputDevice = playerToken.inputDevice;
		ballController.inputDevice = inputDevice;
		
	if(GameManager.Manager):
		GameManager.Manager.BallAdded(playerNumber, self);
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(isDummy):
		ballController.position = lerp(ballController.position, position, .5);
		ballController.velocity = lerp(ballController.velocity, velocity, .5);
		ballController.requestedMoveDirection = lerp(ballController.requestedMoveDirection, requestedMoveDirection, .5)
		if(currentStateIndex != stateIndex):
			currentStateIndex = stateIndex;
			ballController.DoStateTransitionByIndex(stateIndex);
		
		ballController.staminaStat.value = lerp(ballController.staminaStat.value, stamina, .5);
		ballController.staminaStat.CalcPercent();
		
		ballController.healthStat.value = lerp(ballController.healthStat.value, health, .5);
		ballController.healthStat.CalcPercent();
		
		ballController.electricStat.value = lerp(ballController.electricStat.value, electric, .5);
		ballController.electricStat.CalcPercent();
		
		ballController.invulnStat.value = lerp(ballController.invulnStat.value, invuln, .5);
		if(is_zero_approx(invuln)):
			ballController.invulnStat.value = 0;
		ballController.invulnStat.CalcPercent();
		
	else:
		position = ballController.position;
		velocity = ballController.velocity;
		requestedMoveDirection = ballController.requestedMoveDirection;
		stateIndex = ballController.currentState.stateIndex;
		stamina = ballController.staminaStat.value;
		health = ballController.healthStat.value;
		electric = ballController.electricStat.value;
		invuln = ballController.invulnStat.value;
		if(inputDevice != null && playerToken):
			if(inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.ToggleInvert, 1)):
				playerToken.customization.invertChargeAim = !playerToken.customization.invertChargeAim;
				pass;
	pass
	
func OwnerDisconnected():
	ballController.updatePhysics = !isDummy;
	pass;
	
func _exit_tree() -> void:
	if(GameManager.Manager != null):
		GameManager.Manager.BallRemoved(playerNumber);
