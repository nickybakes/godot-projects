@icon("res://Editor/Icons/MoveRight_Green.svg")
class_name MCCTransition extends Node

@export var stateTransitionTo : MCCState;

@export var rules : Array[MCCRule];

@export var breakOutIfTransition := true;

func CheckForTransition(state : MCCState, delta : float) -> bool:
	for rule in rules:
		if(!rule.CheckForPass(state, self, delta)):
			return false;
		elif(rule.breakOutIfPass):
			return true;
	return true;
