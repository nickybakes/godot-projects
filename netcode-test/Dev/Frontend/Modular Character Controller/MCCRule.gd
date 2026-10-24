@abstract class_name MCCRule extends Node

@export var breakOutIfPass := false;

@abstract func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool;
