extends MCCPhysics
class_name BallPhysics

var mcc : BallMCC;

const MAX_ANGLE = PI * .5;
var onSurface := false;

var collision : KinematicCollision3D;
var currentSurfaceNormal := Vector3.UP;
var collisionDotProduct : float;
var collisionReflection : Vector3;

var isDeflect : bool;
var isStrikeAttempt : bool;

var timeSinceBasicBounce : float = 5.0;

func MoveAndCollide(delta : float):
	var collided = mcc.move_and_slide();
	if(collided):
		collision = mcc.get_last_slide_collision();
		
		var isBasicBounce = false;
		if(collision.get_normal() != currentSurfaceNormal || !onSurface):
			currentSurfaceNormal = collision.get_normal();
			collisionDotProduct = abs(mcc.currentDirection.dot(collision.get_normal()));
			collisionReflection = mcc.currentDirection.bounce(collision.get_normal());
			if(collisionDotProduct > mcc.traits.basicBounceMinDotProduct && mcc.currentSpeed >= mcc.traits.basicBounceMinSpeed):
				var scalar = Vector3(mcc.traits.basicBounceTopDownSpeedScalar, mcc.traits.basicBounceVerticalSpeedScalar, mcc.traits.basicBounceTopDownSpeedScalar)
				if(mcc.blocking):
					scalar.y *= mcc.traits.blockVerticalBounceDamp;
				mcc.velocity = collisionReflection * mcc.currentSpeed * scalar;
				timeSinceBasicBounce = 0.0;
				isBasicBounce = true;
		
		if(!isBasicBounce):
			mcc.velocity = mcc.velocity.slide(collision.get_normal());
	
	onSurface = collided;
	pass;
	
func ResetSurface():
	onSurface = false;
	collision = null;
	currentSurfaceNormal = Vector3.UP;
	collisionDotProduct = 0;
	collisionReflection = Vector3.ZERO;

func ProcessPhysics(delta : float, params : Dictionary = {}):
	Gravity(delta);
	MoveAndCollide(delta);
	DecelerateTopDown(delta);
	MovementControl(delta);
	CheckStrikeRegion(delta);
	CheckDeflectRegion(delta);
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
			

func DecelerateTopDown(delta : float, deceleration : float = mcc.traits.deceleration):
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, deceleration * delta);
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, deceleration * delta);
	
func _physics_process(delta: float) -> void:
	timeSinceBasicBounce += delta;
	
func CheckDeflectRegion(delta : float) -> void:
	isDeflect = false;
	
	if(mcc.deflectRegion.numBallsInside >= 1):
		isDeflect = true;
	pass;
	
	
func CheckStrikeRegion(delta : float) -> void:
	isStrikeAttempt = false;
	
	if(mcc.strikeRegion.numBallsInside >= 1):
		if(mcc.currentSpeed >= mcc.traits.minRequiredStrikeSpeed && mcc.fireStat.value > mcc.traits.minRequiredFireForStrike):
			isStrikeAttempt = true;
	pass;

func MovementControl(delta : float):
	var controlSurfacePower = 1.0 - GetSteepness();
	var basicBounceControlDamp = mcc.traits.basicBounceMoveControlCooldown.sample(timeSinceBasicBounce);
	
	var moveControl = mcc.traits.moveControl * basicBounceControlDamp;
	var moveSpeed = mcc.traits.moveSpeed;
	
	if mcc.requestedMoveDirection:
		if(mcc.currentTopDownSpeed > mcc.traits.overSpeedThreshold):
			var topDownDirection := mcc.currentTopDownDirection3D;
			var normalizedRequestedDirection = mcc.requestedMoveDirection.normalized();

			var angle = topDownDirection.signed_angle_to(normalizedRequestedDirection, Vector3.UP);
			
			var newVel = mcc.velocity.rotated(Vector3.UP, angle * delta * mcc.traits.overSpeedLimitDirectionalControl * basicBounceControlDamp);
			mcc.velocity = newVel;
			moveControl = mcc.traits.overSpeedMoveControl;
			moveSpeed = mcc.currentTopDownSpeed;
			moveSpeed = move_toward(moveSpeed, mcc.traits.moveSpeed, mcc.traits.overSpeedDeceleration * delta);
			pass;
		
		mcc.velocity.x = move_toward(mcc.velocity.x, mcc.requestedMoveDirection.x * moveSpeed, moveControl * controlSurfacePower * delta);
		mcc.velocity.z = move_toward(mcc.velocity.z, mcc.requestedMoveDirection.z * moveSpeed, moveControl * controlSurfacePower * delta);
	

func BounceVelocity(newDirection : Vector3):
	pass;
