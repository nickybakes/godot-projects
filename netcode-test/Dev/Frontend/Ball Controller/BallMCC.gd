extends ModularCharacterController
class_name BallMCC

@export var visuals : BallVisuals;
@export var defaultPhysics : BallPhysics;
@export var traits : BallTraits;
@export var defaultState : BallState;

@export_category("Current Storages")
@export var currentPhysicsStorage : StorageNode;
@export var currentStateStorage : StorageNode;

@export_category("Stats")
@export var staminaStat : StatRefill;
@export var healthStat : StatRefill;
@export var electricStat : StatFill;
@export var invulnStat : StatFill;

@export_category("Hit Boxes and Regions")
@export var hitbox : HitBox;
@export var deflectRegion : HitRegion;
@export var strikeRegion : HitRegion;
@export var grabRegion : HitRegion;
@export var slamRegion : HitRegion;

var interactive : bool = true;

var playerNumber : int;
var eliminated : bool;

var clash : bool;

var blocking : bool;
var successfulBlock : bool;

var grabParent : BallMCC;
var grabParentElectric : float;
var grabVictimIndex : int;
var grabVictimTotal : int;
var grabVictimAngleOffset : float;

var strikePrioritied : bool

var allStates : Array[BallState];
var currentState : BallState;
var previousState : BallState;

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
	
func GetPhysics() -> BallPhysics:
	return currentPhysics;
	
func DoStateTransition(nextState : MCCState):
	previousState = currentState;
	currentState = nextState;
	currentStateStorage.storedNode = currentState;
	
	previousState.ExitState();
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

func TakeDamageFromStrike(activator : BallMCC, activatorSpeed : float, activatorElectric : float) -> float:
	var damageCalc = DamageCalcStrike(activator, activatorSpeed, activatorElectric);
	if(updatePhysics):
		healthStat.Spend(damageCalc);
	return damageCalc;
	
func BlockDamageFromStrike(activator : BallMCC, activatorSpeed : float, activatorElectric : float) -> float:
	successfulBlock = true;
	var damageCalc = DamageCalcStrike(activator, activatorSpeed, activatorElectric);
	# maybe track blocked damage?
	#healthStat.Spend(0);
	return damageCalc;
	
func TakeDamageFromGrab(activator : BallMCC, activatorElectric : float) -> float:
	var damageCalc = DamageCalcGrab(activator, activatorElectric);
	if(updatePhysics):
		healthStat.Spend(damageCalc);
	return damageCalc;
	
func DamageCalcStrike(activator : BallMCC, activatorSpeed : float, activatorElectric : float) -> float:
	var damageCalc = (traits.baseStrikeDamage + (activatorElectric * traits.strikeDamageElectricMultScalar)) * (activatorSpeed * traits.strikeDamageSpeedScalar);
	damageCalc = clamp(damageCalc, 0.0, traits.maxStrikeDamage);
	return damageCalc;
	
func DamageCalcGrab(activator : BallMCC, activatorElectric : float) -> float:
	var damageCalc = traits.baseGrabDamage + (activatorElectric * traits.grabDamageElectricMultScalar);
	return damageCalc;

func _ready() -> void:
	SetupStates();
	currentPhysics = GetDefaultPhysics();
	currentPhysicsStorage.storedNode = currentPhysics;
	currentState = GetDefaultState();
	currentStateStorage.storedNode = currentState;
	previousState = currentState;
	currentPhysics.mcc = self;

func _physics_process(delta: float) -> void:
	CalculateBasicStats(delta);
	grabRegion.ScaleBySpeed(currentSpeed);
	if(updatePhysics):
		currentState.ProcessPhysics(delta);
	pass;
	
func _process(delta: float) -> void:
	currentState.Process(delta);
	if(updateVisuals):
		visuals.ballHubElement.DisplayStamina(staminaStat.value, staminaStat.maxValue);
		visuals.header.DisplayStamina(staminaStat.value, staminaStat.maxValue);
		visuals.ballHubElement.DisplayHealth(healthStat.value, healthStat.maxValue);
		visuals.UpdateElectricVisuals(electricStat.value / electricStat.maxValue, delta);
		visuals.UpdateInvulnVisuals(invulnStat.value, delta);
		currentState.ProcessVisuals(delta);
		visuals.ballHubElement.trackerLine.goalAlphaMultiply = max(currentSpeed * visuals.profile.trackerLineSpeedAlphaMultiply, 1.0);

func ProcessInteraction():
	pass;
