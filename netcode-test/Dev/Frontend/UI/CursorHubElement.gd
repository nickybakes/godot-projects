extends HubElement
class_name CursorHubElement

@export var colorBar : CanvasItem;
@export var playerNumberLabel : Label;
@export var lineTrackerStartPoint : Control;
@export var accountDisplay : AccountDisplay;

func Setup(id : int):
	super(id);
	colorBar.modulate = CursorManager.Manager.GetColorFromPlayerNumber(id);
	playerNumberLabel.text = str("P", id);
	
	var playerToken : PlayerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(id);
	var connection : Connection = Network.currentLobby.connections[playerToken.ownerId];
	var accountId : int = connection.accountId;
	accountDisplay.Setup(accountId);
	
	pass;
