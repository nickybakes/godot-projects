@icon("res://Editor/Icons/AudioBusSolo_Red.svg")
@abstract class_name MCCState extends Node

@export var codeName : String = "state";

@export var transitions : Array[MCCTransition];

var stateIndex : int;

var timeInState : float;

var exitPhysicsParams : Dictionary = {};
var exitVisualsParams : Dictionary = {};
var exitStateParams : Dictionary = {};

@abstract func GetMCC() -> ModularCharacterController;

func GetInputDevice() -> InputDevice:
	return GetMCC().inputDevice;

func GetInputBuffer() -> InputBuffer:
	return GetMCC().inputDevice.inputBuffer;

func StartStatePhysics(params : Dictionary = {}):
	pass;
	
func ExitStatePhysics():
	pass;
	
func StartStateVisuals(params : Dictionary = {}):
	pass;
	
func ExitStateVisuals():
	pass;
	
func StartState(params : Dictionary = {}):
	timeInState = 0;
	
func ExitState():
	pass;
	
func Process(delta : float):
	timeInState += delta;

func ProcessPhysics(delta : float):
	CheckAndDoTransition(delta);
	
func ProcessVisuals(delta : float):
	pass;

func CheckAndDoTransition(delta : float) -> bool:
	var transitionIndex = CheckForTransitions(delta);
	if(transitionIndex != -1):
		GetMCC().DoStateTransition(transitions[transitionIndex].stateTransitionTo);
		return true;
	return false;

func CheckForTransitions(delta : float) -> int:
	var indexOfTransition = -1;
	for index in transitions.size():
		var transition = transitions[index];
		if(transition.CheckForTransition(self, delta)):
			indexOfTransition = index;
			if(transition.breakOutIfTransition):
				return indexOfTransition;
	
	return indexOfTransition;
