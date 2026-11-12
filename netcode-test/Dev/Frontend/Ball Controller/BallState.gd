@abstract class_name BallState extends MCCState

var mcc : BallMCC;

func GetMCC() -> BallMCC:
	return mcc;

func ProcessPhysics(delta : float):
	mcc.staminaStat.Process(delta);
	mcc.healthStat.Process(delta);
	mcc.electricStat.Process(delta);
	mcc.invulnStat.Process(delta);
	super(delta);
	
func ProcessVisuals(delta : float):
	mcc.visuals.RollBall(mcc.currentSpeed, delta);
	mcc.visuals.PitchBall(mcc.currentDirection.y * (PI * .5), delta);
	mcc.visuals.SpeedStretch(mcc.currentSpeed);
	if(mcc.currentSpeed >= mcc.traits.minRequiredStrikeSpeed && mcc.strikeCooldown.IsCooledDown() && mcc.invulnStat.value == 0.0 && mcc.interactive):
		mcc.visuals.StartStrikeVisual();
	else:
		mcc.visuals.StopStrikeVisual();
	if(mcc.currentTopDownDirection && mcc.currentTopDownSpeed > mcc.visuals.profile.spinFaceMinSpeed):
		mcc.visuals.SpinFaceDirection(mcc.currentTopDownDirection);
	super(delta);
