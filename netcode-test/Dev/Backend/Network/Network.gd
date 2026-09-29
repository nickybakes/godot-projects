extends MultiplayerSpawner

enum NetworkType{
	ENET,
	STEAM
}

var networkType := NetworkType.ENET;

var currentLobby : Lobby;
var purposefulDisconnect := false;
var netTime : NetTime;

var myId : int;

var serverConnectionError;

signal ConnectionFailed(message : String)
signal ConnectionAccepted()
signal Connecting()
signal Disconnect()
signal LogMessage(message : String);
#signal game_ended()
#signal game_error(what : String)
#signal game_log(what : String)

func Log(message):
	LogMessage.emit(str(message));

func _ready():
	multiplayer.connected_to_server.connect(OnConnectionToServerSucceeded)
	multiplayer.connection_failed.connect(OnConnectionToServerFailed)
	multiplayer.server_disconnected.connect(OnServerDisconnected)
	multiplayer.peer_connected.connect(OnPeerConnectedToMe);
	multiplayer.peer_disconnected.connect(OnPeerDisconnectedFromMe);
	
func OnConnectionToServerSucceeded():
	myId = multiplayer.get_unique_id();
	Log("OnConnectionToServerSucceeded");
	rpc_id(myId, "RequestConnectionToHost");
	pass;
	
func OnConnectionToServerFailed():
	CloseMultiplayer();
	pass;
	
func OnServerDisconnected():
	pass;
	
func OnPeerConnectedToMe(id : int):
	Log("OnPeerConnectedToMe");
	pass;
	
func OnPeerDisconnectedFromMe(id : int):
	pass;
	
func GetPing() -> int:
	if(netTime == null):
		return 0;
	else:
		return netTime.latency;
		
func TimeOut():
	OnConnectionToServerFailed();
	ConnectionFailed.emit("No connection found, timed out.");
	pass;
	
func CancelConnecting():
	Log("Connection canceled");
	CloseMultiplayer();
	
func CloseMultiplayer():
	if(multiplayer.multiplayer_peer != null):
		multiplayer.multiplayer_peer.close();
	multiplayer.multiplayer_peer = null;
	Log("Multiplayer closed");
	currentLobby = null;

## Lobby management functions.
@rpc("call_remote", "any_peer")
func RequestConnectionToHost(id : int):
	Log(str("Connection requested with id ", id));
#	TODO: Do any checks that may refuse a connection;
	var result = currentLobby.OnConnectionRequest(id);
	if(result):
		rpc_id(id, "OnHostAcceptsConnection");
	else:
		rpc_id(id, "OnHostDeclinesConnection");
	pass;

@rpc("call_local", "authority")
func OnHostAcceptsConnection():
	setUpTime();
	currentLobby.connecting = false;
	ConnectionAccepted.emit();
	pass;
	
@rpc("call_local", "authority")
func OnHostDeclinesConnection():
	ConnectionFailed.emit("Connection declined by host.");
	pass;
	
#region Lobbies

func HostLobby(netType : NetworkType):
	match(netType):
		NetworkType.ENET:
			currentLobby = ENetLobby.new();
		#NetworkType.STEAM:
			#Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, MAX_CONNECTIONS)
	currentLobby.HostLobby();
			
func JoinLobby(netType : NetworkType):
	match(netType):
		NetworkType.ENET:
			currentLobby = ENetLobby.new();
		#NetworkType.STEAM:
			#Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, MAX_CONNECTIONS)
	currentLobby.JoinLobby();

#endregion
	
func _process(dt : float):
	if(currentLobby != null):
		currentLobby.Update(dt);	
	
	
##region Steam Peer Management
#func create_steam_socket():
	#var peer = SteamMultiplayerPeer.new()
	#multiplayer.multiplayer_peer.create_host(0, [])
	#multiplayer.set_multiplayer_peer(peer)
	#rpc_id(1, "register_player_connection");
#
#func connect_steam_socket(steam_id : int):
	#var peer = SteamMultiplayerPeer.new()
	#peer.create_client(steam_id, 0)
	#multiplayer.set_multiplayer_peer(peer)
##endregion
	
#region Time

func setUpTime():
	netTime = NetTime.new();
	add_child(netTime);
	pass;

@rpc("call_local", "any_peer")
func fetchServerTime(clientTicksMsec : int):
	var id = multiplayer.get_remote_sender_id();
	rpc_id(id, "receiveServerTime", Time.get_ticks_msec(), clientTicksMsec);

@rpc("call_local", "any_peer")
func receiveServerTime(serverTicksMsec : int, clientTicksMsec : int):
	netTime.receiveServerTime(serverTicksMsec, clientTicksMsec);
	
@rpc("call_local", "any_peer")
func determineLatency(clientTicksMsec : int):
	var id = multiplayer.get_remote_sender_id();
	rpc_id(id, "receiveLatency", clientTicksMsec);
	
@rpc("call_local", "any_peer")
func receiveLatency(clientTicksMsec : int):
	netTime.receiveLatency(clientTicksMsec);

#endregion
