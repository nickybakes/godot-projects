extends BallState
class_name Block

@export var cooldown : Cooldown;
@export var removeBlockCooldown : Cooldown;

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartBlockVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopBlockVisual();
	
func StartStatePhysics(params : Dictionary = {}):
	removeBlockCooldown.Restart();
	mcc.blocking = true;
	pass;

func ExitStatePhysics():
	mcc.blocking = false;
	cooldown.Restart();
	
func ExitState():
	super();
	mcc.blocking = false;

func ProcessPhysics(delta : float):
	super(delta);
	
	if(mcc.successfulBlock):
		removeBlockCooldown.Restart();
		mcc.successfulBlock = false;
	
	mcc.staminaStat.Process(delta * mcc.traits.blockStaminaSpeedBoost);
	
	var decel = lerp(mcc.traits.blockDecelMin, mcc.traits.blockDecelMax, mcc.currentSpeed/mcc.traits.blockDecelMaxSpeed);
	
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, decel * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, decel * delta)
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
	pass;
