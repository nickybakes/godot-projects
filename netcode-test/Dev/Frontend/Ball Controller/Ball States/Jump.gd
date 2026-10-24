extends BallState
class_name Jump

func StartStatePhysics(params : Dictionary = {}):
	super(params);
	mcc.velocity.y = mcc.traits.jumpHeight;


func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.ProcessPhysics(delta);
