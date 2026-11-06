extends BallState
class_name Eliminated

func StartState(params : Dictionary = {}):
	mcc.interactive = false;
	mcc.eliminated = true;
	
func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.HideBall();
	mcc.visuals.ShowEliminatedMessage();
	mcc.visuals.cameraTarget.goalStrength = 0;
	mcc.visuals.cameraTarget.strength = 2.5;
	CameraManager.CM.shaker.Shake(mcc.visuals.profile.eliminationCameraShake);

func ExitState():
	mcc.interactive = true;
	
func ExitStateVisuals():
	mcc.visuals.ShowBall();
	
func ProcessPhysics(delta : float):
	pass;
