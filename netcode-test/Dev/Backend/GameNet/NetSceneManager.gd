extends MultiplayerSpawner
class_name NetSceneManager

var sceneObject : Node;

var lobbyScenePath : String = "uid://b5452rgondapk";

var currentScene : SCENE;

enum SCENE{
	LobbyScene,
}


func _ready() -> void:
	if(Network.currentLobby.isHost):
		AcceptLoadScene(SCENE.LobbyScene);
		pass;
	else:
		rpc_id(1, "RequestHostScene", Network.myId);
		pass;
	pass

@rpc("any_peer", "call_remote")
func RequestHostScene(requesterId : int):
	rpc_id(requesterId, "AcceptLoadScene", currentScene);
	pass;
	
@rpc("authority", "call_local")
func AcceptLoadScene(scene : SCENE):
	Network.Log("Loading scene: " + SCENE.keys()[scene]);
	if(sceneObject != null):
		sceneObject.free();
		
	var path = "";
	match(scene):
		SCENE.LobbyScene:
			path = lobbyScenePath;
			
	currentScene = scene;
			
	sceneObject = load(path).instantiate();
	sceneObject.name = str("Scene");
	add_child(sceneObject);
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
