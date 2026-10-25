extends BallState
class_name Roll

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.ProcessPhysics(delta);
