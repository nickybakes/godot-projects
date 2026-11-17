extends Node
class_name GameManager

static var Manager : GameManager;

var ballPrefabPath := "uid://2rolpfky2ye3";

var balls : Dictionary[int, NetBall];

@export var gameModeControllersDict : Dictionary[Enums.GameMode, String];

var gameModeController : GameModeController;

var gameMechanics : Array[GameMechanic];


func _ready() -> void:
	Manager = self;
	gameMechanics = [];
	if(Network.currentLobby.isHost):
		SpawnPlayerBalls();
		#SpawnGameModeController();
		
		
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
	#if(gameModeController):
		#GameNetManager.GameNet.netObjectManager.DestroyNetObject(gameModeController.id);
	#GameManager.Manager.DestroyAllGameMechanics();
	GameManager.Manager.DestroyAllBalls();
	GameNetManager.GameNet.netSceneManager.SwitchScene(SceneManager.SCENE.LobbyScene);
	pass;

func SpawnGameModeController():
	if(LobbyManager.Lobby):
		var gameMode = LobbyManager.Lobby.matchOptions[Enums.MatchOption.GameMode] as Enums.GameMode;
		if(gameMode == Enums.GameMode.Random):
			gameMode = randi_range(0, Enums.GameMode.size() - 2) as Enums.GameMode;
		var path = gameModeControllersDict[gameMode];
		GameNetManager.GameNet.netObjectManager.SpawnNetObject(path, {}, true);
	pass;

func SpawnPlayerBalls():
	if(LobbyManager.Lobby):
		var tokenArray : Array[PlayerToken] = LobbyManager.Lobby.playerTokens.duplicate();
		var totalPlayers = tokenArray.size();
		for tokenNum in totalPlayers:
			var pickedPlayerToken : PlayerToken = tokenArray.pick_random();
			tokenArray.erase(pickedPlayerToken);
			var ballPosition = GameSceneSetup.GSS.GetSpawnPosition(tokenNum + 1, totalPlayers);
			var spawnParams = {"playerNumber": pickedPlayerToken.playerNumber, "position": ballPosition, "velocity": Vector3.ZERO, "lives": 6};
			GameNetManager.GameNet.netObjectManager.SpawnNetObjectWithOwnerId(ballPrefabPath, spawnParams, pickedPlayerToken.ownerId);
			pass;
	pass;


func BallAdded(playerNumber : int, ball : NetBall):
	balls.set(playerNumber, ball);
	GamerView.View.hub.SpawnElement(playerNumber);
	
func BallRemoved(playerNumber : int):
	balls.erase(playerNumber);

func DestroyAllGameMechanics():
	for gameMechanic in gameMechanics:
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(gameMechanic.id);
	pass;
	
func DestroyAllBalls():
	for playerNumber in balls.keys():
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(balls[playerNumber].id);
	pass;
