@icon("res://Editor/Icons/ProgressBar.svg")

extends Node
class_name StatRefill

var value : float;
var cooldown : float;

@export_range(0.0, 1.0, .01) var startingPercent : float = 0;
@export var minValue : float = 0;
@export var maxValue : float = 3;
@export var fillSpeed : float = 1;
@export var cooldownPerValueSpent : float = 1;
@export var cooldownForHittingMinValue : float = 1;
@export var cooldownMax : float = 10;

func _ready() -> void:
	value = lerp(minValue, maxValue, startingPercent);

func Process(delta : float):
	if(cooldown > 0):
		cooldown = move_toward(cooldown, 0, delta);
	else:
		value = move_toward(value, maxValue, fillSpeed * delta);
	pass;

func Spend(amount : float) -> float:
	var prevValue = value;
	value = move_toward(value, minValue, amount);
	var difference = max(prevValue - value, 0.0);
	cooldown = move_toward(cooldown, cooldownMax, difference * cooldownPerValueSpent);
	if(value == minValue && difference != 0):
		cooldown = move_toward(cooldown, cooldownMax, cooldownForHittingMinValue);
	
	return difference;
