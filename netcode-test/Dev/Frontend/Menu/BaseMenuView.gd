extends Control

@export var usernameLabel : Label;

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
	steamLoggedOutView.visible = (!SteamGlobal.is_online);
	steamLoggedInView.visible = (SteamGlobal.is_online);
	usernameLabel.text = SteamGlobal.displayName;
	if(SteamGlobal.is_online):
		lobbySearch.RequestLobbies();
	pass
