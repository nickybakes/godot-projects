extends Control
class_name LobbyView

@onready var insideLobbyHost: Control = $"Inside Lobby Host"
@onready var insideLobbyMember: Control = $"Inside Lobby Member"
@onready var insideLobby: Control = $"Inside Lobby"

var gameStarted := false;


func _ready():
	if(Network.currentLobby.isHost):
		OnHostSuccess();
	else:
		OnJoinSuccess();
		
func _process(delta: float) -> void:
	CheckForStartGameInput();
	pass;
	
	
func CheckForStartGameInput():
	if(LobbyManager.Lobby):
		for playerToken in LobbyManager.Lobby.playerTokens:
			if(playerToken.inputDevice):
				if(playerToken.inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.StartGame)):
					if(Network.currentLobby.isHost):
						RequestStartGame();
					else:
						rpc_id(1, 'RequestStartGame');
					pass;
	pass;
	
@rpc("any_peer", "call_remote")
func RequestStartGame():
	if(!gameStarted):
		gameStarted = true;
		CursorManager.Manager.DestroyAllCursors();
		GameNetManager.GameNet.netSceneManager.SwitchScene(SceneManager.SCENE.ArenaScene_01);
	pass;
	
func OnHostSuccess():
	insideLobbyHost.visible = true;
	insideLobbyMember.visible = false;
	insideLobby.visible = true;
	pass;
	
func OnJoinSuccess():
	insideLobbyHost.visible = false;
	insideLobbyMember.visible = true;
	insideLobby.visible = true;
	pass;

func stopHostButton():
	Network.DisconnectFromServer();
	
func leaveLobbyButton():
	Network.DisconnectFromServer();
	
const PRE_NET_BALL_01 = "uid://oq33tksc2sxh";
	
func spawnBallButton():
	var ballPosition = Vector3(randf() * 6 - 3, randf() * 5 - 2.5, -5);
	var spawnParams = {"position": ballPosition, "rotation": Vector3.ZERO, "scale": Vector3.ONE, "visible": true};
	GameNetManager.GameNet.netObjectManager.SpawnNetObject(PRE_NET_BALL_01, spawnParams, true);
	pass;
