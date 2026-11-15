extends Node
class_name Option

enum OptionType{
	Selection,
	Bool,
	Number,
}

@export var matchOption : Enums.MatchOption;

@export var controlParent : Control;
@export var nodeParent : Node3D;

@export var type : OptionType;

@export var optionButton : OptionButton;
@export var checkBox : CheckBox;


signal ValueChanged(_matchOption : Enums.MatchOption, _value : int);

func _ready() -> void:
	if(optionButton):
		optionButton.item_selected.connect(OnChangeValue);
	if(checkBox):
		checkBox.toggled.connect(OnChangeValue);

func ReadValue(value : int):
	match(type):
		OptionType.Selection:
			if(optionButton):
				optionButton.select(optionButton.get_item_index(value));
		OptionType.Bool:
			if(checkBox):
				checkBox.set_pressed_no_signal(value as bool)
	pass;

func OnChangeValue(value : int):
	match(type):
		OptionType.Selection:
			if(optionButton):
				value = optionButton.get_item_id(value);
		OptionType.Bool:
			if(checkBox):
				value = checkBox.button_pressed as int;
	
	ValueChanged.emit(matchOption, value);
	pass;

func SetVisible(visible : bool):
	if(controlParent):
		controlParent.visible = visible;
	if(nodeParent):
		nodeParent.visible = visible;
