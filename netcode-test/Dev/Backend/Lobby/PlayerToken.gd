extends NetObject
class_name PlayerToken

var playerNumber : int;
var deviceId : int;
var originalOwnerId : int;

var inputDevice : InputDevice;

func DoSpawnParams() -> void:
	if(spawnParams.has("playerNumber")):
		playerNumber = spawnParams["playerNumber"];
	if(spawnParams.has("deviceId")):
		deviceId = spawnParams["deviceId"];
	originalOwnerId = ownerId;
	if(originalOwnerId == Network.myId):
		inputDevice = InputManager.GetInputDevice(deviceId);
		
	Network.LogStr("Player joined: ", playerNumber);

func OwnerDisconnected():
	if(LobbyManager.Lobby.CanPlayerLeave()):
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);

func _ready() -> void:
	LobbyManager.Lobby.PlayerTokenCreated(self);

func _exit_tree() -> void:
	LobbyManager.Lobby.PlayerTokenDestroyed(self);
