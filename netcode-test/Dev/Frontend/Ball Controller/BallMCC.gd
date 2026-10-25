extends ModularCharacterController
class_name BallMCC

@export var visuals : BallVisuals;
@export var defaultPhysics : BallPhysics;
@export var traits : BallTraits;
@export var defaultState : BallState;

var allStates : Array[BallState];
var currentState : BallState;
var previousState : BallState;
var ballSoaring : bool;

func GetTraits() -> BallTraits:
	return traits;

func SetupStates():
	allStates = [];
	var index = 0;
	for child in statesParent.get_children():
		if(child is BallState):
			allStates.push_back(child as BallState);
			var state : BallState = child as BallState;
			state.mcc = self;
			state.stateIndex = index;
			index += 1;

func GetDefaultState() -> BallState:
	return defaultState;

func GetDefaultPhysics() -> BallPhysics:
	return defaultPhysics;

func GetState(index : int) -> BallState:
	return allStates[index];
	
func GetTotalStates() -> int:
	return allStates.size();
	
func DoStateTransition(nextState : MCCState):
	previousState = currentState;
	currentState = nextState;
	
	currentState.ExitState();
	if(updatePhysics):
		previousState.ExitStatePhysics();
	if(updateVisuals):
		previousState.ExitStateVisuals();
		
	currentState.StartState(previousState.exitStateParams);
	if(updatePhysics):
		currentState.StartStatePhysics(previousState.exitPhysicsParams);
	if(updateVisuals):
		currentState.StartStateVisuals(previousState.exitVisualsParams);
	pass;
	
func DoStateTransitionByIndex(nextStateIndex : int):
	DoStateTransition(allStates[nextStateIndex]);
	
func CalculateRequestedMoveDirection(delta : float):
	if(inputDevice):
		requestedMoveDirection = Vector3(inputDevice.moveInput.x, 0, -inputDevice.moveInput.y);

func _ready() -> void:
	SetupStates();
	currentPhysics = GetDefaultPhysics();
	currentState = GetDefaultState();
	previousState = currentState;
	currentPhysics.mcc = self;

func _physics_process(delta: float) -> void:
	CalculateBasicStats(delta);
	if(updatePhysics):
		currentState.ProcessPhysics(delta);
	pass;
	
func _process(delta: float) -> void:
	currentState.Process(delta);
	if(updateVisuals):
		currentState.ProcessVisuals(delta);

func BasicMoveInput():
	pass;
