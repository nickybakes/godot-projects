extends Panel
class_name LobbySelection

@export var nameLabel : Label;

var searchPanel : LobbySearch;
var lobbyId : int;

func JoinButtonPressed():
	searchPanel.JoinLobby(lobbyId);
	pass;

func DisplayLobby(lobbyName : String):
	nameLabel.text = lobbyName;
	pass;
