extends Node

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
		AccountManager.myAccountId = steamId;
		AccountManager.accountType = AccountManager.AccountType.STEAM;
		Steam.avatar_loaded.connect(OnSteamAvatarLoaded);
		Steam.persona_state_change.connect(SteamPersonaChange);
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
				

func SteamPersonaChange(id : int, flags : int):
	AccountManager.LoadAccount(id, true);
	pass;
				
func OnSteamAvatarLoaded(id : int, size : int, buffer : PackedByteArray):
	var maxAvatarSize : int = 256;
	
	# Create the image and texture for loading
	var avatarImage : Image = Image.create_from_data(size, size, false, Image.FORMAT_RGBA8, buffer)

	# Optionally resize the image if it is too large
	if size > maxAvatarSize:
		avatarImage.resize(maxAvatarSize, maxAvatarSize, Image.INTERPOLATE_LANCZOS)
		
	var avatarTexture: ImageTexture = ImageTexture.create_from_image(avatarImage);
	
	AccountManager.accounts[id].SetAvatar(avatarTexture);
	pass;
