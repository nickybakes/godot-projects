extends Node3D
class_name Scene

@export var isBaseScene : bool;

func _ready() -> void:
	if(isBaseScene):
		SceneManager.SetBaseSceneRef(self);
