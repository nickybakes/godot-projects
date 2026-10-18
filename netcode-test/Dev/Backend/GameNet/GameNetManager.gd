extends MultiplayerSpawner
class_name GameNetManager

static var GameNet : GameNetManager

@onready var netObjectManager: NetObjectManager = $NetObjectManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameNet = self;
	if(Network.currentLobby.isHost):
		pass;
	else:
		pass;

#func SpawnNetObjectWithSpecificAuthority(netObject : NetObject, spawnParams : String, _ownerId : int):
	#netObjectManager.SpawnNetObject.rpc(netObject, spawnParams, _ownerId);
#
#func SpawnNetObjectWithMyAuthority(netObject : NetObject, spawnParams : String):
	#netObjectManager.SpawnNetObject.rpc(netObject, spawnParams, Network.myId);

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
