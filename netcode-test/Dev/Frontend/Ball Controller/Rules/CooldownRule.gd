extends MCCRule
class_name CooldownRule

@export var cooldown : Cooldown;
@export var invert : bool;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	return cooldown.IsCooledDown() == !invert;
