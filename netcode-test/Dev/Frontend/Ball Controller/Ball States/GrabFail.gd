extends BallState
class_name GrabFail

func StartStatePhysics(params : Dictionary = {}):
	pass;
	
func ExitStatePhysics():
	mcc.grabCooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.grabFailDeceleration);
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
