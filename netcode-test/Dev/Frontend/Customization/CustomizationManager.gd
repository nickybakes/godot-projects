extends Node
class_name CustomizationManager


static var Manager : CustomizationManager;

@export var cursorCustomization : CursorCustomizationDirectory;

var playerNumberToColorIndex : Dictionary[int, int];

func _ready() -> void:
	Manager = self;
	if(Network.currentLobby.isHost):
		for token in LobbyManager.Lobby.playerTokens:
			playerNumberToColorIndex.set(token.playerNumber, token.customization.colorIndex);
		LobbyManager.Lobby.PlayerJoinAccepted.connect(OnPlayerJoined);
		LobbyManager.Lobby.PlayerRemoved.connect(OnPlayerRemoved);

func OnPlayerJoined(playerToken : PlayerToken):
	playerNumberToColorIndex.set(playerToken.playerNumber, playerToken.customization.colorIndex);
	pass;
	
func OnPlayerRemoved(playerNumber : int, clientId : int, inputDevice : int):
	playerNumberToColorIndex.erase(playerNumber);
	pass;
	
func _exit_tree() -> void:
	if(LobbyManager.Lobby && Network.currentLobby && Network.currentLobby.isHost):
		LobbyManager.Lobby.PlayerJoinAccepted.disconnect(OnPlayerJoined);	
		LobbyManager.Lobby.PlayerRemoved.disconnect(OnPlayerRemoved);	

func CycleColor(currentColor : int, direction : int, playerNumber : int):
	if(Network.currentLobby.isHost):
		RequestCycleColor(currentColor, direction, playerNumber);
	else:
		rpc_id(1, 'RequestCycleColor', currentColor, direction, playerNumber);
	pass;

@rpc("any_peer", "call_remote")
func RequestCycleColor(currentColor : int, direction : int, playerNumber : int):
	var newColorIndex : int = GetNextAvailableColor(currentColor, direction);
	
	playerNumberToColorIndex[playerNumber] = newColorIndex;
	rpc('ConfirmColorChange', newColorIndex, playerNumber);
	pass;
	
func GetNextAvailableColor(currentColor : int, direction : int) -> int:
	var newColorIndex : int = currentColor;
	var conflict : bool = true;
	while(conflict):
		conflict = false;
		
		for conflictNumber in playerNumberToColorIndex:
			if(newColorIndex == playerNumberToColorIndex[conflictNumber]):
				conflict = true;
		
		if(conflict):
			newColorIndex += direction;
			newColorIndex = newColorIndex % cursorCustomization.cursorColors.size();
					
	return newColorIndex;
	
@rpc("authority", "call_local")
func ConfirmColorChange(newColorIndex : int, playerNumber : int):
	var token = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
	if(!token.isDummy):
		token.customization.colorIndex = newColorIndex;
		if(CursorManager.Manager):
			CursorManager.Manager.cursors[playerNumber].requestedColorCycle = false;
		pass;
	pass;
