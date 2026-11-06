@icon("res://Editor/Icons/CameraAttributesPractical.svg")
extends Node3D
class_name CameraTarget


@export var goalStrength = 1.0;
@export var maxStrength = 1.0;
@export var minStrength = 0.0;
@export var transitionSpeed : float = 1.0;

var strength = 1.0;

func _ready() -> void:
	CameraManager.CM.focuser.AddTarget(self);
	pass;

func GetStrength() -> float:
	return clamp(minStrength, maxStrength, strength);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	strength = move_toward(strength, goalStrength, transitionSpeed * delta);
	pass
