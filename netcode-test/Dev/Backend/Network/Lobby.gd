class_name Lobby

const MAX_CONNECTIONS = 16
const LOBBY_SPECIAL_PREFIX = "s10h56j792";

var lobbyId;
var connecting : bool;
const maxTimeConnecting : float = 3;
var timeConnecting : float = 0;
var isHost : bool;
var hostId : int;

var connections : Dictionary[int, Connection];

signal PeerDisconnectedFromMe(id : int);

func OnConnectionRequest(id : int) -> bool:
	addNewConnection(id);
	return true;

func addNewConnection(id : int):
	var connection = Connection.new();
	connection.id = id;
	connection.connected = true;
	if(connections.has(id)):
		connections[id] = connection;
	else:
		connections.set(id, connection);
		
func OnPeerDisconnect(id : int):
	connections.erase(id);
	if(isHost):
		PeerDisconnectedFromMe.emit(id);
		pass;
	else:
		pass;
		
func startConnecting():
	connecting = true;
	timeConnecting = 0;
	Network.Connecting.emit();

func HostLobby():
	Network.Log("Basic Lobby Host");
	pass;
	
func JoinLobby():
	pass;
	
func LeaveLobby():
	pass;
	
func KickConnection():
	pass;
	
func Update(dt : float):
	if(connecting):
		timeConnecting += dt;
		if(timeConnecting >= maxTimeConnecting):
			Network.TimeOut();
