extends BallState
class_name Charge

func StartStatePhysics(params : Dictionary = {}):
	super(params);

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartChargeVisual();

func ExitStateVisuals():
	mcc.visuals.StopChargeVisual();
	mcc.visuals.ChargeStretchBall(0.0);
	pass;
	
func ProcessVisuals(delta : float):
	mcc.visuals.ChargeStretchBall(clamp(timeInState / mcc.traits.timeTilMaxCharge, 0.0, 1.0));
	pass;

func ProcessPhysics(delta : float):
	super(delta);
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.chargeDeceleration * delta)
	mcc.velocity.y = move_toward(mcc.velocity.y, 0, mcc.traits.chargeDeceleration * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.chargeDeceleration * delta)
	mcc.move_and_slide();
	pass;
