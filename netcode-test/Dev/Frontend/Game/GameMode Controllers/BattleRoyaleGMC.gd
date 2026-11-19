extends LivesGMC
class_name BattleRoyaleGMC

@export var ringMechanicUID : String;
@export var damageScale : float = .75;

var ringShrinkSpeed : float = 1.0;
var ring : BattleRoyaleRing;

func GetDamageScale() -> float:
	return damageScale;

func _ready() -> void:
	if(LobbyManager.Lobby):
		SetGameModeRules();
		GameManager.Manager.infiniteLives = false;
		if(Network.currentLobby && Network.currentLobby.isHost):
			GameNetManager.GameNet.netObjectManager.SpawnNetObject(ringMechanicUID, {}, true);
		
		GameManager.Manager.GameModeRulesAreSet();


func OnDamageTaken(activator : int, victim : int, type : Enums.DamageType, amount : float):
	ring.OnInteraction();
	
func OnDamageBlocked(attacker : int, blocker : int, amount : float):
	ring.OnInteraction();
