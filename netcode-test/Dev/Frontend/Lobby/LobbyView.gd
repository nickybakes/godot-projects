extends Control
class_name LobbyView


func hostLocalButton():
	Network.HostLobby(Network.NetworkType.ENET);

func joinLocalButton():
	Network.JoinLobby(Network.NetworkType.ENET);
