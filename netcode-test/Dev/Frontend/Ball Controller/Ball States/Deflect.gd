extends BallState
class_name Deflect

func StartStatePhysics(params : Dictionary = {}):
	mcc.currentPhysics.isDeflect = false;
	
	if(mcc.deflectRegion.numBallsInside >= 1):
		var hitBall = mcc.deflectRegion.ballsInsideThisRegion[0];
		var newVelocity = mcc.global_position - hitBall.global_position;
		newVelocity = newVelocity.normalized();
		newVelocity *= max(mcc.traits.minDeflectBounceSpeed, mcc.currentSpeed);
		var scalar = Vector3(mcc.traits.deflectTopDownSpeedScalar, mcc.traits.deflectVerticalSpeedScalar, mcc.traits.deflectTopDownSpeedScalar)
		mcc.velocity = newVelocity * scalar;
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.ProcessPhysics(delta);

func ExitStatePhysics():
	super();
	mcc.currentPhysics.isDeflect = false;
	
