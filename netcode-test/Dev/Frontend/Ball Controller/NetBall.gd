extends NetObject
class_name NetBall

@export var ballController : BallMCC;

@export var position : Vector3;
@export var velocity : Vector3;
@export var requestedMoveDirection : Vector3;
@export var stateIndex : int;
@export var stamina : float;
@export var health : float;
@export var fire : float;
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
		
	ballController.playerNumber = playerNumber;
	ballController.visuals.Setup(playerNumber);
	ballController.updatePhysics = !isDummy;
	
	if(!isDummy):
		playerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
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
		ballController.healthStat.value = lerp(ballController.healthStat.value, health, .5);
		ballController.fireStat.value = lerp(ballController.fireStat.value, fire, .5);
		ballController.invulnStat.value = lerp(ballController.invulnStat.value, invuln, .5);
		if(is_zero_approx(invuln)):
			ballController.invulnStat.value = 0;
	else:
		position = ballController.position;
		velocity = ballController.velocity;
		requestedMoveDirection = ballController.requestedMoveDirection;
		stateIndex = ballController.currentState.stateIndex;
		stamina = ballController.staminaStat.value;
		health = ballController.healthStat.value;
		fire = ballController.fireStat.value;
		invuln = ballController.invulnStat.value;
	pass
	
	
func _exit_tree() -> void:
	if(GameManager.Manager != null):
		GameManager.Manager.BallRemoved(playerNumber);
