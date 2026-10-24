extends BallState
class_name Idle


func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.ProcessPhysics(delta);
