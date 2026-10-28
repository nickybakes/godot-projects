extends BallState
class_name Deflect

func StartStatePhysics(params : Dictionary = {}):
	mcc.GetPhysics().isDeflect = false;
	
	if(mcc.deflectRegion.numBallsInside >= 1):
		var hitBall = mcc.deflectRegion.ballsInsideThisRegion[0];
		var direction = (mcc.global_position - hitBall.global_position).normalized();
		mcc.GetPhysics().BounceVelocity(direction, mcc.currentSpeed, mcc.traits.deflectBounceTraits);
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().ProcessPhysics(delta);

func ExitStatePhysics():
	super();
	mcc.GetPhysics().isDeflect = false;
	
