extends BallState
class_name Block

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartBlockVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopBlockVisual();
	
func StartStatePhysics(params : Dictionary = {}):
	mcc.removeBlockCooldown.Restart();
	mcc.blocking = true;
	pass;

func ExitStatePhysics():
	mcc.blocking = false;
	mcc.blockCooldown.Restart();
	
func ExitState():
	super();
	mcc.blocking = false;

func ProcessPhysics(delta : float):
	super(delta);
	
	if(mcc.successfulBlock):
		mcc.removeBlockCooldown.Restart();
		mcc.successfulBlock = false;
	
	mcc.staminaStat.Process(delta * mcc.traits.blockStaminaSpeedBoost);
	
	var decel = lerp(mcc.traits.blockDecelMin, mcc.traits.blockDecelMax, mcc.currentSpeed/mcc.traits.blockDecelMaxSpeed);
	
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, decel * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, decel * delta)
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
	pass;
