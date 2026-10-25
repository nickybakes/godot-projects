extends BallState
class_name Launch

func StartStatePhysics(params : Dictionary = {}):
	mcc.velocity = params['direction'] * params['speed'];
	pass;
	#mcc.visuals.StartChargeVisual();
