extends Node3D
class_name RingEmber

@export var moveTime : float = .4;
@export var particleContainer : Node3D;
@export var particles : GPUParticles3D;
@export var raycast : RayCast3D;

var prevHeight : float = 0.0;
var newHeight : float = 0.0;
var clock : float = 0.0;

func _ready():
	prevHeight = 0.0;
	newHeight = 0.0;
	clock = 0.0;
	SampleNewHeight();

func _process(delta: float) -> void:
	if(!visible):
		return;
		
	clock += delta;
	particleContainer.global_position.y = lerp(prevHeight, newHeight, clock/moveTime);
	if(clock >= moveTime):
		SampleNewHeight();
		clock = 0.0;
	pass

func SampleNewHeight():
	raycast.enabled = true;
	raycast.force_raycast_update();
	prevHeight = newHeight;
	particleContainer.visible = raycast.is_colliding();
	if(raycast.is_colliding()):
		newHeight = raycast.get_collision_point().y;
		pass;
	pass;
