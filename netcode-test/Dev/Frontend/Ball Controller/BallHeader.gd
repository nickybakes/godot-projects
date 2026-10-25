extends Header
class_name BallHeader;

@export var staminaLabel : Label;
@export var staminaMaxLabel : Label;



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowTarget(delta);
	pass

func DisplayStamina(value : float):
	staminaLabel.text = "%1.1f" % [value];
	
func DisplayStaminaMax(value : float):
	staminaMaxLabel.text = "%1.1f" % [value];
