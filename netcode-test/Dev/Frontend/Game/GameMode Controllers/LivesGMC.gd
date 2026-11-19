extends GameModeController
class_name LivesGMC

@export var clockDisplay : ClockDisplay;

var maxTime : float = 60;
var timeIsUp : bool = false;
var infiniteTime : bool = false;

func _ready() -> void:
	if(LobbyManager.Lobby):
		SetGameModeRules();
		GameManager.Manager.GameModeRulesAreSet();
		
func SetGameModeRules():
	if(LobbyManager.Lobby):
		GameManager.Manager.infiniteLives = LobbyManager.Lobby.matchOptions[Enums.MatchOption.InfiniteLives];
		GameManager.Manager.numLives = LobbyManager.Lobby.matchOptions[Enums.MatchOption.NumLives];
		
		infiniteTime = LobbyManager.Lobby.matchOptions[Enums.MatchOption.InfiniteTime];
		if(!infiniteTime):
			maxTime = LobbyManager.Lobby.matchOptions[Enums.MatchOption.TimeLength];
			clockDisplay.visible = true;
		else:
			clockDisplay.visible = false;

func OnElimination(activator : int, victim : int):
	if(timeIsUp || GameManager.Manager.gameFinished):
		return;
		
	var victimBall : BallMCC = GameManager.Manager.balls[victim].ballController;
	if(victimBall.updatePhysics):
		victimBall.score = GameManager.Manager.gameModeController.gameTime;
		
	var numAlive = 0;
	
	for netBall : NetBall in GameManager.Manager.balls.values():
		var controller = netBall.ballController;
		if(!controller.eliminated && controller.playerNumber != victim):
			if(controller.updatePhysics):
				controller.score = INT64_MAX;
			numAlive += 1;
		
	if(Network.currentLobby.isHost):
		if(numAlive <= 1):
			GameManager.Manager.FinishGame.rpc();
		
	pass;

@rpc("authority", "call_local")
func TimeUp():
	timeIsUp = true;
	for netBall : NetBall in GameManager.Manager.balls.values():
		var controller = netBall.ballController;
		if(!controller.eliminated && controller.updatePhysics):
			controller.score = maxTime + 10.0 + controller.lives;
	pass;


func _process(delta: float) -> void:
	if(!infiniteTime):
		if(!GameManager.Manager.gameFinished):
			clockDisplay.DisplayTime(max(maxTime - gameTime, 0));
			if(!timeIsUp && gameTime >= maxTime):
				timeIsUp = true;
				if(Network.currentLobby && Network.currentLobby.isHost):
					GameManager.Manager.FinishGame.rpc();
					TimeUp.rpc();
		
func OnResultsShown():
	clockDisplay.visible = false;
	pass;
