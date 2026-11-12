extends Object
class_name SubState

var currentIndex : int = 0;

var stepTimes : Array[float];

var currentStepTime : float = 0.0;

func _init(_stepTimes : Array[float]) -> void:
	currentIndex = 0;
	currentStepTime = 0.0;
	stepTimes = _stepTimes;
	pass;
	
func Update(delta: float) -> bool:
	if(currentIndex >= stepTimes.size()):
		return false;
		
	currentStepTime+= delta;
	if(currentStepTime >= stepTimes[currentIndex]):
		currentIndex += 1;
		currentStepTime = 0.0;
		return true;
	
	return false;
	pass;
