extends Header
class_name BallHeader;

@export var healthLabel : Label;
@export var staminaBar : TextureProgressBar;
@export var staminaBarAlpha : Curve;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowTarget(delta);
	pass

func DisplayStamina(percent : float):
	staminaBar.value = percent;
	staminaBar.modulate.a = staminaBarAlpha.sample(percent);

func DisplayHealth(percent : float):
	healthLabel.text = GetPercentageString(percent);

func GetPercentageString(percent : float) -> String:
	return "%.0f" % [percent * 100.0];
