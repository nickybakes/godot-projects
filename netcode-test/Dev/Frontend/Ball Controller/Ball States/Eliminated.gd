extends BallState
class_name Eliminated

func StartState(params : Dictionary = {}):
	super(params);
	mcc.interactive = false;
	mcc.eliminated = true;
	
func StartStatePhysics(params : Dictionary = {}):
	super(params);
	GameManager.Manager.LogElimination.rpc(mcc.mostRecentDamageDealerId, mcc.playerNumber);
	
func StartStateVisuals(params : Dictionary = {}):
	super(params);
	mcc.visuals.HideBall();
	mcc.visuals.ShowEliminatedMessage();
	mcc.visuals.ballHubElement.ShowEliminated();
	mcc.visuals.cameraTarget.goalStrength = 0;
	mcc.visuals.cameraTarget.strength = 2.5;
	CameraManager.CM.shaker.Shake(mcc.visuals.profile.eliminationCameraShake);

func ExitState():
	mcc.interactive = true;
	
func ExitStateVisuals():
	mcc.visuals.ShowBall();
	mcc.visuals.ballHubElement.ShowAlive();
