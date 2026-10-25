@icon("res://Editor/Icons/Timer_Purple.svg")
extends Node
class_name Cooldown

var value : float;

@export var cooldownTime : float = .5;
@export_range(0.0, 1.0, .01) var startPercentage : float = 0;

func IsCooledDown() -> bool:
	return value == 0;

func _process(delta : float):
	value = move_toward(value, 0, delta);
	
func Restart(percentage : float = 1.0):
	value = cooldownTime * percentage;
	
