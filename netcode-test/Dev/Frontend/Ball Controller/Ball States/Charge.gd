extends BallState
class_name Charge

var chargeDirection := Vector3.DOWN;
var chargeAmount : float;

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartChargeVisual();

func ExitStateVisuals():
	mcc.visuals.StopChargeVisual();
	mcc.visuals.ChargeStretchBall(0.0);
	pass;
	
func ExitStatePhysics():
	exitPhysicsParams.set('direction', chargeDirection)
	var speed = lerp(mcc.traits.minLaunchSpeed, mcc.traits.maxLaunchSpeed, chargeAmount)
	exitPhysicsParams.set('speed', speed);
	
func Process(delta : float):
	super(delta);
	var inputLength = mcc.requestedMoveDirection.length();
	chargeDirection.x = mcc.requestedMoveDirection.x;
	chargeDirection.y = lerp(-1.0, mcc.traits.chargeDirectionMaxY, inputLength);
	chargeDirection.z = mcc.requestedMoveDirection.z;
	chargeAmount = clamp(timeInState / mcc.traits.timeTilMaxCharge, 0.0, 1.0);
	
func ProcessVisuals(delta : float):
	mcc.visuals.RollBall(chargeAmount * mcc.visuals.profile.maxChargeRollSpeed, delta);
	mcc.visuals.ChargeStretchBall(chargeAmount);
	mcc.visuals.FaceDirection(chargeDirection);
	pass;

func ProcessPhysics(delta : float):
	super(delta);
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.chargeDeceleration * delta)
	mcc.velocity.y = move_toward(mcc.velocity.y, 0, mcc.traits.chargeDeceleration * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.chargeDeceleration * delta)
	mcc.move_and_slide();
	pass;
