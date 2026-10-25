extends BallState
class_name Block

@export var cooldown : Cooldown;

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartBlockVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopBlockVisual();

func ExitStatePhysics():
	cooldown.Restart();

func ProcessPhysics(delta : float):
	super(delta);
	mcc.staminaStat.Process(delta * mcc.traits.blockStaminaSpeedBoost);
	
	var decel = lerp(mcc.traits.blockDecelMin, mcc.traits.blockDecelMax, mcc.currentSpeed/mcc.traits.blockDecelMaxSpeed);
	
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, decel * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, decel * delta)
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	pass;
