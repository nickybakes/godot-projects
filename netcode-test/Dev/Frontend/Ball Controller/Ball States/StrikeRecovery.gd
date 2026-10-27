extends BallState
class_name StrikeRecovery

@export var cooldown : Cooldown;

func ExitStatePhysics():
	cooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.strikeActivatorDeceleration * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.strikeActivatorDeceleration * delta)
	mcc.currentPhysics.CheckDeflectRegion(delta);
