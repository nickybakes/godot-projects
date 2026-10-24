extends Node
class_name SceneGlobal

signal LoadDone()
signal LoadStarted()
signal LoadProgress(progress : float)

var baseSceneReference : Scene;

@export var scenePaths : Dictionary[SCENE, String];

var currentScene : SCENE;

var sceneObjects : Dictionary[SCENE, Scene];

enum SCENE{
	BaseScene,
	LobbyScene,
	ArenaScene_01,
}

func _ready() -> void:
	sceneObjects = {};
	
func SetBaseSceneRef(baseScene : Scene):
	baseSceneReference = baseScene;
	sceneObjects.set(SCENE.BaseScene, baseScene);

func LoadScene(scene : SCENE):
	var previousScene := currentScene;	
	currentScene = scene;
	
	if(sceneObjects.has(previousScene) && sceneObjects[previousScene] != null):
		sceneObjects[previousScene].set_process(false);
		sceneObjects[previousScene].queue_free();
			
	var sceneObject : Scene = load(scenePaths[scene]).instantiate();
	sceneObjects.set(currentScene, sceneObject);
	get_parent().add_child(sceneObject);
	pass;
