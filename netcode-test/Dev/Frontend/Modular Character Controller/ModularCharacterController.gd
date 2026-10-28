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

var requestedMoveDirection : Vector3;
var topDownVelocity : Vector2;
var currentTopDownSpeed : float;
var currentSpeed : float;
var currentTopDownDirection : Vector2;
var currentTopDownDirection3D : Vector3 = Vector3.ZERO;
var currentDirection : Vector3;

func CalculateBasicStats(delta : float):
	CalculateRequestedMoveDirection(delta);
		
	currentSpeed = velocity.length();
	
	if(currentSpeed == 0):
		currentDirection = Vector3.ZERO;
	else:
		currentDirection = velocity/currentSpeed;	
		
	topDownVelocity = Vector2(velocity.x, velocity.z);
	currentTopDownSpeed = topDownVelocity.length();

	if(currentTopDownSpeed == 0):
		currentTopDownDirection = Vector2.ZERO;
	else:
		currentTopDownDirection = topDownVelocity/currentTopDownSpeed;
		
	currentTopDownDirection3D.x = currentTopDownDirection.x;
	currentTopDownDirection3D.z = currentTopDownDirection.y;
