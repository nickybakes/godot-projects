extends BallState
class_name GrabSuccess

@export var cooldown : Cooldown;

var aimDirection := Vector3.DOWN;
var visualDirection := Vector3.DOWN;

var aiming : bool;

var currentDirection : Vector3;
var currentSpeed : float;


func StartState(params : Dictionary = {}):
	super(params);

	mcc.interactive = false;
	aiming = true;
	currentSpeed = 0;
	currentDirection = Vector3.UP;
	
func ExitState():
	super();
	mcc.interactive = true;

func StartStatePhysics(params : Dictionary = {}):
	mcc.GetPhysics().ResetSurface();
	pass;
	
func ExitStatePhysics():
	cooldown.Restart();
	var bounceDirection = currentDirection;
	bounceDirection.y *= -1.0;
	mcc.GetPhysics().BounceVelocity(bounceDirection, currentSpeed, mcc.traits.grabSuccessBounce);
	exitPhysicsParams['velocity'] = mcc.velocity;
	
func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartGrabSuccessAimVisual();
	
func Process(delta : float):
	super(delta);
	if(timeInState < mcc.traits.grabAimingTime):
		var inputLength = mcc.requestedMoveDirection.length();
		var topDownScalar = 1.0 - abs(mcc.traits.grabDirectionMaxY);
		aimDirection.x = mcc.requestedMoveDirection.x * topDownScalar;
		aimDirection.y = lerp(-1.0, mcc.traits.grabDirectionMaxY, inputLength);
		aimDirection.z = mcc.requestedMoveDirection.z * topDownScalar;
		aimDirection = aimDirection.normalized();
		
		visualDirection = aimDirection;
		visualDirection.x *= mcc.visuals.profile.grabAimTopDownAngleScalar;
		visualDirection.z *= mcc.visuals.profile.grabAimTopDownAngleScalar;
		visualDirection = visualDirection.normalized();
		
	elif(aiming):
		aiming = false;
		mcc.visuals.StopGrabSuccessAimVisual();
			
func ProcessVisuals(delta : float):
	mcc.visuals.FaceDirection(visualDirection, delta);
	mcc.visuals.SpeedStretch(mcc.currentSpeed);
	pass;

func ProcessPhysics(delta : float):
	super(delta);
	
	var speed = mcc.traits.grabVerticalSpeedOverTime.sample(timeInState);
	var aimPower = mcc.traits.grabAimPowerOverTime.sample(timeInState);
	
	var direction = Vector3.UP.lerp(-aimDirection, aimPower);
	
	mcc.velocity = speed * direction;
	
	if(!mcc.GetPhysics().onSurface):
		currentDirection = mcc.currentDirection;
		currentSpeed = mcc.currentSpeed;
	
	mcc.GetPhysics().MoveAndCollide(delta);
