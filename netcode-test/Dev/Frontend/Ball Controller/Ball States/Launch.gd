extends BallState
class_name Launch

func StartStatePhysics(params : Dictionary = {}):
	mcc.velocity = params['direction'] * params['speed'];
	mcc.GetPhysics().ResetSurface();
	pass;
	#mcc.visuals.StartChargeVisual();
