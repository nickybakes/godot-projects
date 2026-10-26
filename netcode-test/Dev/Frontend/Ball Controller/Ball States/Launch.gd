extends BallState
class_name Launch

func StartStatePhysics(params : Dictionary = {}):
	mcc.velocity = params['direction'] * params['speed'];
	mcc.currentPhysics.ResetSurface();
	pass;
	#mcc.visuals.StartChargeVisual();
