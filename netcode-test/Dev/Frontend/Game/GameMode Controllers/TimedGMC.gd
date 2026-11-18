extends GameModeController
class_name TimedGMC

@export_category("Timed Specific")
@export var clockDisplay : ClockDisplay;

var maxTime : float = 60;
var timeIsUp : bool = false;

func OnKnockOut(activator : int, victim : int):
	if(timeIsUp):
		return;
		
	var activatorBall : BallMCC = GameManager.Manager.balls[activator].ballController;
	if(activatorBall.updatePhysics):
		activatorBall.score += 1;	
		
	if(activatorBall.updateVisuals):
		activatorBall.visuals.ballHubElement.ShowScoreChange(1);
		pass;
		
	var victimBall : BallMCC = GameManager.Manager.balls[victim].ballController;
	if(victimBall.updatePhysics):
		victimBall.score -= 1;
		
	if(victimBall.updateVisuals):
		victimBall.visuals.ballHubElement.ShowScoreChange(-1);
		pass;

func _process(delta: float) -> void:
	clockDisplay.DisplayTime(max(maxTime - gameTime, 0));
	if(!timeIsUp && gameTime >= maxTime):
		timeIsUp = true;
		if(Network.currentLobby && Network.currentLobby.isHost):
			GameManager.Manager.FinishGame.rpc();
		
func OnResultsShown():
	clockDisplay.visible = false;
	pass;
