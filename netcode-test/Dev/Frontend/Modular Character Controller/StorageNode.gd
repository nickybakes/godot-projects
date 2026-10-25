extends Node
class_name StorageNode

var storedNode : Node;

func _get(property: StringName) -> Variant:
	return storedNode.get(property);
