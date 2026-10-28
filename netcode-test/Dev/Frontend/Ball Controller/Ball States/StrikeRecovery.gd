extends BallState
class_name StrikeRecovery

@export var cooldown : Cooldown;

func ExitStatePhysics():
	cooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
	mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.strikeActivatorDeceleration);
	mcc.GetPhysics().CheckDeflectRegion(delta);
