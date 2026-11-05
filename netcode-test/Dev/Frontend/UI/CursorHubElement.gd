extends HubElement
class_name CursorHubElement

@export var colorBar : CanvasItem;
@export var playerNumberLabel : Label;
@export var lineTrackerStartPoint : Control;
@export var accountDisplay : AccountDisplay;
@export var trackerLine : TrackerLine;
@export var customization : CursorCustomizationDirectory;
@export var speedAlphaMultiply : float = 3.0;

var cursor : Cursor;

var previousCursorPosition := Vector2.ZERO;

func Setup(id : int):
	super(id);
	colorBar.modulate = customization.GetColorFromPlayerNumber(id);
	playerNumberLabel.text = str("P", id);
	
	cursor = CursorManager.Manager.cursors[id];
	
	trackerLine.visible = true;
	trackerLine.Setup(id - 1, id);
	trackerLine.startPointTarget = lineTrackerStartPoint;
	trackerLine.endPointTarget = cursor.transform;
	trackerLine.heartbeat = 1.0;
	trackerLine.alphaMultiply = 8.0;
	
	var playerToken : PlayerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(id);
	var connection : Connection = Network.currentLobby.connections[playerToken.ownerId];
	var accountId : int = connection.accountId;
	accountDisplay.Setup(accountId);
	
	pass;


func _process(delta: float) -> void:
	if(!visible):
		return;
		
	if(cursor):
		var speed = (cursor.currentNormalizedPosition - previousCursorPosition).length() * delta;
		trackerLine.goalAlphaMultiply = max(speed * speedAlphaMultiply, 1.0);
		previousCursorPosition = cursor.currentNormalizedPosition;
	trackerLine.FollowTarget(delta);

func _exit_tree() -> void:
	trackerLine.queue_free();
