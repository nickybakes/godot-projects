extends Control
class_name Hub

@export var hubElementPrefab : HubElement;

var elements : Dictionary[int, HubElement];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	elements = {};
	pass # Replace with function body.
	
func AddElement(id : int):
	var newElement : HubElement = hubElementPrefab.duplicate();
	self.add_child(newElement);
	newElement.Setup(id);
	newElement.visible = true;
	elements.set(id, newElement);
	ReorderElements();
	pass;

func RemoveElement(id : int):
	var hubElement = elements[id];
	elements.erase(id);
	hubElement.queue_free();
	ReorderElements();
	pass;

func ReorderElements():
	for element in elements.values():
		move_child(element, min(get_child_count(), element.id - 1));
	pass;
