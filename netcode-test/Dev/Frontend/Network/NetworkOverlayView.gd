extends Control
class_name NetworkOverlayView

@onready var pingLabel : Label = $"Ping Label"

@onready var coverupPanel : Panel = $"Input Coverup Panel"
@onready var errorPanel: Panel = $"Input Coverup Panel/Error Panel"
@onready var titleLabel : Label = $"Input Coverup Panel/Error Panel/Title"
@onready var messageLabel : Label = $"Input Coverup Panel/Error Panel/Message"
@onready var connectingPanel: Panel = $"Input Coverup Panel/Connecting Panel"

@onready var logScrollContainer: Panel = $"Log Panel"
@onready var logVBoxContainer: VBoxContainer = $"Log Panel/Log Scroll Container/Log VBox Container"
@onready var logLinePrefab: Label = $"Log Line Prefab"

var currentPing = -999;

func _ready():
	coverupPanel.visible = false;

func ConnectionFailedMessage(message: String):
	coverupPanel.visible = true;
	connectingPanel.visible = false;
	errorPanel.visible = true;
	titleLabel.text = "Connection Failed";
	messageLabel.text = message;
	pass;
	
func ConnectingMessage():
	coverupPanel.visible = true;
	connectingPanel.visible = true;
	errorPanel.visible = false;
	pass;

func CancelConnection():
	coverupPanel.visible = false;
	pass;
	
func DismissError():
	coverupPanel.visible = false;
	pass;
	
func ToggleLog():
	logScrollContainer.visible = !logScrollContainer.visible;
	pass;
	
func LogMessage(message : String):
	var newLogLine : Label = logLinePrefab.duplicate();
	logVBoxContainer.add_child(newLogLine);
	newLogLine.visible = true;
	newLogLine.text = message;
	pass;

func setPing(ping : int):
	pingLabel.text = str(ping);
	currentPing = ping;

func _process(delta):
	if(Network.GetPing() != currentPing):
		setPing(Network.GetPing());
