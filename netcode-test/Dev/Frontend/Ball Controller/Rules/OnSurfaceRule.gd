extends MCCRule
class_name OnSurfaceRule

@export var invert := false;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	return state.GetMCC().GetPhysics().get('onSurface') == !invert;
