extends CanvasLayer
class_name InputOverlayView

static var LogPanel : Panel;

@onready var logPanel: Panel = $"Log Panel"
@onready var logScrollContainer: ScrollContainer = $"Log Panel/Log Scroll Container/"
@onready var logVBoxContainer: VBoxContainer = $"Log Panel/Log Scroll Container/Log VBox Container"
@onready var logLinePrefab: Label = $"Log Line Prefab"

func RegisterJoypad(device : int, deviceName : String):
	LogMessage(str("Registered joypad with ID ", device, ": ", deviceName));
	
func DisconnectJoypad(device : int, deviceName : String):
	LogMessage(str("Disconnected joypad with ID ", device, ": ", deviceName));

func ReconnectJoypad(device : int, deviceName : String):
	LogMessage(str("Reconnected joypad with ID ", device, ": ", deviceName));
	
func _ready():
	LogPanel = logPanel;
	logPanel.visible = false;	
	
func ToggleLog():
	logPanel.visible = !logPanel.visible;
	if(logPanel.visible):
		NetworkOverlayView.LogPanel.visible = false;
		await get_tree().create_timer(.01).timeout
		logScrollContainer.set_deferred("scroll_vertical", logScrollContainer.get_v_scroll_bar().max_value)
	pass;
	
func TestLog():
	LogMessage("Test wdaw d awd awd awdawdawdawdawdwd");
	
func LogMessage(message : String):
	var newLogLine : Label = logLinePrefab.duplicate();
	logVBoxContainer.add_child(newLogLine);
	newLogLine.visible = true;
	newLogLine.text = message;
	await get_tree().create_timer(.01).timeout
	logScrollContainer.set_deferred("scroll_vertical", logScrollContainer.get_v_scroll_bar().max_value)
	pass;
