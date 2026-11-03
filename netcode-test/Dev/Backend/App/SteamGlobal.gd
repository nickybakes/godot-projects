extends Node

@onready var PLACEHOLDER_AVATAR = preload("res://icon.svg") as Texture2D;


# Steam variables
var isOnline: bool = false
var isOwned: bool = false
var steamAppId: int = 480
var steamId: int = -1
var displayName: String = "Player"
var steamLobbyId : int = -1;

var instanceId : String;

func _init() -> void:
	## Set your game's Steam app ID here
	instanceId = str(OS.get_process_id());
	OS.set_environment("SteamAppId", str(steamAppId))
	OS.set_environment("SteamGameId", str(steamAppId))

func _process(_delta: float) -> void:
	Steam.run_callbacks()
	
enum SteamInitStatus{
	Success,
	Failure,
	CannotConnectToSteam,
	ClientOutOfDate
}

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	
	var status : SteamInitStatus = initialize_response['status'] as SteamInitStatus;
	var verbal : String = initialize_response['verbal'];
	
	if(status == SteamInitStatus.Success):
		displayName = Steam.getPersonaName();
		isOnline = Steam.loggedOn();
		isOwned = Steam.isSubscribed();
		steamId = Steam.getSteamID();
		if isOwned == false:
			print("User does not own this game");
			#get_tree().quit()

	if(status == SteamInitStatus.Success):
		print_rich("[b]Steam initialized. Welcome " + displayName);
	else:
		match(status):
			SteamInitStatus.Failure:
				print_rich("[b]Steam initialization failure:");
			SteamInitStatus.CannotConnectToSteam:
				print_rich("[b]Cannot connect to Steam:");
			SteamInitStatus.ClientOutOfDate:
				print_rich("[b]Steam client out of date:");
	
	print(verbal);		
				
				
				
				
				
				
