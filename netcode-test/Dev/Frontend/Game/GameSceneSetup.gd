extends Node3D
class_name GameSceneSetup

static var GSS : GameSceneSetup;

@export var spawnCircle : Node3D;
@export_range(0, 1, .01) var spawnOffset : float;


func _ready() -> void:
	GSS = self;
	spawnCircle.visible = false;


func GetSpawnPosition(spawnIndex : int, totalSpawns : int) -> Vector3:
	totalSpawns = max(totalSpawns, 1);
	var newPosition = Vector3.ZERO;
	newPosition.y = spawnCircle.position.y;
	
	var posOnCircle = (spawnOffset + (spawnIndex as float / totalSpawns as float)) * PI * 2;
	
	newPosition.x = (cos(posOnCircle) * spawnCircle.scale.x) + spawnCircle.position.x;
	newPosition.z = (sin(posOnCircle) * spawnCircle.scale.z) + spawnCircle.position.z;
	
	return newPosition;
