extends HubElement
class_name CursorHubElement

@export var colorBar : CanvasItem;
@export var playerNumberLabel : Label;
@export var lineTrackerStartPoint : Control;
@export var accountDisplay : AccountDisplay;
@export var trackerLine : TrackerLine;

func Setup(id : int):
	super(id);
	colorBar.modulate = CursorManager.Manager.cursorCustomizationDirectory.GetColorFromPlayerNumber(id);
	playerNumberLabel.text = str("P", id);
	
	trackerLine.Setup(id - 1);
	trackerLine.startPointTarget = lineTrackerStartPoint;
	trackerLine.endPointTarget = CursorManager.Manager.cursors[id].transform;
	
	var playerToken : PlayerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(id);
	var connection : Connection = Network.currentLobby.connections[playerToken.ownerId];
	var accountId : int = connection.accountId;
	accountDisplay.Setup(accountId);
	
	pass;


func _process(delta: float) -> void:
	trackerLine.FollowTarget(delta);
