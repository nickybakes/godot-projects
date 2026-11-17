extends Node
class_name GamePlayerLog

var playerNumber : int;

var damageDealtToPlayers : Dictionary[int, float] = {};
var damageTakenFromPlayers : Dictionary[int, float] = {};

var damageIBlockedFromPlayers : Dictionary[int, float] = {};
var damagePlayersBlockedFromMe : Dictionary[int, float] = {};

var knockOutsDealtToPlayers : Dictionary[int, int] = {};
var knockOutsDealtToMe : Dictionary[int, int] = {};

var eliminationsDoneByMe : Dictionary[int, int] = {};
var eliminatedBy : int = -1;

func _init(_playerNumber : int) -> void:
	playerNumber = _playerNumber;
	for i in LobbyManager.Lobby.MAX_PLAYERS:
		RegisterNewPlayer(i);

func RegisterNewPlayer(otherPlayerNumber : int):
	damageDealtToPlayers.set(otherPlayerNumber, 0);
	damageTakenFromPlayers.set(otherPlayerNumber, 0);
	damageIBlockedFromPlayers.set(otherPlayerNumber, 0);
	damagePlayersBlockedFromMe.set(otherPlayerNumber, 0);
	knockOutsDealtToPlayers.set(otherPlayerNumber, 0);
	knockOutsDealtToMe.set(otherPlayerNumber, 0);
	eliminationsDoneByMe.set(otherPlayerNumber, 0);
	
func GetTotalDamageDealt() -> float:
	return GetTotalFloat(damageDealtToPlayers);
	
func GetTotalDamageTaken() -> float:
	return GetTotalFloat(damageTakenFromPlayers);
	
func GetTotalDamageIBlocked() -> float:
	return GetTotalFloat(damageIBlockedFromPlayers);
	
func GetTotalBlockedFromMe() -> float:
	return GetTotalFloat(damagePlayersBlockedFromMe);
	
func GetTotalKnockOutsDealt() -> int:
	return GetTotalInt(knockOutsDealtToPlayers);
	
	
func GetTotalKnockOutsRecieved() -> int:
	return GetTotalInt(knockOutsDealtToMe);
	
func GetTotalEliminationsDealt() -> int:
	return GetTotalInt(eliminationsDoneByMe);
	
func GetTotalFloat(dict : Dictionary[int, float]) -> float:
	var total = 0.0;
	for amount in dict.values():
		total += amount;
	return total;
	
func GetTotalInt(dict : Dictionary[int, int]) -> int:
	var total = 0;
	for amount in dict.values():
		total += amount;
	return total;

func GetAsDict() -> Dictionary:
	var dict = {};
	dict["playerNumber"] = playerNumber;
	dict["damageDealtToPlayers"] = damageDealtToPlayers;
	dict["damageTakenFromPlayers"] = damageTakenFromPlayers;
	dict["damageIBlockedFromPlayers"] = damageIBlockedFromPlayers;
	dict["damagePlayersBlockedFromMe"] = damagePlayersBlockedFromMe;
	dict["knockOutsDealtToPlayers"] = knockOutsDealtToPlayers;
	dict["knockOutsDealtToMe"] = knockOutsDealtToMe;
	dict["eliminationsDoneByMe"] = eliminationsDoneByMe;
	dict["eliminatedBy"] = eliminatedBy;
	return dict;
	
func ParseDict(dict : Dictionary):
	playerNumber = dict["playerNumber"];
	damageDealtToPlayers = dict["damageDealtToPlayers"];
	damageTakenFromPlayers = dict["damageTakenFromPlayers"];
	damageIBlockedFromPlayers = dict["damageIBlockedFromPlayers"];
	damagePlayersBlockedFromMe = dict["damagePlayersBlockedFromMe"];
	knockOutsDealtToPlayers = dict["knockOutsDealtToPlayers"];
	knockOutsDealtToMe = dict["knockOutsDealtToMe"];
	eliminationsDoneByMe = dict["eliminationsDoneByMe"];
	eliminatedBy = dict["eliminatedBy"];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
