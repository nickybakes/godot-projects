extends NetObject
class_name Cursor

@export var transform: Node3D
@export var sprite: Sprite3D
@export var text: Label3D

@export var normalizedPosition : Vector2;
var currentNormalizedPosition : Vector2;

var playerNumber : int;
var playerToken : PlayerToken;
var inputDevice : InputDevice;

func DoSpawnParams():
	if(spawnParams.has("playerNumber")):
		playerNumber = spawnParams["playerNumber"];
	if(spawnParams.has("normalizedPosition")):
		normalizedPosition = spawnParams["normalizedPosition"];
		currentNormalizedPosition = spawnParams["normalizedPosition"];
		
	text.text = str("P", playerNumber);	
	sprite.modulate = CursorManager.Manager.GetColorFromPlayerNumber(playerNumber);
	
	CursorManager.Manager.CursorAdded(playerNumber, self);
	
	if(!isDummy):
		playerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
		inputDevice = playerToken.inputDevice;
	
	pass;

func _process(delta: float) -> void:
	if(CursorManager.Manager != null):
		if(isDummy):
			currentNormalizedPosition = lerp(currentNormalizedPosition, normalizedPosition, .5);
		elif(inputDevice != null):
			currentNormalizedPosition = CursorManager.Manager.MoveNormalizedPosition(currentNormalizedPosition, inputDevice.moveInput, delta);
			normalizedPosition = currentNormalizedPosition;
			
		CursorManager.Manager.SetTransformFromNormalizedPosition(currentNormalizedPosition, transform);

func _exit_tree() -> void:
	CursorManager.Manager.CursorRemoved(playerNumber);
