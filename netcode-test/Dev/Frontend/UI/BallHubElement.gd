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

@export_group("Stamina")
@export var staminaLabel : Label;
@export var staminaIcon : CanvasItem;
@export var staminaLabelScaleMin = .2;
@export var staminaLabelScaleMax = 1.0;
@export_range(0.0, 1.0, 0.01) var staminaLabelBlinkOff = .15;
@export_range(0.0, 1.0, 0.01) var staminaLabelBlinkThreshold = .3;
@export var staminaLabelBlinkTime = 1.0;


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

func DisplayStamina(value : float, max : float):
	staminaLabel.text = GetPercentageString(value, max);
	var p = value/max;
	var newScale = lerp(staminaLabelScaleMin, staminaLabelScaleMax, p);
	staminaLabel.scale.x = newScale;
	staminaLabel.scale.y = newScale;
	staminaIcon.self_modulate.v = p;
	if(p <= staminaLabelBlinkThreshold):
		staminaLabel.visible = staminaBlinkTimer >= staminaLabelBlinkTime * staminaLabelBlinkOff;
	else:
		staminaLabel.visible = true;
	

func DisplayHealth(value : float, max : float):
	healthLabel.text = GetPercentageString(value, max);
	var p = value/max;
	var newScale = lerp(healthLabelScaleMax, healthLabelScaleMin, p);
	healthLabel.scale.x = newScale;
	healthLabel.scale.y = newScale;
	healthIcon.self_modulate.v = p;
	if(p <= healthLabelBlinkThreshold):
		healthLabel.visible = healthBlinkTimer >= healthLabelBlinkTime * healthLabelBlinkOff;
	else:
		healthLabel.visible = true;

func GetPercentageString(value : float, max : float) -> String:
	return "%.0f" % [(value/max) * 100.0];
	
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
		
	staminaBlinkTimer += delta;
	if(staminaBlinkTimer >= staminaLabelBlinkTime):
		staminaBlinkTimer = 0.0;
	pass;

func _exit_tree() -> void:
	trackerLine.queue_free();
