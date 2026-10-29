@abstract class_name ModularCharacterController extends CharacterBody3D;

@export var statesParent : Node;

@abstract func SetupStates();
@abstract func GetDefaultState() -> MCCState;
@abstract func GetDefaultPhysics() -> MCCPhysics;
@abstract func GetState(index : int) -> MCCState;
@abstract func GetTotalStates() -> int;
@abstract func CalculateRequestedMoveDirection(delta : float);
@abstract func DoStateTransition(nextState : MCCState);
@abstract func DoStateTransitionByIndex(nextStateIndex : int);
@abstract func GetTraits() -> MCCTraits;
@abstract func GetPhysics() -> MCCPhysics;

func ForceSetState(stateCodeName : String):
	for i in GetTotalStates():
		if(GetState(i).codeName == stateCodeName):
			DoStateTransition(GetState(i));
			return;

var updatePhysics := true;
var updateVisuals := true;

var currentPhysics : MCCPhysics;
var inputDevice : InputDevice;

var velocityX : float;
var velocityY : float;
var velocityZ : float;
var requestedMoveDirection : Vector3;
var topDownVelocity : Vector2;
var currentTopDownSpeed : float;
var currentSpeed : float;
var currentTopDownDirection : Vector2;
var currentTopDownDirection3D : Vector3 = Vector3.ZERO;
var currentFacingDirection : Vector3 = Vector3.FORWARD;
var lastNonZeroTopDownDirection3D : Vector3 = Vector3.FORWARD;
var currentDirection : Vector3;

func CalculateBasicStats(delta : float):
	CalculateRequestedMoveDirection(delta);
		
	currentSpeed = velocity.length();
	velocityX = velocity.x;
	velocityY = velocity.y;
	velocityZ = velocity.z;
	
	if(is_zero_approx(currentSpeed)):
		currentDirection = Vector3.ZERO;
		currentSpeed = 0;
	else:
		currentDirection = velocity/currentSpeed;

		
	topDownVelocity = Vector2(velocity.x, velocity.z);
	currentTopDownSpeed = topDownVelocity.length();

	if(is_zero_approx(currentTopDownSpeed)):
		currentTopDownDirection = Vector2.ZERO;
		currentTopDownSpeed = 0;
	else:
		currentTopDownDirection = topDownVelocity/currentTopDownSpeed;
		
	currentTopDownDirection3D.x = currentTopDownDirection.x;
	currentTopDownDirection3D.z = currentTopDownDirection.y;
	
	if(currentSpeed != 0):
		if(currentTopDownSpeed != 0):
			lastNonZeroTopDownDirection3D.x = currentTopDownDirection3D.x;
			lastNonZeroTopDownDirection3D.z = currentTopDownDirection3D.z;
			currentFacingDirection = currentDirection;
		else:
			currentFacingDirection.x = 0;
			currentFacingDirection.y = currentDirection.y;
			currentFacingDirection.z = 0;
			currentFacingDirection = currentFacingDirection.normalized();
	else:
		currentFacingDirection.x = lastNonZeroTopDownDirection3D.x;
		currentFacingDirection.y = 0;
		currentFacingDirection.z = lastNonZeroTopDownDirection3D.z;
		currentFacingDirection = currentFacingDirection.normalized();
		
