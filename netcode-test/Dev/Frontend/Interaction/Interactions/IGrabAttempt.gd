extends Interaction
class_name IGrabAttempt

var activator : int;
var victims : Array[int];
var activatorSpeed : float;
var activatorFire : float;
var angleOffset : float;

var alreadyActivated : bool = false;
var outPrioritied : bool = false;
var striker : int = -1;

var clashVictims : Array[int] = [];

func _init(params : Dictionary) -> void:
	SetParams(params);
	pass;

func SetParams(params : Dictionary):
	super(params);
	if(params.has('activator')):
		activator = params['activator'];
	if(params.has('victims')):
		victims = params['victims'];
	if(params.has('activatorSpeed')):
		activatorSpeed = params['activatorSpeed'];
	if(params.has('activatorFire')):
		activatorFire = params['activatorFire'];
	if(params.has('angleOffset')):
		angleOffset = params['angleOffset'];

func GetParams() -> Dictionary:
	return super().merged({"activator": activator, 'victims' : victims, 'activatorSpeed' : activatorSpeed, 'activatorFire' : activatorFire, 'angleOffset' : angleOffset});

func Evaluate():
	if(alreadyActivated):
		return;
		
	for interactionCheck in InteractionManager.Manager.loggedInteractions:
		if(interactionCheck is IGrabAttempt && interactionCheck != self):
			var possibleClash = interactionCheck as IGrabAttempt;
			if(activator != possibleClash.activator):
				if(possibleClash.victims.has(activator) && victims.has(possibleClash.activator)):
					if(!possibleClash.alreadyActivated):
						if(!clashVictims.has(activator)):
							clashVictims.push_back(activator);
						if(!clashVictims.has(possibleClash.activator)):
							clashVictims.push_back(possibleClash.activator);
							
			
	for victim in clashVictims:
		if(GameManager.Manager.balls[victim].ballController.updatePhysics):
			GameManager.Manager.balls[victim].ballController.clash = true;
			
	if(outPrioritied):
		GameManager.Manager.balls[activator].ballController.clash = false;
	
	if(GetLifeTime() > InteractionManager.Manager.traits.grabBuffer):
		alreadyActivated = true;
		if(clashVictims.size() > 0):
			return;
			
		if(outPrioritied):
			return;
		
		var activatorController = GameManager.Manager.balls[activator].ballController;
		
		if(activatorController.updatePhysics):
			activatorController.ForceSetState("grabSuccess");
			
		for i in victims.size():
			if(!clashVictims.has(victims[i])):
				var victimController = GameManager.Manager.balls[victims[i]].ballController;
				if(victimController.invulnStat.value > 0):
					continue;
					
				if(victimController.updateVisuals):
					if(victimController.blocking):
						victimController.visuals.ShowUnblockableMessage();
						pass;
					pass;	
				
				victimController.grabParent = activatorController;
				victimController.grabParentFire = activatorFire;
				victimController.grabVictimIndex = i;
				victimController.grabVictimTotal = victims.size();
				victimController.grabVictimAngleOffset = angleOffset;
				if(victimController.updatePhysics):
					victimController.ForceSetState("grabVictim");
					pass;
				pass;
				
