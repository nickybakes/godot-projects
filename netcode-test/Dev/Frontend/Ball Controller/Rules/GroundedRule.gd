extends MCCRule
class_name GroundedRule

@export var invert := false;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	if(invert):
		return !state.GetMCC().is_on_floor();
	else:
		return state.GetMCC().is_on_floor();
