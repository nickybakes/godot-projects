extends Node
class_name GameModeOptionsList

@export var gameMode : Enums.GameMode;

@export var infiniteLives : bool = true;
@export var numLives : bool = true;

@export var timeLength : bool = true;
@export var infiniteScore : bool = true;
@export var scoreLimit : bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
