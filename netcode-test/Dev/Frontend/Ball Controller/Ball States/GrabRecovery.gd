extends BallState
class_name GrabRecovery

var velocity : Vector3;
var velocitySet : bool;

func StartStateVisuals(params : Dictionary = {}):
	if(params.has('isVictim') && params['isVictim']):
		mcc.visuals.ballHubElement.trackerLine.heartbeat = mcc.visuals.profile.trackerLineGrabHeartbeat;
		mcc.visuals.ballHubElement.trackerLine.alphaMultiply = mcc.visuals.profile.trackerLineGrabAlphaMultiply;


func StartStatePhysics(params : Dictionary = {}):
	if(params.has('velocity')):
		velocity = params['velocity'];
	velocitySet = false;

func ProcessPhysics(delta : float):
	super(delta);
	if(!velocitySet):
		mcc.velocity = velocity;
		velocitySet = true;
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
	mcc.GetPhysics().DecelerateTopDown(delta);
