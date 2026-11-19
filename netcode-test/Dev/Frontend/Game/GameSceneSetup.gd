extends Node3D
class_name GameSceneSetup

static var GSS : GameSceneSetup;

@export var spawnCircle : Node3D;
@export_range(0, 1, .01) var spawnOffset : float;

@export var respawnPointsParent : Node3D;

@export var battleRoyaleRingStartRadius : float = 50.0;
@export var ringPointsParent : Node3D;

@export var mapMax : Node3D;
@export var mapMin : Node3D;


var respawnPoints : Array[RespawnPoint];
var ringPoints : Array[RingPoint];

func _ready() -> void:
	GSS = self;
	spawnCircle.visible = false;
	GatherRespawnPoints();
	GatherRingPoints();

func GatherRespawnPoints():
	respawnPoints = [];
	for child in respawnPointsParent.get_children():
		if(child is RespawnPoint):
			respawnPoints.push_back(child as RespawnPoint);
			
func GetRandomSpawnPointPosition() -> Vector3:
	return respawnPoints.pick_random().global_position;
	
func GatherRingPoints():
	ringPoints = [];
	for child in ringPointsParent.get_children():
		if(child is RingPoint):
			ringPoints.push_back(child as RingPoint);
			
func GetRandomRingPoint() -> RingPoint:
	return ringPoints.pick_random();

func GetSpawnPosition(spawnIndex : int, totalSpawns : int) -> Vector3:
	totalSpawns = max(totalSpawns, 1);
	var newPosition = Vector3.ZERO;
	newPosition.y = spawnCircle.position.y;
	
	var posOnCircle = (spawnOffset + (spawnIndex as float / totalSpawns as float)) * PI * 2;
	
	newPosition.x = (cos(posOnCircle) * spawnCircle.scale.x) + spawnCircle.position.x;
	newPosition.z = (sin(posOnCircle) * spawnCircle.scale.z) + spawnCircle.position.z;
	
	return newPosition;
