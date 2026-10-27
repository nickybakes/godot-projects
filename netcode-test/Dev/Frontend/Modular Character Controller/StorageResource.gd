extends Node
class_name StorageResource

@export var storedResource : Resource;

func _get(property: StringName) -> Variant:
	return storedResource.get(property);
