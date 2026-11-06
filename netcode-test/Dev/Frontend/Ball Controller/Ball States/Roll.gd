extends BallState
class_name Roll

func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().ProcessPhysics(delta);
	
	if(mcc.GetPhysics().onSurface):
		var electricAdd = mcc.traits.electricBuildUpBySpeed.sample(mcc.currentSpeed);
		mcc.electricStat.Add(electricAdd * delta);
