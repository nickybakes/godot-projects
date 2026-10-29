extends Area3D
class_name HitRegion

@export var ballController : BallMCC;

@export var filterOutInvulnerableBalls : bool;

@export var minScale : float = 1.0 ;
@export var maxScale : float = 1.0 ;
@export var minScaleSpeed : float = 0.0 ;
@export var maxScaleSpeed : float = 10.0 ;

var ballsInsideThisRegion : Array[BallMCC];
var numBallsInside : int;

func _ready() -> void:
	ballsInsideThisRegion = [];
	numBallsInside = 0;
	
func ScaleBySpeed(speed : float):
	var newScale = lerp(minScale, maxScale, clamp((speed - minScaleSpeed)/maxScaleSpeed, 0.0, 1.0));
	scale = Vector3.ONE * newScale;
	pass;
	
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
