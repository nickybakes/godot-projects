extends MultiplayerSynchronizer
class_name NetObject

var originalNetObjectPath : String;
var spawnParams : Dictionary;
var isDummy : bool;
var id : int;
var ownerId : int;

func Spawn(_id : int, _ownerId : int, _spawnParams : Dictionary, _originalNetObjectPath : String):
	id = _id;
	spawnParams = _spawnParams;
	originalNetObjectPath = _originalNetObjectPath;
	SetOwner(_ownerId);
	DoSpawnParams();
	
func SetOwner(newOwnerId : int):
	ownerId = newOwnerId;
	set_multiplayer_authority(ownerId);
	isDummy = newOwnerId != Network.myId;
	if(!isDummy):
		public_visibility = false;
	else:
		GameNetManager.GameNet.netObjectManager.rpc_id(ownerId, "ConfirmSpawnNetObject", id, Network.myId)

func DoSpawnParams():
	pass;
