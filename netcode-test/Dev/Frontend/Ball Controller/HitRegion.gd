extends Area3D
class_name HitRegion

@export var ballController : BallMCC;

@export var filterOutInvulnerableBalls : bool;

@export var angleScaleForSort : float = 5.0;

@export var speedScale : Curve;
@export var electricScale : Curve;

var ballsInsideThisRegion : Array[BallMCC];
var numBallsInside : int;

var sortedBallsInsideThisRegion : Array[BallMCC];

func _ready() -> void:
	ballsInsideThisRegion = [];
	numBallsInside = 0;
	
func ScaleRegion(speed : float, electric : float):
	var newScale = speedScale.sample(speed) * electricScale.sample(electric);
	scale = Vector3.ONE * newScale;
	pass;
	
func GetOrderedBalls(maxNumberOfBalls : int):
	pass;
	
	
func SortByDistanceAndDirection(direction : Vector3) -> Array[BallMCC]:
	var orderedList: Array[BallMCC] = [];
	var unorderedScores : Array[Dictionary] = [];
	
	for i in ballsInsideThisRegion.size():
		var ball = ballsInsideThisRegion[i];
		var angle = direction.dot(ballController.global_position.direction_to(ball.global_position));
		var distance = ballController.global_position.distance_to(ball.global_position);
		var score = distance - (angle * angleScaleForSort);
		unorderedScores.push_back({"score" : score, "index" : i});
		
	while(unorderedScores.size() > 0):
		var smallestScore = INT64_MAX;
		var indexInUnorderedScores = 0;
		for i in unorderedScores.size():
			if(unorderedScores[i].score < smallestScore):
				smallestScore = unorderedScores[i].score;
				indexInUnorderedScores = i;
		orderedList.push_back(ballsInsideThisRegion[unorderedScores[indexInUnorderedScores].index]);
		unorderedScores.remove_at(indexInUnorderedScores);
	
	sortedBallsInsideThisRegion = orderedList;
	return orderedList;
	pass;


func OnBallEnteredThis(area : Area3D):
	if(!ballController.updatePhysics):
		return;
		
	if(area is not HitBox):
		return;
		
	var hitbox = area as HitBox;
	
	if(hitbox.ballController.playerNumber == ballController.playerNumber):
		return;
		
	if(filterOutInvulnerableBalls && hitbox.ballController.invulnStat.value > 0):
		return;
		
	if(!hitbox.ballController.interactive):
		return;
		
	ballsInsideThisRegion.push_back(hitbox.ballController);
	numBallsInside = ballsInsideThisRegion.size();

func OnBallExitedThis(area : Area3D):
	if(!ballController.updatePhysics):
		return;
		
	if(area is not HitBox):
		return;
		
	var hitbox = area as HitBox;
	
	if(hitbox.ballController.playerNumber == ballController.playerNumber):
		return;
		
	if(!ballsInsideThisRegion.has(hitbox.ballController)):
		return;
		
	ballsInsideThisRegion.erase(hitbox.ballController);
	numBallsInside = ballsInsideThisRegion.size();
	
func _process(delta: float) -> void:
	var ballsToRemove : Array[BallMCC] = [];
	for ball in ballsInsideThisRegion:
		if(!ball.interactive):
			ballsToRemove.push_back(ball);
			
	for ball in ballsToRemove:
		ballsInsideThisRegion.erase(ball);
		
	numBallsInside = ballsInsideThisRegion.size();
