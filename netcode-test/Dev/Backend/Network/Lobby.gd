extends Node
class_name Lobby

const MAX_CONNECTIONS = 16
const LOBBY_SPECIAL_PREFIX = "s10h56j792";

var lobbyId;
var isHost : bool;
var hostId : int;

var connections : Dictionary[int, Connection];

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

func HostLobby():
	Network.Log("Basic Lobby Host");
	pass;
	
func JoinLobby():
	pass;
	
func LeaveLobby():
	pass;
	
func DestroyLobby():
	pass;
	
func KickConnection():
	pass;
