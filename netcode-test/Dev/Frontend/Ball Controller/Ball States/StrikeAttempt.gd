extends BallState
class_name StrikeAttempt

var victims : Array[BallMCC];
var activatorSpeed : float;

func StartStatePhysics(params : Dictionary = {}):
	mcc.deflectCooldown.Restart();
	mcc.autoAimCooldown = 0;

	mcc.GetPhysics().isStrikeAttempt = false;
	mcc.GetPhysics().isDeflect = false;

	activatorSpeed = mcc.currentSpeed;
	
	victims = [];
	
	if(mcc.strikeRegion.ballsInsideThisRegion.size() == 0):
		mcc.ForceSetState('roll');
		return;
	
	for i in min(mcc.strikeRegion.ballsInsideThisRegion.size(), mcc.traits.maxNumOfStrikedBalls):
		var hitBall = mcc.strikeRegion.ballsInsideThisRegion[i];
		victims.push_back(hitBall);
		
	InteractionManager.Manager.SendInteraction(InteractionCreator.NewStrikeAttempt(mcc, victims));
	pass;
	
func ExitStatePhysics():
	exitPhysicsParams.set('victims', victims);
	exitPhysicsParams.set('activatorSpeed', activatorSpeed);
	mcc.strikeCooldown.Restart();
	mcc.GetPhysics().isStrikeAttempt = false;
	mcc.GetPhysics().isDeflect = false;
	mcc.clash = false;

func ProcessPhysics(delta : float):
	super(delta);
