extends HubElement
class_name BallHubElement

@export_group("Basics")
@export var colorBar : CanvasItem;
@export_range(0.0, 1.0, .01) var eliminatedAlpha : float = .5;
@export var playerNumberLabel : Label;
@export var customization : CursorCustomizationDirectory;
@export var alive : Control;
@export var respawning : Control;
@export var respawningClockLabel : Label;
@export var eliminated : Control;
@export var livesDisplay : LivesDisplay;

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

@export_group("Controls")
@export var invertChargeAim : Control;

var healthBlinkTimer : float = 0.0;
var staminaBlinkTimer : float = 0.0;
var ballController : BallMCC;

func Setup(id : int):
	super(id);
	playerNumberLabel.text = str("P", id);
	
	ballController = GameManager.Manager.balls[id].ballController;
	ballController.visuals.ballHubElement = self;
	
	trackerLine.visible = true;
	trackerLine.Setup(id);
	trackerLine.startPointTarget = lineTrackerStartPoint;
	trackerLine.endPointTarget = ballController;
	
	livesDisplay.Setup();
	livesDisplay.Display(ballController.lives);
	
	UpdateColor();
	
	ShowAlive();
	
	pass;
	
	
func UpdateColor():
	colorBar.modulate = customization.cursorColors[ballController.playerToken.customization.colorIndex];
	trackerLine.SetColorIndex(ballController.playerToken.customization.colorIndex);	

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
	respawning.visible = false;
	livesDisplay.visible = true;
	eliminated.visible = false;
	alive.visible = true;
	colorBar.modulate.a = 1.0;
	
func ShowRespawning():
	respawning.visible = true;
	alive.visible = false;
	eliminated.visible = false;
	colorBar.modulate.a = 1.0;
	pass;
	
func UpdateRespawnClock(respawnTime : float):
	respawningClockLabel.text = "%.0f" % respawnTime;
	
func ShowEliminated():
	respawning.visible = false;
	livesDisplay.visible = false;
	alive.visible = false;
	eliminated.visible = true;
	colorBar.modulate.a = eliminatedAlpha;

func _process(delta: float) -> void:
	if(!visible):
		return;
	trackerLine.FollowTarget(delta);
	healthBlinkTimer += delta;
	if(healthBlinkTimer >= healthLabelBlinkTime):
		healthBlinkTimer = 0.0;
	pass;
	
func UpdateInvertChargeAim(inverted : bool):
	invertChargeAim.visible = inverted;

func _exit_tree() -> void:
	trackerLine.queue_free();
