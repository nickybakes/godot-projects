extends BallState
class_name GrabVictim

@export var cooldown : Cooldown;

var parentIsDoneGrabbing;

var currentDirection : Vector3;
var currentSpeed : float;


func StartState(params : Dictionary = {}):
	super(params);
	mcc.interactive = false;
	parentIsDoneGrabbing = false;
	currentSpeed = 0;
	currentDirection = Vector3.UP;
	
func ExitState():
	super();
	
	mcc.interactive = true;
	mcc.invulnStat.Add(1.0);
	cooldown.Restart();
	parentIsDoneGrabbing = false;
	
func ExitStatePhysics():
	mcc.global_position = mcc.grabParent.global_position;
	mcc.global_position.y += mcc.traits.grabVictimVerticalOffset;
	mcc.TakeDamageFromGrab(mcc.grabParent, mcc.grabParentFire);
	
	var bounceDirection = currentDirection;
	bounceDirection.y *= -1.0;
	var angleDirection = GetTopDownVictimDirection();
	angleDirection *= mcc.traits.grabVictimBounceAnglePower;
	bounceDirection.x = lerp(bounceDirection.x, angleDirection.x, mcc.traits.grabVictimBounceAngleMix);
	bounceDirection.z = lerp(bounceDirection.z, angleDirection.z, mcc.traits.grabVictimBounceAngleMix);
	mcc.GetPhysics().BounceVelocity(bounceDirection, currentSpeed, mcc.traits.grabVictimBounce);
	exitPhysicsParams['velocity'] = mcc.velocity;

	pass;
	
func ProcessVisuals(delta : float):
	super(delta);
	if(mcc.grabParent):
		mcc.global_position = lerp(mcc.global_position, mcc.grabParent.global_position + GetVictimOffset(), .5);

func ProcessPhysics(delta : float):
	super(delta);
	
	mcc.velocity = mcc.grabParent.velocity;
	mcc.global_position = lerp(mcc.global_position, mcc.grabParent.global_position + GetVictimOffset(), .5);
	#mcc.GetPhysics().MoveAndCollide(delta);
	
	parentIsDoneGrabbing = mcc.grabParent.currentState is not GrabSuccess;
		
	if(!mcc.grabParent.GetPhysics().onSurface && !parentIsDoneGrabbing && currentSpeed < mcc.currentSpeed):
		currentDirection = mcc.currentDirection;
		currentSpeed = mcc.currentSpeed;
	
func GetVictimOffset() -> Vector3:
	var offset = Vector3.ZERO;
	offset.y = mcc.traits.grabVictimVerticalOffset;
	
	var direction = GetTopDownVictimDirection();
	offset.x = (direction.x * mcc.traits.grabVictimTopDownOffset);
	offset.z = (direction.z * mcc.traits.grabVictimTopDownOffset);
	
	return offset
	pass;
	
func GetTopDownVictimDirection() -> Vector3:
	var posOnCircle = (mcc.grabVictimAngleOffset + (mcc.grabVictimIndex as float / mcc.grabVictimTotal as float)) * PI * 2;
	var direction = Vector3.ZERO;
	direction.x = cos(posOnCircle);
	direction.z = sin(posOnCircle);
	return direction;
	
