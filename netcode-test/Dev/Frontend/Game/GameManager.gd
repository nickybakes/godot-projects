extends Node
class_name GameManager

static var Manager : GameManager;

var ballPrefabPath := "uid://2rolpfky2ye3";

var balls : Dictionary[int, NetBall];


func _ready() -> void:
	Manager = self;
	if(Network.currentLobby.isHost):
		#await get_tree().create_timer(1).timeout;
		SpawnPlayerBalls();
		
		
func _process(delta: float) -> void:
	CheckForEndGameInput();
	pass;
	
	
func CheckForEndGameInput():
	if(LobbyManager.Lobby):
		for playerToken in LobbyManager.Lobby.playerTokens:
			if(playerToken.inputDevice):
				if(playerToken.inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.EndGame)):
					if(Network.currentLobby.isHost):
						RequestEndGame();
					else:
						rpc_id(1, 'RequestEndGame');
					pass;
	pass;
	
@rpc("any_peer", "call_remote")
func RequestEndGame():
	GameManager.Manager.DestroyAllBalls();
	GameNetManager.GameNet.netSceneManager.SwitchScene(SceneManager.SCENE.LobbyScene);
	pass;

func SpawnPlayerBalls():
	if(LobbyManager.Lobby):
		var tokenArray : Array[PlayerToken] = LobbyManager.Lobby.playerTokens.duplicate();
		var totalPlayers = tokenArray.size();
		for tokenNum in totalPlayers:
			var pickedPlayerToken : PlayerToken = tokenArray.pick_random();
			tokenArray.erase(pickedPlayerToken);
			var ballPosition = GameSceneSetup.GSS.GetSpawnPosition(tokenNum + 1, totalPlayers);
			var spawnParams = {"playerNumber": pickedPlayerToken.playerNumber, "position": ballPosition, "velocity": Vector3.ZERO};
			GameNetManager.GameNet.netObjectManager.SpawnNetObjectWithOwnerId(ballPrefabPath, spawnParams, pickedPlayerToken.ownerId);
			pass;
	pass;


func BallAdded(playerNumber : int, ball : NetBall):
	balls.set(playerNumber, ball);
	
func BallRemoved(playerNumber : int):
	balls.erase(playerNumber);
	
func DestroyAllBalls():
	for playerNumber in balls.keys():
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(balls[playerNumber].id);
	pass;
