class_name Interaction

var timeStamp : int;
var ownerId : int;
var type : String;

var removeFromLog : bool = false;

func _init(params : Dictionary) -> void:
	SetParams(params);
	pass;

func SetParams(params : Dictionary):
	if(params.has('timeStamp')):
		timeStamp = params['timeStamp'];
	if(params.has('ownerId')):
		ownerId = params['ownerId'];
	if(params.has('type')):
		type = params['type'];

func GetParams() -> Dictionary:
	return {'timeStamp' : timeStamp, 'ownerId': ownerId, 'type': type};

func GetLifeTime() -> float:
	return ((NetTime.clock as float) - (timeStamp as float)) / 1000.0;

func Evaluate():
	pass;
