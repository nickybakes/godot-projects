extends HubElement
class_name CursorHubElement

@export var colorBar : CanvasItem;
@export var nameLabel : Label;
@export var playerNumberLabel : Label;
@export var avatarDisplay : AvatarDisplay;
@export var lineTrackerStartPoint : Control;

func Setup(id : int):
	super(id);
	colorBar.modulate = CursorManager.Manager.GetColorFromPlayerNumber(id);
	playerNumberLabel.text = str("P", id);
	pass;
