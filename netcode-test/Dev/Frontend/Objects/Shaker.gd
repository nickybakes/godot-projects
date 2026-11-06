extends Node3D
class_name Shaker

enum ShakeAxis{
	XY,
	XZ,
	ZY
}

@export var profile : ShakeProfile;
@export var axis : ShakeAxis;

var currentAmount : float;
var currentSin : float;
var currentCos : float;

var sinOffset : float;
var cosOffset : float;

var newPosition : Vector3 = Vector3.ZERO;

var time : float;


func Shake(amount : float):
	currentAmount = min(profile.maxAmount, currentAmount + (profile.range * amount));
	
	sinOffset = randf() * profile.deviation;
	cosOffset = randf() * profile.deviation;


func _process(delta: float) -> void:
	time += delta;
	currentSin = sin(time * profile.speed + sinOffset);
	currentCos = cos(time * profile.speed + sinOffset);
	
	match(axis):
		ShakeAxis.XY:
			newPosition.x = currentCos * currentAmount;
			newPosition.y = currentSin * currentAmount;
		ShakeAxis.XZ:
			newPosition.x = currentCos * currentAmount;
			newPosition.z = currentSin * currentAmount;
		ShakeAxis.ZY:
			newPosition.z = currentCos * currentAmount;
			newPosition.y = currentSin * currentAmount;
			
	position = newPosition;
	
	currentAmount = move_toward(currentAmount, 0, profile.damping * delta);
	
	pass
