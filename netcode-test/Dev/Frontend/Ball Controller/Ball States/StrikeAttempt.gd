extends BallState
class_name StrikeAttempt

var victims : Array[BallMCC];

@export var cooldown : Cooldown;

func StartStatePhysics(params : Dictionary = {}):
	cooldown.Restart();
	
	mcc.currentPhysics.isStrikeAttempt = false;
	mcc.currentPhysics.isDeflect = false;

	victims = [];
	
	for i in min(mcc.strikeRegion.ballsInsideThisRegion.size(), mcc.traits.maxNumOfStrikedBalls):
		var hitBall = mcc.strikeRegion.ballsInsideThisRegion[i];
		victims.push_back(hitBall);
		
	InteractionManager.Manager.SendInteraction(InteractionCreator.NewStrikeAttempt(mcc, victims));
	pass;
	
func ExitStatePhysics():
	exitPhysicsParams.set('victims', victims);
	cooldown.Restart();
	mcc.currentPhysics.isStrikeAttempt = false;
	mcc.currentPhysics.isDeflect = false;
	mcc.clash = false;

func ProcessPhysics(delta : float):
	super(delta);
