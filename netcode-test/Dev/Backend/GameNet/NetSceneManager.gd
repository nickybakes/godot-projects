extends MultiplayerSpawner
class_name NetSceneManager

@export var defaultLobbyScene := SceneManager.SCENE.LobbyScene;
@export var leaveServerScene := SceneManager.SCENE.BaseScene;
@export var disconnectScene := SceneManager.SCENE.BaseScene;

func _ready() -> void:
	Network.Disconnected.connect(OnDisconnectSceneLoad);
	if(Network.currentLobby.isHost):
		AcceptLoadScene(defaultLobbyScene);
		pass;
	else:
		rpc_id(1, "RequestHostSceneSync", Network.myId);
		pass;
	pass

@rpc("any_peer", "call_remote")
func RequestHostSceneSync(requesterId : int):
	rpc_id(requesterId, "AcceptLoadScene", SceneManager.currentScene);
	pass;
	
func SwitchScene(scene : SceneManager.SCENE):
	if(Network.currentLobby.isHost):
		RequestHostSwitchScene(scene);
	else:
		rpc_id(1, 'RequestHostSwitchScene', scene);
		
@rpc("any_peer","call_remote")
func RequestHostSwitchScene(scene : SceneManager.SCENE):
	rpc("AcceptLoadScene", scene);
	
@rpc("authority", "call_local")
func AcceptLoadScene(scene : SceneManager.SCENE):
	Network.Log("Net Loading scene: " + SceneManager.SCENE.keys()[scene]);
	SceneManager.LoadScene(scene);
	pass;
	
func OnDisconnectSceneLoad():
	if(Network.purposefulDisconnect):
		SceneManager.LoadScene(leaveServerScene);
	else:
		SceneManager.LoadScene(disconnectScene);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
