extends Control
class_name LobbyView

@onready var outsideLobbyView: Control = $"Outside Lobby View"
@onready var insideLobbyHost: Control = $"Inside Lobby Host"
@onready var insideLobbyMember: Control = $"Inside Lobby Member"
@onready var insideLobby: Control = $"Inside Lobby"


func _ready():
	Network.HostSuccess.connect(OnHostSuccess);
	Network.ConnectionAccepted.connect(OnJoinSuccess);
	Network.Disconnected.connect(ResetLobby);
	ResetLobby();
	
	
func OnHostSuccess():
	outsideLobbyView.visible = false;
	insideLobbyHost.visible = true;
	insideLobbyMember.visible = false;
	insideLobby.visible = true;
	pass;
	
func OnJoinSuccess():
	outsideLobbyView.visible = false;
	insideLobbyHost.visible = false;
	insideLobbyMember.visible = true;
	insideLobby.visible = true;
	pass;
	
func ResetLobby():
	outsideLobbyView.visible = true;
	insideLobbyHost.visible = false;
	insideLobbyMember.visible = false;
	insideLobby.visible = false;

func hostLocalButton():
	Network.HostLobby(Network.NetworkType.ENET);

func joinLocalButton():
	Network.JoinLobby(Network.NetworkType.ENET);
	
func stopHostButton():
	Network.DisconnectFromServer();
	
func leaveLobbyButton():
	Network.DisconnectFromServer();
	
const PRE_NET_BALL_01 = "uid://oq33tksc2sxh";
	
func spawnBallButton():
	var ballPosition = Vector3(randf() * 6 - 3, randf() * 5 - 2.5, -5);
	var spawnParams = {"position": ballPosition, "rotation": Vector3.ZERO, "scale": Vector3.ONE, "visible": true};
	GameNetManager.GameNet.netObjectManager.SpawnNetObject(PRE_NET_BALL_01, spawnParams, true);
	pass;
