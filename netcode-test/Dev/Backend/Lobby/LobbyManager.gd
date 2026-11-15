extends Node
class_name LobbyManager;

static var Lobby : LobbyManager;

const MAX_PLAYERS = 8;

var playerTokens : Array[PlayerToken] = [];

signal PlayerJoinAccepted(playerToken : PlayerToken)
signal PlayerRemoved(playerNumber : int, clientId : int, inputDevice : int)

var canPlayersJoin = true;
var canPlayersLeave = true;

var matchOptions : Dictionary[Enums.MatchOption, int];
@export var defaultMatchOptions : Dictionary[Enums.MatchOption, int];



func _ready() -> void:
	matchOptions = defaultMatchOptions.duplicate();
	Lobby = self;


func RequestPlayerJoin():
	Network.Log("Player requested to join!");
	pass;
	
func CanPlayerJoin() -> bool:
	if(playerTokens.size() >= MAX_PLAYERS):
		return false;
	if(!canPlayersJoin):
		return false;
	return true;
	
func CanPlayerLeave() -> bool:
	if(!canPlayersLeave):
		return false;
	return true;
	
func GetNextAvailablePlayerNumber() -> int:
	var number = 1;
	var isUnique = false;
	while(!isUnique):
		isUnique = true;
		for playerToken : PlayerToken in playerTokens:
			if(number == playerToken.playerNumber):
				isUnique = false;
				number += 1;
				break;
		
	
	return number;

func PlayerTokenCreated(playerToken : PlayerToken):
	playerTokens.push_back(playerToken);
	PlayerJoinAccepted.emit(playerToken)
	
func PlayerTokenDestroyed(playerToken : PlayerToken):
	playerTokens.erase(playerToken);
	PlayerRemoved.emit(playerToken.playerNumber, playerToken.originalOwnerId, playerToken.deviceId);

func HasLocalPlayerWithInputDevice(inputDevice : InputDevice) -> bool:
	for playerToken in playerTokens:
		if(playerToken.originalOwnerId == Network.myId && playerToken.deviceId == inputDevice.device):
			return true;
		pass;
	return false;
	
func GetPlayerTokenByPlayerNumber(playerNumber : int) -> PlayerToken:
	var playerToken = playerTokens[0];
	for token in playerTokens:
		if(token.playerNumber == playerNumber):
			return token;
	return playerToken;

func _process(delta: float) -> void:
	pass;
	
	
	
@rpc("any_peer", "call_remote")
func RequestHostMatchOptionsSync(requesterId : int):
	rpc_id(requesterId, "AcceptMatchOptions", matchOptions);
	pass;
	
func SetMatchOptions(options : Dictionary[Enums.MatchOption, int]):
	if(Network.currentLobby.isHost):
		RequestSetMatchOptions(options);
	else:
		rpc_id(1, 'RequestSetMatchOptions', options);
		
@rpc("any_peer","call_remote")
func RequestSetMatchOptions(options : Dictionary[Enums.MatchOption, int]):
	rpc("AcceptMatchOptions", options);
	
@rpc("authority", "call_local")
func AcceptMatchOptions(options : Dictionary[Enums.MatchOption, int]):
	matchOptions = options;
	if(MatchOptions.Instance):
		MatchOptions.Instance.UpdateMatchOptions(matchOptions);
	pass;
