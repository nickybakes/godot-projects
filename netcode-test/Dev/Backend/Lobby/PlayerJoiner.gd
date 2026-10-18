extends Node
class_name PlayerJoiner;

var playerTokenPath = "uid://4buqgu3qs5hk";

var inputDeviceRequestedToJoin : Array[int];

func _ready() -> void:
	inputDeviceRequestedToJoin = [];
	LobbyManager.Lobby.PlayerJoinAccepted.connect(PlayerJoinAccepted);
	pass;
	
func _exit_tree() -> void:
	if(LobbyManager.Lobby):
		LobbyManager.Lobby.PlayerJoinAccepted.disconnect(PlayerJoinAccepted);
	
@rpc("any_peer", "call_remote")
func RequestPlayerJoin(clientId : int, inputDevice : int):
	if(LobbyManager.Lobby.CanPlayerJoin()):
		var spawnParams = {"playerNumber": LobbyManager.Lobby.GetNextAvailablePlayerNumber(), "deviceId": inputDevice};
		GameNetManager.GameNet.netObjectManager.SpawnNetObjectWithOwnerId(playerTokenPath, spawnParams, clientId);
	else:
		rpc_id(clientId, 'PlayerJoinRejected', inputDevice);
		pass;
	pass;

func PlayerJoinAccepted(playerToken : PlayerToken):
	if(playerToken.originalOwnerId == Network.myId):
		inputDeviceRequestedToJoin.erase(playerToken.deviceId);
	pass;
	
@rpc("authority", "call_local")
func PlayerJoinRejected(inputDevice : int):
	Network.Log("Player join rejected!");
	inputDeviceRequestedToJoin.erase(inputDevice);
	pass;

@rpc("any_peer", "call_remote")
func RequestPlayerLeave(playerNumber : int, clientId : int, inputDevice : int):
	if(LobbyManager.Lobby.CanPlayerLeave()):
		Network.LogStr("Request player leave: ", playerNumber);
		var playerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(playerToken.id);
	pass;

func _process(delta: float) -> void:
	CheckInputJoin(InputManager.keyboardMouseInput);
	for joypadDevice : InputDeviceJoypad in InputManager.joypadDevices.values():
		CheckInputJoin(joypadDevice);
		
	for playerToken in LobbyManager.Lobby.playerTokens:
		if(playerToken.originalOwnerId == Network.myId):
			if(playerToken.inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.Leave)):
				if(Network.currentLobby.isHost):
					RequestPlayerLeave(playerToken.playerNumber, playerToken.originalOwnerId, playerToken.deviceId);
				else:
					rpc_id(1, 'RequestPlayerLeave', playerToken.playerNumber, playerToken.originalOwnerId, playerToken.deviceId);
	
	pass;
	
func CheckInputJoin(inputDevice : InputDevice):
	if(inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.Join)):
		if(!inputDeviceRequestedToJoin.has(inputDevice.device)):
			if(!LobbyManager.Lobby.HasLocalPlayerWithInputDevice(inputDevice)):
				inputDeviceRequestedToJoin.push_back(inputDevice.device)
				if(Network.currentLobby.isHost):
					RequestPlayerJoin(Network.myId, inputDevice.device);
				else:
					rpc_id(1, 'RequestPlayerJoin', Network.myId, inputDevice.device);
				pass;
			pass;
		pass;
	pass;
