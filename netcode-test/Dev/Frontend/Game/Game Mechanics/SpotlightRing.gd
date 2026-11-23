extends GameMechanic
class_name SpotlightRing

@export var radius : float = 5.0;
@export var position : Vector2 = Vector2.ZERO;

@export_category("Gameplay")
@export var insideRingScore : float = 1.0;
@export var ringSpeed : float = 1.0;
@export var ringChangeDirectionSpeed : float = 1.0;
@export var ringChangeDirectionTime : float = 5.0;

@export_category("Non Networked")
@export var ringVisual : RingCapture;
@export var insidePulseSpeed : float = 1.0;
@export var insidePulseScale : float = 1.0;

var currDirection := Vector2.ZERO;
var currSpeed := 1.0;

var changeDirTime : float = 0.0;

func DoSpawnParams():
	super();
	#if(Network.currentLobby && Network.currentLobby.isHost):
		#radius = GameSceneSetup.GSS.battleRoyaleRingStartRadius;
		#var ringPoint = GameSceneSetup.GSS.GetRandomRingPoint();
		#finalRingRadius = ringPoint.GetFinalRingRadius();
		#position = Vector2(ringPoint.global_position.x, ringPoint.global_position.z);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ringVisual.global_position = Vector3(position.x, 0, position.y);
	ringVisual.radius = radius;
	
	if(GameManager.Manager.gameFinished):
		return;
		
	if(GameManager.Manager):
		for netBall : NetBall in GameManager.Manager.balls.values():
			var ballController : BallMCC = netBall.ballController;
			var dist = position.distance_to(Vector2(ballController.global_position.x, ballController.global_position.z));
			if(dist <= radius):
				if(ballController.updatePhysics && !ballController.knockedOut):
					ballController.score += insideRingScore * delta;
				if(ballController.updateVisuals):
					ballController.visuals.StartSpotlightVisual();
					ballController.visuals.ballHubElement.trackerLine.requestedPulseSpeed = insidePulseSpeed;
					ballController.visuals.ballHubElement.trackerLine.requestedPulseScale = insidePulseScale;
				pass;
			else:
				if(ballController.updateVisuals):
					ballController.visuals.StopSpotlightVisual();
					ballController.visuals.ballHubElement.trackerLine.requestedPulseSpeed = ballController.visuals.ballHubElement.trackerLine.defaultPulseSpeed;
					ballController.visuals.ballHubElement.trackerLine.requestedPulseScale = ballController.visuals.ballHubElement.trackerLine.defaultPulseScale;
					
	if(!isDummy):
		position = position + currDirection * currSpeed * delta;
		
		position.x = clamp(position.x, GameSceneSetup.GSS.mapMin.global_position.x + radius, GameSceneSetup.GSS.mapMax.global_position.x - radius);
		position.y = clamp(position.y, GameSceneSetup.GSS.mapMin.global_position.z + radius, GameSceneSetup.GSS.mapMax.global_position.x - radius);
		
		changeDirTime += delta;
		currSpeed = ringSpeed;
		if(changeDirTime >= ringChangeDirectionTime):
			changeDirTime = 0;
			var newAngle = randf();
			newAngle *= PI * 2;
			currDirection = Vector2(cos(newAngle), sin(newAngle));
		pass;
			
	pass
