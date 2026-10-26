extends BallState
class_name Jump

@export var cooldown : Cooldown;

func ExitStatePhysics():
	cooldown.Restart();

func StartStatePhysics(params : Dictionary = {}):
	super(params);
	mcc.velocity.y = mcc.traits.jumpForce;
	mcc.staminaStat.Spend(mcc.traits.jumpInitialStaminaCost);

func ProcessPhysics(delta : float):
	super(delta);
	mcc.velocity.y += mcc.traits.jumpHover * delta;
	mcc.staminaStat.Spend(mcc.traits.jumpHoverStaminaCost * delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	mcc.currentPhysics.DecelerateTopDown(delta);
	mcc.currentPhysics.MovementControl(delta);
	
