extends Resource
class_name CursorCustomizationDirectory

@export var cursorColors : Array[Color];


func GetColorFromPlayerNumber(playerNumber : int) -> Color:
	return cursorColors[(playerNumber - 1) % cursorColors.size()];
