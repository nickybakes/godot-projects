class_name ENetLobby
extends Lobby

# Default game server port. Can be any number between 1024 and 49151.
# Not on the list of registered or common ports as of November 2020:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const DEFAULT_PORT = 10567

func HostLobby():
	Network.Log("ENET Lobby Host");
	isHost = true;
	connecting = false;
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new();
	var hostMessage : Error = (peer as ENetMultiplayerPeer).create_server(DEFAULT_PORT, MAX_CONNECTIONS);
	Network.Log(error_string(hostMessage));
	Network.multiplayer.set_multiplayer_peer(peer);
	pass;
	
func JoinLobby():
	isHost = false;
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new();
	var joinMessage : Error = peer.create_client("127.0.0.1", DEFAULT_PORT);
	Network.Log(error_string(joinMessage));
	Network.multiplayer.set_multiplayer_peer(peer);
	startConnecting();
	pass;
	
func LeaveLobby():
	Network.purposefulDisconnect = true;
	Network.CloseMultiplayer();
	pass;
