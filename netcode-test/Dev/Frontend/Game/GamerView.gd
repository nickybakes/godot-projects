extends Control
class_name GamerView

static var View : GamerView;

@export var hub : Hub;


func HideAllTrackerLines():
	for element in hub.elements.values():
		var ballHubElement = element as BallHubElement;
		ballHubElement.trackerLine.visible = false;

func _ready() -> void:
	View = self;
	pass # Replace with function body.
