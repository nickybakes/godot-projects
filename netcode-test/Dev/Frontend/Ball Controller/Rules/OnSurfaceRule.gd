extends MCCRule
class_name OnSurfaceRule

@export var invert := false;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	if(invert):
		return !state.GetMCC().currentPhysics.get('onSurface');
	else:
		return state.GetMCC().currentPhysics.get('onSurface');
