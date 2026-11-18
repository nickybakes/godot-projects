extends Control
class_name ResultsView

@export var container : VBoxContainer;
@export var winnerMessageLabel : Label;
@export var winnerMessageColorLabel : Label;
@export var winnerMessageString : String;
@export var winnerAccountDisplay : AccountDisplay;
@export var customization : CursorCustomizationDirectory;

func DisplayResults():
	var placements = GameManager.Manager.gameModeController.GetPlayerPlacements();
	var newTableHeader = GameManager.Manager.gameModeController.resultTableHeaderPrefab.duplicate();
	container.add_child(newTableHeader);
	newTableHeader.visible = true;
	
	for i in placements.size():
		var playerNumber = placements[i];
		var playerToken : PlayerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
		
		var newResultDisplay = GameManager.Manager.gameModeController.resultDisplayPrefab.duplicate();
		container.add_child(newResultDisplay);
		newResultDisplay.visible = true;
		newResultDisplay.Display(i + 1, playerToken, GameManager.Manager.balls[playerNumber].ballController, GameManager.Manager.gamePlayerLogs[playerNumber], customization);
		
		if(i == 0):
			winnerMessageLabel.text = "";
			winnerMessageColorLabel.text = "";
			winnerMessageColorLabel.modulate = customization.cursorColors[playerToken.customization.colorIndex];
			
			if(!Network.currentLobby.isLocal):
				var connection : Connection = Network.currentLobby.connections[playerToken.ownerId];
				var accountId : int = connection.accountId;
				winnerAccountDisplay.NameReady.connect(DisplayWinnerMessage);
				winnerAccountDisplay.Setup(accountId);
			else:
				DisplayWinnerMessage("Player " + str(playerNumber));

			pass;
	pass;

func DisplayWinnerMessage(displayName : String):
	var nameLength = displayName.length();
	var finalString = winnerMessageString % displayName;
	var finalLength = finalString.length();
	winnerMessageLabel.text = finalString;
	winnerMessageColorLabel.text = finalString;
	
	winnerMessageLabel.visible_characters = finalLength - nameLength;
	winnerMessageColorLabel.visible_characters = nameLength;
	
	pass;
