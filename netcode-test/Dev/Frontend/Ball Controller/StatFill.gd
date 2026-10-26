@icon("res://Editor/Icons/ProgressBar.svg")

extends Node
class_name StatFill

var value : float;
var cooldown : float;

@export_range(0.0, 1.0, .01) var startingPercent : float = 0;
@export var minValue : float = 0;
@export var maxValue : float = 3;
@export var depleteSpeed : float = 1;
@export var cooldownPerValueAdded : float = 1;
@export var cooldownForHittingMaxValue : float = 1;
@export var cooldownMax : float = 10;

func _ready() -> void:
	value = lerp(minValue, maxValue, startingPercent);

func Process(delta : float):
	if(cooldown > 0):
		cooldown = move_toward(cooldown, 0, delta);
	else:
		value = move_toward(value, minValue, depleteSpeed * delta);
	pass;

func Add(amount : float) -> float:
	var prevValue = value;
	value = move_toward(value, maxValue, amount);
	var difference = max(value - prevValue, 0.0);
	cooldown = move_toward(cooldown, cooldownMax, difference * cooldownPerValueAdded);
	if(value == maxValue && difference != 0):
		cooldown = move_toward(cooldown, cooldownMax, cooldownForHittingMaxValue);
	
	return difference;
