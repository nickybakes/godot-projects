@abstract class_name BallState extends MCCState

var mcc : BallMCC;

func GetMCC() -> BallMCC:
	return mcc;

func ProcessPhysics(delta : float):
	mcc.staminaStat.Process(delta);
	mcc.healthStat.Process(delta);
	mcc.fireStat.Process(delta);
	mcc.invulnStat.Process(delta);
	super(delta);
	
func ProcessVisuals(delta : float):
	mcc.visuals.RollBall(mcc.currentSpeed, delta);
	mcc.visuals.PitchBall(mcc.currentDirection.y * (PI * .5), delta);
	mcc.visuals.SpeedStretch(mcc.currentSpeed);
	mcc.visuals.FaceFlamesBySpeed(mcc.currentSpeed);
	if(mcc.currentTopDownDirection && mcc.currentTopDownSpeed > mcc.visuals.profile.spinFaceMinSpeed):
		mcc.visuals.SpinFaceDirection(mcc.currentTopDownDirection);
	super(delta);
