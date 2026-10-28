extends BallState
class_name Clash

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartClashVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopClashVisual();
	
func StartStatePhysics(params : Dictionary = {}):
	mcc.GetPhysics().BounceVelocity(-mcc.currentDirection, mcc.currentSpeed, mcc.traits.clashBounceTraits);
	mcc.clash = false;
	
func ExitStatePhysics(params : Dictionary = {}):
	mcc.clash = false;

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.clashDeceleration);
	mcc.GetPhysics().MoveAndCollide(delta);
	mcc.GetPhysics().CheckDeflectRegion(delta);
