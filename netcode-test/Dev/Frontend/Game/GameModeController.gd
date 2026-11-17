extends NetObject
class_name GameModeController


func GetDamageScale() -> float:
	return 1.0;
	
func DoSpawnParams():
	if(GameManager.Manager):
		GameManager.Manager.gameModeController = self;
	else:
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);
