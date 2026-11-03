extends Panel
class_name LobbySearch

@export var lobbySelectioinPrefab : LobbySelection;

@export var lobbyContainer : Container;
@export var refreshButton : Button;
@export var noLobbiesFoundLabel : Label;

var initialized : bool;

func _exit_tree() -> void:
	if(initialized):
		Steam.lobby_match_list.disconnect(DisplayLobbies);
		
func JoinLobby(lobbyId : int):
	SteamGlobal.steamLobbyId = lobbyId;
	Network.JoinLobby(Network.NetworkType.STEAM);

func RefreshPressed():
	RequestLobbies();
	pass;

func RequestLobbies():
	if(!initialized):
		Steam.lobby_match_list.connect(DisplayLobbies);
		initialized = true;
		
	refreshButton.disabled = true;
	noLobbiesFoundLabel.visible = false;
	ClearLobbies();
	
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList();
	pass;

func DisplayLobbies(lobbyIds : Array):
	refreshButton.disabled = false;
	ClearLobbies();
	
	if(lobbyIds.size() == 0):
		noLobbiesFoundLabel.visible = true;
		return;
	
	var actualLobbiesFound : int = 0;
	
	for lobbyId in lobbyIds:
		var lobbyName : String = Steam.getLobbyData(lobbyId, "name");
		var actualLobbyName : String = lobbyName.replace(Lobby.LOBBY_SPECIAL_PREFIX, "");
		
		if(!lobbyName.begins_with(Lobby.LOBBY_SPECIAL_PREFIX)):
			continue;
			
		var newLobbySelection : LobbySelection = lobbySelectioinPrefab.duplicate();
		lobbyContainer.add_child(newLobbySelection);
		newLobbySelection.visible = true;
		newLobbySelection.searchPanel = self;
		newLobbySelection.lobbyId = lobbyId;
		newLobbySelection.DisplayLobby(actualLobbyName);
			
		actualLobbiesFound += 1;
		pass;
		
	if(actualLobbiesFound == 0):
		noLobbiesFoundLabel.visible = true;
		return;
	
	pass;

func ClearLobbies():
	for child in lobbyContainer.get_children():
		child.queue_free();
