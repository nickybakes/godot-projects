extends Node3D
class_name BallController

@onready var netObject: NetObject = $".."
var originPosition : Vector3;
var originSet : bool;
var timeAlive : float;

func _process(delta: float) -> void:
	if(!netObject.isDummy):
		if(!originSet):
			originSet = true;
			originPosition = position;
		position.x = originPosition.x + sin(timeAlive);
		timeAlive += delta;

	
	
