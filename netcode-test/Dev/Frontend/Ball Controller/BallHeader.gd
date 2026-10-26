extends Header
class_name BallHeader;

@export var staminaLabel : Label;
@export var staminaMaxLabel : Label;

@export var healthLabel : Label;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowTarget(delta);
	pass

func DisplayStamina(value : float, max : float):
	staminaLabel.text = "%1.1f" % [value];
	staminaMaxLabel.text = "%1.1f" % [max];

func DisplayHealth(value : float, max : float):
	healthLabel.text = "%.0f" % [value];
