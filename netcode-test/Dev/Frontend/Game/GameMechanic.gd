extends NetObject
class_name GameMechanic

func DoSpawnParams():
	if(GameManager.Manager):
		GameManager.Manager.gameMechanics.push_back(self);
	else:
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);
