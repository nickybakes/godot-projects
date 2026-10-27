extends BallState
class_name StrikeRecovery

@export var cooldown : Cooldown;

func ExitStatePhysics():
	cooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	mcc.currentPhysics.DecelerateTopDown(delta, mcc.traits.strikeActivatorDeceleration);
	mcc.currentPhysics.CheckDeflectRegion(delta);
