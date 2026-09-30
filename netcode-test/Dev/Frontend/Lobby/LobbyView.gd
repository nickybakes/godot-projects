extends Control
class_name LobbyView

@onready var outsideLobbyView: Control = $"Outside Lobby View"
@onready var insideLobbyHost: Control = $"Inside Lobby Host"
@onready var insideLobbyMember: Control = $"Inside Lobby Member"


func _ready():
	Network.HostSuccess.connect(OnHostSuccess);
	Network.ConnectionAccepted.connect(OnJoinSuccess);
	Network.Disconnected.connect(ResetLobby);
	ResetLobby();
	
	
func OnHostSuccess():
	outsideLobbyView.visible = false;
	insideLobbyHost.visible = true;
	insideLobbyMember.visible = false;
	pass;
	
func OnJoinSuccess():
	outsideLobbyView.visible = false;
	insideLobbyHost.visible = false;
	insideLobbyMember.visible = true;
	pass;
	
func ResetLobby():
	outsideLobbyView.visible = true;
	insideLobbyHost.visible = false;
	insideLobbyMember.visible = false;

func hostLocalButton():
	Network.HostLobby(Network.NetworkType.ENET);

func joinLocalButton():
	Network.JoinLobby(Network.NetworkType.ENET);
	
func stopHostButton():
	Network.DisconnectFromServer();
	
func leaveLobbyButton():
	Network.DisconnectFromServer();
