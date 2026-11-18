extends BallState
class_name KnockedOut

func StartState(params : Dictionary = {}):
	super(params);
	mcc.interactive = false;
	mcc.knockedOut = true;
	mcc.respawnTimer = mcc.traits.respawnTime;
	
func StartStatePhysics(params : Dictionary = {}):
	super(params);
	mcc.velocity = Vector3.ZERO;
	GameManager.Manager.LogKnockOut.rpc(mcc.mostRecentDamageDealerId, mcc.playerNumber);
	mcc.lives -= 1;
	
func StartStateVisuals(params : Dictionary = {}):
	super(params);
	mcc.visuals.HideBall();
	mcc.visuals.ShowKnockedOutMessage();
	mcc.visuals.ballHubElement.ShowRespawning();
	mcc.visuals.ballHubElement.livesDisplay.Display(mcc.lives);
	CameraManager.CM.shaker.Shake(mcc.visuals.profile.knockedOutCameraShake);
	
func ProcessVisuals(delta : float):
	super(delta);
	mcc.visuals.UpdateRespawnClock(mcc.respawnTimer);
	mcc.visuals.ballHubElement.UpdateRespawnClock(mcc.respawnTimer);
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.respawnTimer = move_toward(mcc.respawnTimer, 0, delta);
	pass;
