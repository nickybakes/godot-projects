extends NetObject
class_name GameModeController

@export_category("Networked")
@export var gameTime : float;

@export_category("Not Networked")
@export var resultTableHeaderPrefab : Control;
@export var resultDisplayPrefab : ResultDisplay;

func _ready() -> void:
	GameManager.Manager.GameModeRulesAreSet();

func GetDamageScale() -> float:
	return 1.0;
	
func DoSpawnParams():
	if(GameManager.Manager):
		GameManager.Manager.gameModeController = self;
	else:
		GameNetManager.GameNet.netObjectManager.DestroyNetObject(id);

func GetPlayerPlacements() -> Array[int]:
	return SortPlayersByHighestScore();
	
	
func SortPlayersByHighestScore() -> Array[int]:
	var orderedList: Array[int] = [];
	var unorderedScores : Array[Dictionary] = [];
	
	for i in GameManager.Manager.balls.values().size():
		var ball = GameManager.Manager.balls.values()[i];
		var score = ball.score;
		unorderedScores.push_back({"score" : score, "index" : i});
		
	while(unorderedScores.size() > 0):
		var highestScore = INT64_MIN;
		var indexInUnorderedScores = 0;
		for i in unorderedScores.size():
			if(unorderedScores[i].score > highestScore):
				highestScore = unorderedScores[i].score;
				indexInUnorderedScores = i;
		orderedList.push_back(GameManager.Manager.balls.values()[unorderedScores[indexInUnorderedScores].index].playerNumber);
		unorderedScores.remove_at(indexInUnorderedScores);
	
	return orderedList;
	pass;

func SortPlayersByLowestScore() -> Array[int]:
	var placements = SortPlayersByHighestScore();
	placements.reverse();
	return placements;

func OnDamageTaken(activator : int, victim : int, type : Enums.DamageType, amount : float):
	pass;

func OnDamageBlocked(attacker : int, blocker : int, amount : float):
	pass;
	
func OnKnockOut(activator : int, victim : int):
	pass;
	
func OnElimination(activator : int, victim : int):
	pass;
	
func OnResultsShown():
	pass;
