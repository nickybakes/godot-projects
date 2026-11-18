extends GameModeController
class_name LivesGMC

func OnElimination(activator : int, victim : int):
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
		if(numAlive == 1):
			GameManager.Manager.FinishGame.rpc();
		
	pass;
