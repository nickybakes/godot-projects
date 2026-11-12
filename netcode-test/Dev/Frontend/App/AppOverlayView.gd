extends CanvasLayer
class_name AppOverlayView

@export var windowModeMessageTimeMax : float = 3.0;
@export var windowModeMessageFadeTime : float = 1.0;
@export var windowModeLabel : Label;

var windowModeMessageTime : float
var windowModeMessageShown : bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppManager.WindowModeChanged.connect(ShowWindowModeMessage);
	windowModeLabel.visible = false;

func ShowWindowModeMessage(newMode : int):
	windowModeMessageShown = true;
	windowModeMessageTime = 0.0;
	windowModeLabel.visible = true;
	match(newMode):
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			windowModeLabel.text = "Windowed"
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			windowModeLabel.text = "Fullscreen Windowed"
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			windowModeLabel.text = "Fullscreen Exclusive"
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(windowModeMessageShown):
		windowModeMessageTime += delta;
		
		windowModeLabel.modulate.a = clamp((windowModeMessageTimeMax - windowModeMessageTime) / windowModeMessageFadeTime, 0.0, 1.0);
		
		if(windowModeMessageTime >= windowModeMessageTimeMax):
			windowModeMessageShown = false;
			windowModeLabel.visible = false;
	pass
