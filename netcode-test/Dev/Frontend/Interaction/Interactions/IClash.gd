extends Interaction
class_name IClash

var victims : Array[int];

var alreadyActivated : bool = false;

func _init(params : Dictionary) -> void:
	SetParams(params);
	pass;

func SetParams(params : Dictionary):
	super(params);
	if(params.has('victims')):
		victims = params['victims'];

func GetParams() -> Dictionary:
	return super().merged({'victims' : victims});

func Evaluate():
	if(!alreadyActivated):
		for victim in victims:
			if(GameManager.Manager.balls[victim].ballController.updatePhysics):
				GameManager.Manager.balls[victim].ballController.ForceSetState('clash');
		alreadyActivated = true;
	pass;
