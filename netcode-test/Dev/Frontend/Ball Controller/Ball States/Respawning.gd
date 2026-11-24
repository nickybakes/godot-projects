extends BallState
class_name Respawning

var endPosition : Vector3;
var startPosition : Vector3;
var direction : Vector3;
var prevPos : Vector3;

func StartState(params : Dictionary = {}):
	super(params);
	mcc.interactive = false;
	mcc.knockedOut = true;
	mcc.invulnStat.value = 1.0;
	
func StartStatePhysics(params : Dictionary = {}):
	super(params);
	mcc.healthStat.Reset();
	mcc.velocity = Vector3.ZERO;
	startPosition = mcc.global_position;
	prevPos = startPosition;
	endPosition = GameSceneSetup.GSS.GetRandomSpawnPointPosition();
	direction = (endPosition - startPosition).normalized();

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
	if(mcc.lives <= 1):
		mcc.visuals.ShowLastBallMessage();
	
func ExitStatePhysics():
	mcc.grabCooldown.Restart();
	mcc.strikeCooldown.Restart();
	mcc.chargeCooldown.Restart();
	mcc.jumpCooldown.Restart();
	mcc.blockCooldown.Restart();
	mcc.mostRecentDamageDealerId = -1;
	mcc.autoAimCooldown = 0;
	mcc.velocity = Vector3.ZERO;
	
func ProcessVisuals(delta : float):
	super(delta);
	mcc.visuals.UpdateRespawnClock(mcc.respawnTimer);
	mcc.visuals.ballHubElement.UpdateRespawnClock(mcc.respawnTimer);
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.invulnStat.value = 1.0;
	mcc.respawnTimer = move_toward(mcc.respawnTimer, 0, delta);
	
	var t = 1.0 - (mcc.respawnTimer/(mcc.traits.respawnTime - mcc.traits.knockedOutTime));
	var easeT = ease(t, mcc.visuals.profile.respawnMovementEase);
	mcc.global_position = lerp(startPosition, endPosition, easeT);
	
	var speed = (mcc.global_position - prevPos).length() / delta;
	speed *= mcc.visuals.profile.respawnSpeedScale;
	
	mcc.velocity = direction * speed;
	
	prevPos = mcc.global_position;
	pass;
