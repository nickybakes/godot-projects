extends GameMechanic
class_name BattleRoyaleRing

@export var radius : float = 5.0;
@export var position : Vector2 = Vector2.ZERO;

@export_category("Gameplay")
@export var outsideRingDamage : float = 1.0;
@export var outsideRingTrackerHeartbeat : float = .5;
@export var finalRingShrinkSpeed : float = 1.0;
@export var finalRingNoInteractionTime : float = 10;

@export_category("Non Networked")
@export var ringVisual : RingOfFire;
@export var cameraTarget : CameraTarget;
@export var radiusToCameraTargetStrength : Curve;

var finalRingRadius : float;
var isFinalRing : bool = false;

var timeSinceLastInteraction : float = 0.0;

var gmc : BattleRoyaleGMC;


func DoSpawnParams():
	super();
	if(Network.currentLobby && Network.currentLobby.isHost):
		radius = GameSceneSetup.GSS.battleRoyaleRingStartRadius;
		var ringPoint = GameSceneSetup.GSS.GetRandomRingPoint();
		finalRingRadius = ringPoint.GetFinalRingRadius();
		position = Vector2(ringPoint.global_position.x, ringPoint.global_position.z);

func _ready() -> void:
	gmc = GameManager.Manager.gameModeController as BattleRoyaleGMC;
	gmc.ring = self;

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
			if(dist > radius):
				if(ballController.updatePhysics && ballController.invulnStat.value == 0):
					ballController.healthStat.Spend(outsideRingDamage * delta);
					
				if(ballController.updateVisuals):
					ballController.visuals.StartRingFireVisual();
					ballController.visuals.ballHubElement.trackerLine.goalHeartbeat = outsideRingTrackerHeartbeat;
				pass;
			else:
				if(ballController.updateVisuals):
					ballController.visuals.StopRingFireVisual();
					ballController.visuals.ballHubElement.trackerLine.goalHeartbeat = 0;
				pass;
	
	if(!isDummy && gmc):
		if(!isFinalRing):
			radius = move_toward(radius, finalRingRadius, gmc.ringShrinkSpeed * delta);
			if(radius <= finalRingRadius):
				isFinalRing = true;
		elif(radius > 0.0):
			timeSinceLastInteraction += delta;
			if(timeSinceLastInteraction >= finalRingNoInteractionTime):
				radius = move_toward(radius, 0, finalRingShrinkSpeed * delta);
			pass;
		pass;
			
	pass


func OnInteraction():
	timeSinceLastInteraction = 0;
	pass;
