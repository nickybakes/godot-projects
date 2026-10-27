extends MCCRule
class_name BoolRule

@export var node : Node;
@export var property : String;
@export var invert := false;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	return node.get(property) == !invert;
