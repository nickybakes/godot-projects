extends Node3D
class_name CursorManager

var cursorPath : String = "uid://ch7sfo3ux3n0v";

@export var width : float;
@export var height : float;
@export_range(0, 1, .01) var cursorScale : float;

@export var cursorVerticalTime : float;
@export_range(0, 1, .01) var cursorSpawnNormalizedHeight : float;
@export_range(0, 1, .01) var cursorSpawnNormalizedLength : float;


@export var cursorColors : Array[Color];

var aspectRatio : float;
var normalizedCursorSpeed : float;

var cursors : Dictionary[int, Cursor];

static var Manager : CursorManager;

func _ready() -> void:
	Manager = self;
	cursors = {};
	cursorVerticalTime = max(cursorVerticalTime, .0001);
	normalizedCursorSpeed = 1/cursorVerticalTime;
	aspectRatio = width/height;
	LobbyManager.Lobby.PlayerJoinAccepted.connect(PlayerJoinAccepted);
	LobbyManager.Lobby.PlayerRemoved.connect(PlayerRemoved);
	
func _exit_tree() -> void:
	if(LobbyManager.Lobby):
		LobbyManager.Lobby.PlayerJoinAccepted.disconnect(PlayerJoinAccepted);
		LobbyManager.Lobby.PlayerRemoved.disconnect(PlayerRemoved);

func PlayerJoinAccepted(playerToken : PlayerToken):
	if(playerToken.originalOwnerId == Network.myId):
		Network.LogStr("Cursor create for P", playerToken.playerNumber);
		var spawnParams = {"playerNumber": playerToken.playerNumber, "normalizedPosition": CursorManager.Manager.GetStartNormalizedPositionByPlayerNumber(playerToken.playerNumber)};
		GameNetManager.GameNet.netObjectManager.SpawnNetObject(cursorPath, spawnParams, true);
	pass;
	
func PlayerRemoved(playerNumber : int, clientId : int, inputDevice : int):
	if(cursors.has(playerNumber) && cursors[playerNumber] != null && cursors[playerNumber].ownerId == Network.myId):
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(cursors[playerNumber].id);
	pass;
	
func CursorAdded(playerNumber : int, cursor : Cursor):
	cursors.set(playerNumber, cursor);
	
func CursorRemoved(playerNumber : int):
	cursors.erase(playerNumber);
	
func GetStartNormalizedPositionByPlayerNumber(playerNumber : int) -> Vector2:
	var newPosition = Vector2.ZERO;
	newPosition.y = cursorSpawnNormalizedHeight;
	var separation = cursorSpawnNormalizedLength / (LobbyManager.Lobby.MAX_PLAYERS as float);
	var startX = .5 - (cursorSpawnNormalizedLength * .5);
	newPosition.x = startX + (separation * (playerNumber - 1));
	
	return newPosition;
	pass;
	
func MoveNormalizedPosition(normalizedPosition : Vector2, moveInput : Vector2, delta : float) -> Vector2:
	var newPosition = normalizedPosition;
	
	newPosition.x = clampf(normalizedPosition.x + (normalizedCursorSpeed * moveInput.x * delta), 0, 1);
	newPosition.y = clampf(normalizedPosition.y + (normalizedCursorSpeed * aspectRatio * moveInput.y * delta), 0, 1);
	
	return newPosition;
	
	
func SetTransformFromNormalizedPosition(normalizedPosition : Vector2, cursorTransform : Node3D):
	var newPosition = position;
	newPosition.x = position.x + ((normalizedPosition.x - .5) * width);
	newPosition.y = position.y + ((normalizedPosition.y - .5) * height);
	newPosition.z = position.z;
	cursorTransform.position = newPosition;
	cursorTransform.scale = Vector3(cursorScale, cursorScale, cursorScale);

func GetColorFromPlayerNumber(playerNumber : int) -> Color:
	return cursorColors[(playerNumber - 1) % cursorColors.size()];
