extends MCCPhysics
class_name BallPhysics

var mcc : BallMCC;

const MAX_ANGLE = PI * .5;
var onSurface := false;

var collision : KinematicCollision3D;

func MoveAndCollide(delta : float):
	var collided = mcc.move_and_slide();
	onSurface = collided;
	if(collided):
		collision = mcc.get_last_slide_collision();
		mcc.velocity = mcc.velocity.slide(collision.get_normal());
	pass;
	
func JustOffSurface():
	pass;

func ProcessPhysics(delta : float, params : Dictionary = {}):
	MoveAndCollide(delta);
	pass;
	
func GetSteepness() -> float:
	if(onSurface):
		return collision.get_angle() / MAX_ANGLE;
	else:
		return 0.0;

func Gravity(delta : float):
	if(onSurface):
		mcc.velocity.y -= mcc.traits.gravity * delta * GetSteepness();
	else:
		if(mcc.velocity.y > 0):
			mcc.velocity.y -= mcc.traits.gravity * delta
		else:
			mcc.velocity.y -= mcc.traits.gravity * mcc.traits.gravityFallMultiplier * delta
			

func Decelerate(delta : float):
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.deceleration * delta);
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.deceleration * delta);

func MovementControl(delta : float):
	var controlSurfacePower = 1.0 - GetSteepness();
	
	if mcc.requestedMoveDirection:
		mcc.velocity.x = move_toward(mcc.velocity.x, mcc.requestedMoveDirection.x * mcc.traits.moveSpeed, mcc.traits.moveControl * controlSurfacePower * delta);
		mcc.velocity.z = move_toward(mcc.velocity.z, mcc.requestedMoveDirection.z * mcc.traits.moveSpeed, mcc.traits.moveControl * controlSurfacePower * delta);
