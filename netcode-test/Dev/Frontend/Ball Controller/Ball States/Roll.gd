extends BallState
class_name Roll

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.ProcessPhysics(delta);
	
	if(mcc.currentPhysics.onSurface):
		var fireAdd = mcc.traits.fireBuildUpBySpeed.sample(mcc.currentSpeed);
		mcc.fireStat.Add(fireAdd * delta);
