extends Control
class_name HubElement

var id : int;
var hasBeenSetup : bool;

func Setup(id : int):
	self.id = id;
	hasBeenSetup = true;
	pass;
