extends BallState
class_name Respawning

func StartState(params : Dictionary = {}):
	super(params);
	mcc.interactive = false;
	mcc.knockedOut = true;
	mcc.invulnStat.value = 1.0;
	
func StartStatePhysics(params : Dictionary = {}):
	super(params);
	mcc.healthStat.Reset();

func StartStateVisuals(params : Dictionary = {}):
	super(params);
	mcc.visuals.ShowBall();
	mcc.visuals.ShowRespawningMessage();
	mcc.visuals.ballHubElement.ShowRespawning();

func ExitState():
	mcc.knockedOut = false;
	mcc.interactive = true;
	
func ExitStateVisuals():
	mcc.visuals.HideMessages();
	mcc.visuals.ballHubElement.ShowAlive();
	
func ExitStatePhysics():
	mcc.grabCooldown.Restart();
	mcc.strikeCooldown.Restart();
	mcc.chargeCooldown.Restart();
	mcc.jumpCooldown.Restart();
	mcc.blockCooldown.Restart();
	mcc.autoAimCooldown = 0;
	
func ProcessVisuals(delta : float):
	super(delta);
	mcc.visuals.UpdateRespawnClock(mcc.respawnTimer);
	mcc.visuals.ballHubElement.UpdateRespawnClock(mcc.respawnTimer);
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.invulnStat.value = 1.0;
	mcc.respawnTimer = move_toward(mcc.respawnTimer, 0, delta);
	pass;
