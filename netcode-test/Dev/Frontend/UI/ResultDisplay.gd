extends Control
class_name ResultDisplay

@export var placement : Label;
@export var accountDisplay : AccountDisplay;
@export var nameLabel : Label;
@export var avatarDisplay : TextureRect;
@export var damageDone : Label;
@export var damageTaken : Label;
@export var knockouts : Label;
@export var eliminations : Label;
@export var colorBG : CanvasItem;

func Display(place : int, playerToken : PlayerToken, ballController : BallMCC, log : GamePlayerLog, customization : CursorCustomizationDirectory):
	if(placement):
		placement.text = str(place) + ".";
	
	if(!Network.currentLobby.isLocal && accountDisplay):
		var connection : Connection = Network.currentLobby.connections[playerToken.ownerId];
		var accountId : int = connection.accountId;
		accountDisplay.Setup(accountId);
	elif(nameLabel):
		avatarDisplay.texture = AccountManager.PLACEHOLDER_AVATAR;
		nameLabel.text = AccountManager.GetLocalAccountName(playerToken.playerNumber);
		
	var damageScale = 100.0/ballController.healthStat.maxValue;
	
	if(damageDone):
		damageDone.text = "%.0f" % roundf(log.GetTotalDamageDealt() * damageScale);
		
	if(damageTaken):
		damageTaken.text = "%.0f" % roundf(log.GetTotalDamageTaken() * damageScale);
		
	if(knockouts):
		knockouts.text = "%s" % log.GetTotalKnockOutsDealt();
		
	if(eliminations):
		eliminations.text = "%s" % log.GetTotalEliminationsDealt();
		
	if(nameLabel):
		nameLabel.modulate = customization.cursorColors[playerToken.customization.colorIndex];
		
	if(colorBG):
		colorBG.modulate = customization.cursorColors[playerToken.customization.colorIndex];
	pass;
