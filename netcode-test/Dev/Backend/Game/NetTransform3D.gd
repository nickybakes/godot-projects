extends NetObject
class_name NetTransform3D

@export var transform : Node3D;

@export var position : Vector3;
@export var rotation : Vector3;
@export var scale : Vector3;
@export var visible : bool;

#func _ready() -> void:

	
func DoSpawnParams():
	if(spawnParams.has("position")):
		position = spawnParams["position"];
		transform.position = spawnParams["position"];
	if(spawnParams.has("rotation")):
		rotation = spawnParams["rotation"];
		transform.rotation = spawnParams["rotation"];
	if(spawnParams.has("scale")):
		scale = spawnParams["scale"];
		transform.scale = spawnParams["scale"];
	if(spawnParams.has("visible")):
		visible = spawnParams["visible"];
		transform.visible = spawnParams["visible"];
	pass;
	
func _process(delta: float) -> void:
	if(isDummy):
		transform.position = lerp(transform.position, position, .5);
		transform.rotation = lerp(transform.rotation, rotation, .5);
		transform.scale = lerp(transform.scale, scale, .5);
		if(transform.visible != visible):
			transform.visible = visible;
	else:
		position = transform.position;
		rotation = transform.rotation;
		scale = transform.scale;
		visible = transform.visible;
