extends Area3D
class_name HitRegion

@export var ballController : BallMCC;

@export var filterOutInvulnerableBalls : bool;

var ballsInsideThisRegion : Array[BallMCC];
var numBallsInside : int;

func _ready() -> void:
	ballsInsideThisRegion = [];
	numBallsInside = 0;
	
func GetOrderedBalls(maxNumberOfBalls : int):
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
	
