@abstract class_name BallState extends MCCState

var mcc : BallMCC;

func GetMCC() -> BallMCC:
	return mcc;

func ProcessPhysics(delta : float):
	mcc.staminaStat.Process(delta);
	super(delta);
	
func ProcessVisuals(delta : float):
	mcc.visuals.RollBall(mcc.currentSpeed, delta);
	#mcc.visuals.PitchBall(mcc.currentDirection.y);
	if(mcc.currentTopDownDirection):
		mcc.visuals.SpinFaceDirection(mcc.currentTopDownDirection);
	super(delta);
