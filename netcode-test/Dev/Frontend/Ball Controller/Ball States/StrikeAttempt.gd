extends BallState
class_name StrikeAttempt

var victims : Array[BallMCC];
var activatorSpeed : float;

@export var cooldown : Cooldown;

func StartStatePhysics(params : Dictionary = {}):
	cooldown.Restart();
	
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
	cooldown.Restart();
	mcc.GetPhysics().isStrikeAttempt = false;
	mcc.GetPhysics().isDeflect = false;
	mcc.clash = false;

func ProcessPhysics(delta : float):
	super(delta);
