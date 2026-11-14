extends Node3D
class_name RingOfFire

@export_category("Ring")
@export var radius : float = 5.0;

@export_category("Embers")
@export var numParticles : int = 32;
@export var emberPrefab : RingEmber;
@export var emberContainer : Node3D;
@export var radiusToParticleRatio : Curve;
@export var radiusToDisableParticles = 1.0;

@export_category("Commands")
#@export_tool_button("Create Ember Particles") var createEmberParticlesAction = CreateEmberParticles;
#@export_tool_button("Delete Ember Particles") var deleteEmberParticlesAction = DeleteEmberParticles;
	
var currentPosition : Vector3 = Vector3(0, 0, 0);
var currentRadius : float = 1;
var particlesDisabled : bool = false;

var embers : Array[RingEmber] = [];

func _ready() -> void:
	emberPrefab.visible = false;
	CreateEmberParticles();
	pass;

func _process(delta):
	UpdateScaleAndPosition();
	#if(position != currentPosition):
		#currentPosition = position;
		#RenderingServer.global_shader_parameter_set("ringCenter", Vector2(currentPosition.x, currentPosition.z));
	#if(scale.x != currentRadius):
		#currentRadius = scale.x;
		#RenderingServer.global_shader_parameter_set("ringRadius", scale.x);
	pass;
	
func UpdateScaleAndPosition():
	scale.x = radius;
	scale.y = 1.0;
	scale.z = scale.x;
	UpdateParticleRatio();
	SetDisabledParticles(radius <= radiusToDisableParticles);

func UpdateParticleRatio():
	var newRatio = radiusToParticleRatio.sample(radius);
	
	for ember in embers:
		ember.particles.amount_ratio = newRatio;
	
func SetDisabledParticles(disabled : bool):
	if(particlesDisabled == disabled || !embers):
		return;
		
	particlesDisabled = disabled;
		
	for ember in embers:
		ember.visible = !disabled;	
		
#func SetHalvedParticles(halved : bool):
	#if(particlesHalved == halved || !embers):
		#return;
	#particlesHalved = halved;
	#
	#for index in emberContainer.get_child_count():
		#if(index % 2 == 0):
			#var child = emberContainer.get_child(index) as RingEmber;
			#child.visible = !particlesHalved;

func DeleteEmberParticles():
	embers = [];
	for index in emberContainer.get_child_count():
		var child = emberContainer.get_child(0);
		emberContainer.remove_child(child);
		child.queue_free();

func CreateEmberParticles():
	DeleteEmberParticles();
	
	embers = [];
	for i in numParticles:
		var newEmber = emberPrefab.duplicate() as RingEmber;
		newEmber.visible = true;
		var currentAngle = (i as float/numParticles as float) * (PI*2.0);
		emberContainer.add_child(newEmber, true);
		embers.push_back(newEmber);
		newEmber.position = Vector3(cos(currentAngle), 0, sin(currentAngle));
		newEmber.rotation = Vector3(0, -currentAngle, 0);
	pass;
