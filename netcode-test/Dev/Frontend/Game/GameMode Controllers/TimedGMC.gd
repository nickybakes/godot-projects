extends GameModeController
class_name TimedGMC

@export_category("Timed Specific")
@export var clockDisplay : ClockDisplay;

func _process(delta: float) -> void:
	clockDisplay.DisplayTime(gameTime);
