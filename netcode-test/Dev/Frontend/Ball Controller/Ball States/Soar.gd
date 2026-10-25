extends BallState
class_name Soar

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.ProcessPhysics(delta);
	mcc.currentPhysics.Decelerate(delta);
	mcc.currentPhysics.MovementControl(delta);
