extends BallState
class_name Roll

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().ProcessPhysics(delta);
	
	if(mcc.GetPhysics().onSurface):
		var fireAdd = mcc.traits.fireBuildUpBySpeed.sample(mcc.currentSpeed);
		mcc.fireStat.Add(fireAdd * delta);
