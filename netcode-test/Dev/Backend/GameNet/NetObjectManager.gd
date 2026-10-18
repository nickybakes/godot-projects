extends MultiplayerSpawner
class_name NetObjectManager

var numNetObjects : int = 0;

var netObjects : Dictionary[int, NetObject];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	netObjects = {};
	if(Network.currentLobby.isHost):
		Network.currentLobby.PeerDisconnectedFromMe.connect(PeerDisconnectedFromMe);
		pass;
	else:
		rpc_id(1, "RequestHostNetObjectSync", Network.myId);
		pass;
	pass # Replace with function body.
	
func PeerDisconnectedFromMe(disconnecterId : int):
	for id in netObjects.keys():
		if(netObjects.has(id) && netObjects[id] != null && netObjects[id].ownerId == disconnecterId):
			var netObject : NetObject = netObjects[id];
			rpc("ChangeNetObjectOwner", netObject.id, 1, true);
			pass;
		pass;
	pass;
	
@rpc("any_peer", "call_remote")
func RequestHostNetObjectSync(requesterId : int):
	for id in netObjects.keys():
		if(netObjects.has(id) && netObjects[id] != null):
			var netObject : NetObject = netObjects[id];
			rpc_id(requesterId, "AcceptSpawnNetObject", netObject.originalNetObjectPath, netObject.GetSpawnParams(), netObject.id, netObject.ownerId);
			pass;
		pass;
	pass;
	
func SpawnNetObject(path : String, spawnParams : Dictionary, ownedByMe : bool):
	if(Network.currentLobby.isHost):
		RequestHostSpawnNetObject(path, spawnParams, 1);
	else:
		if(ownedByMe):
			rpc_id(1, 'RequestHostSpawnNetObject', path, spawnParams, Network.myId);
		else:
			rpc_id(1, 'RequestHostSpawnNetObject', path, spawnParams, 1);

func SpawnNetObjectWithOwnerId(path : String, spawnParams : Dictionary, ownerId : int):
	if(Network.currentLobby.isHost):
		RequestHostSpawnNetObject(path, spawnParams, ownerId);
	else:
		rpc_id(1, 'RequestHostSpawnNetObject', path, spawnParams, ownerId);
	
@rpc("any_peer","call_remote")
func RequestHostSpawnNetObject(path : String, spawnParams : Dictionary, ownerId : int):
	var curNetObjects = numNetObjects;
	numNetObjects += 1;
	rpc("AcceptSpawnNetObject", path, spawnParams, curNetObjects, ownerId);
	
@rpc("authority", "call_local")
func AcceptSpawnNetObject(path : String, spawnParams : Dictionary, objectId : int, ownerId : int):
	var netObject : NetObject = load(path).instantiate();
	netObject.Spawn(objectId, ownerId, spawnParams, path);
	netObject.name = str("Net Object ", objectId);
	netObjects.set(objectId, netObject);
	add_child(netObject);

@rpc("any_peer","call_local")
func ChangeNetObjectOwner(objectId : int, newOwnerId : int, isDisconnect : bool):
	if(netObjects[objectId] != null):
		var netObject : NetObject = netObjects[objectId];
		netObject.SetOwner(newOwnerId);
		if(Network.currentLobby.isHost && isDisconnect):
			netObject.OwnerDisconnected();
	
@rpc("any_peer","call_local")
func ConfirmSpawnNetObject(objectId : int, senderId : int):
	if(netObjects[objectId] != null):
		netObjects[objectId].set_visibility_for(senderId, true);
		netObjects[objectId].syncedIds.push_back(senderId);
		
func DestroyNetObject(objectId : int):
	if(Network.currentLobby.isHost):
		RequestHostDestroyNetObject(objectId);
	else:
		rpc_id(1, 'RequestHostDestroyNetObject', objectId);
	
@rpc("authority", "call_local")
func AcceptDestroyNetObject(objectId : int):
	if(netObjects[objectId] != null):
		for syncId in netObjects[objectId].syncedIds:
			if(Network.multiplayer.get_peers().has(syncId)):
				netObjects[objectId].set_visibility_for(syncId, false);
		netObjects[objectId].queue_free();
		netObjects[objectId] = null;
	pass;
	
@rpc("any_peer","call_remote")
func RequestHostDestroyNetObject(objectId : int):
	rpc("AcceptDestroyNetObject", objectId);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
