extends Node
class_name GameManager

static var Manager : GameManager;

var ballPrefabPath := "uid://2rolpfky2ye3";

var balls : Dictionary[int, NetBall];

@export var gameModeControllersDict : Dictionary[Enums.GameMode, String];

var gameModeController : GameModeController;

var gameTime : float;

var gameMechanics : Array[GameMechanic];
var gamePlayerLogs : Dictionary[int, GamePlayerLog] = {};


func _ready() -> void:
	Manager = self;
	gameMechanics = [];
	if(Network.currentLobby.isHost):
		SpawnPlayerBalls();
		SpawnGameModeController();
	else:
		rpc_id(1, "RequestLogSync", Network.myId);
		
		
func _process(delta: float) -> void:
	CheckForEndGameInput();
	
	if(Network.currentLobby.isHost && gameModeController):
		gameTime += delta;
		gameModeController.gameTime = gameTime;
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
	if(gameModeController):
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(gameModeController.id);
	GameManager.Manager.DestroyAllGameMechanics();
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
	
	var newLog = GamePlayerLog.new(playerNumber);
	gamePlayerLogs.set(playerNumber, newLog);
	
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
	
	
@rpc("any_peer", "call_remote")
func RequestLogSync(requesterId : int):
	var logs = [];
	for log : GamePlayerLog in gamePlayerLogs.values():
		logs.push_back(log.GetAsDict());
	rpc_id(requesterId, "AcceptLogSync", logs);
	pass;
	
@rpc("authority", "call_remote")
func AcceptLogSync(logs : Array):
	for log : Dictionary in logs:
		var newLog = GamePlayerLog.new(log["playerNumber"]);
		newLog.ParseDict(log);
		gamePlayerLogs.set(log["playerNumber"], newLog);
	pass;
	
@rpc("any_peer", "call_local")
func LogDamageTaken(activator : int, victim : int, type : Enums.DamageType, amount : float):
	gamePlayerLogs[activator].damageDealtToPlayers[victim] += amount;
	gamePlayerLogs[victim].damageTakenFromPlayers[activator] += amount;
	gameModeController.OnDamageTaken(activator, victim, type, amount);
	pass;

@rpc("any_peer", "call_local")
func LogDamageBlocked(attacker : int, blocker : int, amount : float):
	gamePlayerLogs[blocker].damageIBlockedFromPlayers[attacker] += amount;
	gamePlayerLogs[attacker].damagePlayersBlockedFromMe[blocker] += amount;
	gameModeController.OnDamageBlocked(attacker, blocker, amount);
	pass;
	
@rpc("any_peer", "call_local")
func LogKnockOut(activator : int, victim : int):
	if(activator != -1):
		gamePlayerLogs[activator].knockOutsDealtToPlayers[victim] += 1;
		gamePlayerLogs[victim].knockOutsDealtToMe[activator] += 1;
	gameModeController.OnKnockOut(activator, victim);
	pass;
	
@rpc("any_peer", "call_local")
func LogElimination(activator : int, victim : int):
	if(activator != -1):
		gamePlayerLogs[activator].eliminationsDoneByMe[victim] += 1;
		gamePlayerLogs[victim].eliminatedBy = activator;
	gameModeController.OnElimination(activator, victim);
	pass;
