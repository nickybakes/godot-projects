extends Node
class_name PlayerCustomization

@export var invertChargeAim : bool;

@export var colorIndex : int;


func LoadFromParams(params : Dictionary):
	if(params.has("invertChargeAim")):
		invertChargeAim = params["invertChargeAim"];
	if(params.has("colorIndex")):
		colorIndex = params["colorIndex"];
	pass;

func GetParams() -> Dictionary:
	return {"invertChargeAim" : invertChargeAim, "colorIndex" : colorIndex};
