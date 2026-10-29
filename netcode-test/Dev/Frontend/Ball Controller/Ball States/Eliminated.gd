extends BallState
class_name Eliminated

func StartState(params : Dictionary = {}):
	mcc.interactive = false;
	
func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.HideBall();
	mcc.visuals.ShowEliminatedMessage();

func ExitState():
	mcc.interactive = true;
	
func ExitStateVisuals():
	mcc.visuals.ShowBall();
	
func ProcessPhysics(delta : float):
	pass;
