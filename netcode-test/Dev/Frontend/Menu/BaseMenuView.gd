extends Control

@export var myAccountDisplay : AccountDisplay;

@export var steamLoggedOutView : Control;
@export var steamLoggedInView : Control;

@export var lobbySearch : LobbySearch;

func _ready() -> void:
	SetSteamView();
	pass;

func hostLocalButton():
	Network.HostLobby(Network.NetworkType.ENET);

func joinLocalButton():
	Network.JoinLobby(Network.NetworkType.ENET);
	
func HostSteamLobbyButton():
	Network.HostLobby(Network.NetworkType.STEAM);
	

func SteamLogInButton():
	SteamGlobal.initialize_steam();
	SetSteamView();

func SetSteamView():
	steamLoggedOutView.visible = (!SteamGlobal.isOnline);
	steamLoggedInView.visible = (SteamGlobal.isOnline);
	if(SteamGlobal.isOnline):
		lobbySearch.RequestLobbies();
	myAccountDisplay.Setup(AccountManager.myAccountId);
	pass
