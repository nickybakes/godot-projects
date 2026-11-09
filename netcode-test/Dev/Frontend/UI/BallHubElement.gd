extends HubElement
class_name BallHubElement

@export_group("Basics")
@export var colorBar : CanvasItem;
@export var playerNumberLabel : Label;
@export var customization : CursorCustomizationDirectory;
@export var alive : Control;
@export var eliminated : Control;

@export_group("Tracker Line")
@export var lineTrackerStartPoint : Control;
@export var trackerLine : TrackerLine;


@export_group("Health")
@export var healthLabel : Label;
@export var healthIcon : CanvasItem;
@export var healthLabelScaleMin = 1.0;
@export var healthLabelScaleMax = 2.0;
@export_range(0.0, 1.0, 0.01) var healthLabelBlinkOff = .15;
@export_range(0.0, 1.0, 0.01) var healthLabelBlinkThreshold = .3;
@export var healthLabelBlinkTime = 1.0;
@export var healthColor : Gradient;
@export var healthRotation : Curve;

@export_group("Stamina")
@export var staminaBar : TextureProgressBar;

var healthBlinkTimer : float = 0.0;
var staminaBlinkTimer : float = 0.0;
var ballController : BallMCC;

func Setup(id : int):
	super(id);
	colorBar.modulate = customization.GetColorFromPlayerNumber(id);
	playerNumberLabel.text = str("P", id);
	
	ballController = GameManager.Manager.balls[id].ballController;
	ballController.visuals.ballHubElement = self;
	
	trackerLine.visible = true;
	trackerLine.Setup(id - 1, id);
	trackerLine.startPointTarget = lineTrackerStartPoint;
	trackerLine.endPointTarget = ballController;
	
	ShowAlive();
	
	pass;

func DisplayStamina(percent : float):
	staminaBar.value = percent;
	pass;
	

func DisplayHealth(percent : float):
	healthLabel.text = GetPercentageString(percent);
	var newScale = lerp(healthLabelScaleMax, healthLabelScaleMin, percent);
	healthLabel.scale.x = newScale;
	healthLabel.scale.y = newScale;
	healthLabel.modulate = healthColor.sample(percent);
	healthLabel.rotation_degrees = healthRotation.sample(percent);
	if(percent <= healthLabelBlinkThreshold):
		healthLabel.visible = healthBlinkTimer >= healthLabelBlinkTime * healthLabelBlinkOff;
	else:
		healthLabel.visible = true;

func GetPercentageString(percent : float) -> String:
	return "%.0f" % [percent * 100.0];
	
func ShowAlive():
	eliminated.visible = false;
	alive.visible = true;
	
func ShowEliminated():
	alive.visible = false;
	eliminated.visible = true;

func _process(delta: float) -> void:
	if(!visible):
		return;
	trackerLine.FollowTarget(delta);
	healthBlinkTimer += delta;
	if(healthBlinkTimer >= healthLabelBlinkTime):
		healthBlinkTimer = 0.0;
	pass;

func _exit_tree() -> void:
	trackerLine.queue_free();
