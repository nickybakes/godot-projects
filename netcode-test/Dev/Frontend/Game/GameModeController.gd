extends NetObject
class_name GameModeController

@export_category("Networked")
@export var gameTime : float;

@export_category("Not Networked")
@export var clockDisplay : ClockDisplay;

func GetDamageScale() -> float:
	return 1.0;
	
func DoSpawnParams():
	if(GameManager.Manager):
		GameManager.Manager.gameModeController = self;
	else:
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);

func _process(delta: float) -> void:
	clockDisplay.DisplayTime(gameTime);


func OnDamageTaken(activator : int, victim : int, type : Enums.DamageType, amount : float):
	pass;

func OnDamageBlocked(attacker : int, blocker : int, amount : float):
	pass;
	
func OnKnockOut(activator : int, victim : int):
	pass;
	
func OnElimination(activator : int, victim : int):
	pass;
