extends MCCRule
class_name InputRule

enum InputType{
	PressedBuffered,
	PressedThisFrame,
	ReleasedBuffered,
	ReleasedThisFrame,
	IsPressedAtAll,
	IsReleasedAtAll,
	HeldForTime,
}

@export var action : Enums.InputAction;
@export var inputType : InputType;
@export var heldTime := 0.0;

func CheckForPass(state : MCCState, transition: MCCTransition, delta : float) -> bool:
	if(state.GetInputDevice() && state.GetInputBuffer()):
		match(inputType):
			InputType.PressedBuffered:
				return state.GetInputBuffer().IsActionJustPressed(action);
			InputType.PressedThisFrame:
				return state.GetInputBuffer().IsActionJustPressedThisFrame(action);
			InputType.ReleasedBuffered:
				return state.GetInputBuffer().IsActionJustReleased(action);
			InputType.ReleasedThisFrame:
				return state.GetInputBuffer().IsActionJustReleasedThisFrame(action);
			InputType.IsPressedAtAll:
				return state.GetInputBuffer().IsActionPressed(action);
			InputType.IsReleasedAtAll:
				return !state.GetInputBuffer().IsActionPressed(action);
			InputType.HeldForTime:
				return state.GetInputBuffer().ActionHeldTime(action) >= heldTime;
	return false;
	pass;
