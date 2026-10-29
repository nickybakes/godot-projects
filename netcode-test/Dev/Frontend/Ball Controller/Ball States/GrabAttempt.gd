extends BallState
class_name GrabAttempt

@export var cooldown : Cooldown;

var victims : Array[BallMCC];
var failure : bool

var visualsShowing : bool;

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartGrabVisual();
	visualsShowing = true;
	
func ExitStateVisuals():
	mcc.visuals.StopGrabVisual();
	visualsShowing = false;

func StartStatePhysics(params : Dictionary = {}):
	cooldown.Restart();
	mcc.GetPhysics().BounceVelocity(mcc.currentFacingDirection, mcc.currentSpeed, mcc.traits.grabAttemptBoost);
	mcc.staminaStat.Spend(mcc.traits.grabStaminaCost);
	
	failure = false;
	
	victims = [];
	
	if(mcc.grabRegion.ballsInsideThisRegion.size() == 0):
		failure = true;
		return;
	
	for i in min(mcc.grabRegion.ballsInsideThisRegion.size(), mcc.traits.maxNumOfGrabbedBalls):
		var hitBall = mcc.grabRegion.ballsInsideThisRegion[i];
		victims.push_back(hitBall);
	
	var randomAngleOffset = randf();
	
	InteractionManager.Manager.SendInteraction(InteractionCreator.NewGrabAttempt(mcc, victims, randomAngleOffset));
	pass;
	
func ExitStatePhysics():
	cooldown.Restart();
	
func ProcessVisuals(delta : float):
	if(timeInState >= mcc.visuals.profile.grabVisualTimeMax && visualsShowing):
		mcc.visuals.StopGrabVisual();
		visualsShowing = false;

func ProcessPhysics(delta : float):
	super(delta);
	if(failure):
		mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.grabAttemptDeceleration);
		mcc.velocity.y = move_toward(mcc.velocity.y, 0, mcc.traits.grabAttemptDeceleration * delta)
		mcc.GetPhysics().MoveAndCollide(delta);
