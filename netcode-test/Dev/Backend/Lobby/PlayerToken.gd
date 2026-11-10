extends NetObject
class_name PlayerToken

var playerNumber : int;
var deviceId : int;
var originalOwnerId : int;

@export var customization : PlayerCustomization;

var inputDevice : InputDevice;

func DoSpawnParams() -> void:
	if(spawnParams.has("playerNumber")):
		playerNumber = spawnParams["playerNumber"];
	if(spawnParams.has("deviceId")):
		deviceId = spawnParams["deviceId"];
	if(spawnParams.has("customization")):
		customization.LoadFromParams(spawnParams["customization"]);
	originalOwnerId = ownerId;
	if(originalOwnerId == Network.myId):
		inputDevice = InputManager.GetInputDevice(deviceId);
		
	Network.LogStr("Player joined: ", playerNumber);
	
func GetSpawnParams():
	spawnParams.set("customization", customization.GetParams());
	return spawnParams;

func OwnerDisconnected():
	if(LobbyManager.Lobby.CanPlayerLeave()):
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);

func _ready() -> void:
	LobbyManager.Lobby.PlayerTokenCreated(self);

func _exit_tree() -> void:
	if(LobbyManager.Lobby != null):
		LobbyManager.Lobby.PlayerTokenDestroyed(self);
