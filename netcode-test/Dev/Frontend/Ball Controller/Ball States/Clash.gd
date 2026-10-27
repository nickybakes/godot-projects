extends BallState
class_name Clash

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartClashVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopClashVisual();
	
func StartStatePhysics(params : Dictionary = {}):
	mcc.clash = false;
	
func ExitStatePhysics(params : Dictionary = {}):
	mcc.clash = false;

func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.DecelerateTopDown(delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	mcc.currentPhysics.CheckDeflectRegion(delta);
