extends Node3D
class_name RingPoint

@export var finalRingRadius = 7.0;
@export var finalRingRadiusDeviationMin = .9;
@export var finalRingRadiusDeviationMax = 1.1;

func GetFinalRingRadius() -> float:
	var randomScale = randf_range(finalRingRadiusDeviationMin, finalRingRadiusDeviationMax);
	return finalRingRadius * randomScale;
