class_name Lobby

const MAX_CONNECTIONS = 16
const LOBBY_SPECIAL_PREFIX = "s10h56j792";

var lobbyId;
var connecting : bool;
const maxTimeConnecting : float = 5;
var timeConnecting : float = 0;
var isHost : bool;
var hostId : int;

var connections : Dictionary[int, Connection];

signal PeerDisconnectedFromMe(id : int);

func OnConnectionRequest(id : int) -> bool:
	if(connections.size() < MAX_CONNECTIONS):
		return true;
	return false;

func AddNewConnection(id : int, accountId : int):
	var connection = Connection.new();
	connection.id = id;
	connection.accountId = accountId;
	AccountManager.LoadAccount(accountId);
	connection.connected = true;
	if(connections.has(id)):
		connections[id] = connection;
	else:
		connections.set(id, connection);
		
func GetConnectionIds() -> Array[int]:
	var ids = [] as Array[int];
	for connection in connections.values():
		ids.push_back(connection.id);
	return ids;
	
func GetAccountIds() -> Array[int]:
	var ids = [] as Array[int];
	for connection in connections.values():
		ids.push_back(connection.accountId);
	return ids;
		
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
