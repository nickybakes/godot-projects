extends Interaction
class_name IStrikeAttempt

var activator : int;
var victims : Array[int];
var directionsFromVictims : Array[Vector3];
var activatorSpeed : float;
var activatorFire : float;

var alreadyActivated : bool = false;

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
	if(params.has('directionsFromVictims')):
		directionsFromVictims = params['directionsFromVictims'];
	if(params.has('activatorSpeed')):
		activatorSpeed = params['activatorSpeed'];
	if(params.has('activatorFire')):
		activatorFire = params['activatorFire'];

func GetParams() -> Dictionary:
	return super().merged({"activator": activator, 'victims' : victims, 'directionsFromVictims' : directionsFromVictims, 'activatorSpeed' : activatorSpeed, 'activatorFire' : activatorFire});

func Evaluate():
	if(alreadyActivated):
		return;
		
	for interactionCheck in InteractionManager.Manager.loggedInteractions:
		if(interactionCheck is IStrikeAttempt && interactionCheck != self):
			var possibleClash = interactionCheck as IStrikeAttempt;
			if(activator != possibleClash.activator):
				if(possibleClash.victims.has(activator) && victims.has(possibleClash.activator)):
					if(!possibleClash.alreadyActivated):
						if(!clashVictims.has(activator)):
							clashVictims.push_back(activator);
						if(!clashVictims.has(possibleClash.activator)):
							clashVictims.push_back(possibleClash.activator);
		elif(interactionCheck is IGrabAttempt && interactionCheck != self):
			var possibleGrab = interactionCheck as IGrabAttempt;
			if(activator != possibleGrab.activator):
				if(possibleGrab.victims.has(activator) && victims.has(possibleGrab.activator)):
					if(!possibleGrab.alreadyActivated):
						if(possibleGrab.outPrioritied && possibleGrab.striker == activator && clashVictims.size() != 0):
							possibleGrab.outPrioritied = false;
							possibleGrab.striker = -1;
							var grabberController = GameManager.Manager.balls[possibleGrab.activator].ballController;
							grabberController.strikePrioritied = false;
						else:
							possibleGrab.outPrioritied = true;
							possibleGrab.striker = activator;
							var grabberController = GameManager.Manager.balls[possibleGrab.activator].ballController;
							grabberController.strikePrioritied = true;
						
							
			
	for victim in clashVictims:
		if(GameManager.Manager.balls[victim].ballController.updatePhysics):
			GameManager.Manager.balls[victim].ballController.clash = true;
	
	if(GetLifeTime() > InteractionManager.Manager.traits.strikeBuffer):
		alreadyActivated = true;
		if(clashVictims.size() > 0):
			return;
			
		var totalDirection = Vector3.ZERO;
		var activatorController = GameManager.Manager.balls[activator].ballController;
		var totalVictims = 0;
		var totalHit = 0;
		var totalBlocked = 0;
			
		for i in victims.size():
			if(!clashVictims.has(victims[i])):
				var victimController = GameManager.Manager.balls[victims[i]].ballController;
				if(victimController.invulnStat.value > 0):
					continue;
					
				if(victimController.updatePhysics):
					if(victimController.blocking):
						victimController.BlockDamageFromStrike(activatorController, activatorSpeed, activatorFire);
						victimController.GetPhysics().BounceVelocity(-directionsFromVictims[i], activatorSpeed, victimController.traits.strikeBlockerBounceTraits);
						pass;
					else:
						victimController.TakeDamageFromStrike(activatorController, activatorSpeed, activatorFire);
						victimController.ForceSetState("strikeVictim");
						victimController.GetPhysics().BounceVelocity(-directionsFromVictims[i], activatorSpeed, victimController.traits.strikeVictimBounceTraits);
						pass;
						
				totalDirection += directionsFromVictims[i];
				
				totalVictims += 1;
				if(victimController.blocking):
					totalBlocked += 1;
				else:
					totalHit += 1;
				pass;
		
		totalVictims = max(totalVictims, 1);
		if(activatorController.updatePhysics):
			activatorController.GetPhysics().BounceVerlocityLerpTraits(totalDirection.normalized(), activatorSpeed, activatorController.traits.strikeFailedBounceTraits, activatorController.traits.strikeSuccessBounceTraits, (totalHit as float)/(totalVictims as float));
