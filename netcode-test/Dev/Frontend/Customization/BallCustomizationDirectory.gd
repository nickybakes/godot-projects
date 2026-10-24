extends Resource
class_name BallCustomizationDirectory

@export var ballColors : Array[Color];

@export var ballMaterialBasic : ShaderMaterial;
@export var outlineMaterial : ShaderMaterial;
@export var xrayMaterial : ShaderMaterial;
@export var chargeAimMaterial : ShaderMaterial;

func GetColorFromPlayerNumber(playerNumber : int) -> Color:
	return ballColors[(playerNumber - 1) % ballColors.size()];
