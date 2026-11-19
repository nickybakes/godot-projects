extends GameModeController
class_name SpotlightGMC

@export var spotlightMechanicUID : String;
@export var clockDisplay : ClockDisplay;

var maxTime : float = 60;
var timeIsUp : bool = false;
var infiniteScore : bool = true;
var maxScore : int = 10;

func _ready() -> void:
	if(LobbyManager.Lobby):
		GameManager.Manager.infiniteLives = true;
		infiniteScore = LobbyManager.Lobby.matchOptions[Enums.MatchOption.InfiniteScore];
		maxScore = LobbyManager.Lobby.matchOptions[Enums.MatchOption.ScoreLimit];
		maxTime = LobbyManager.Lobby.matchOptions[Enums.MatchOption.TimeLength];
		if(Network.currentLobby && Network.currentLobby.isHost):
			GameNetManager.GameNet.netObjectManager.SpawnNetObject(spotlightMechanicUID, {}, true);
		GameManager.Manager.GameModeRulesAreSet();

func _process(delta: float) -> void:
	if(!GameManager.Manager.gameFinished):
		clockDisplay.DisplayTime(max(maxTime - gameTime, 0));
		if(!timeIsUp && gameTime >= maxTime):
			timeIsUp = true;
			if(Network.currentLobby && Network.currentLobby.isHost):
				GameManager.Manager.FinishGame.rpc();
		elif(Network.currentLobby && Network.currentLobby.isHost && !infiniteScore):
			if(GameManager.Manager):
				for netBall : NetBall in GameManager.Manager.balls.values():
					var ballController : BallMCC = netBall.ballController;
					if(ballController.score > maxScore):
						timeIsUp = true;
						GameManager.Manager.FinishGame.rpc();
		
func OnResultsShown():
	clockDisplay.visible = false;
	pass;
