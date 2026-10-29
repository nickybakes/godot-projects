extends BallState
class_name GrabFail

@export var cooldown : Cooldown;

func StartStatePhysics(params : Dictionary = {}):
	pass;
	
func ExitStatePhysics():
	cooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.grabFailDeceleration);
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
