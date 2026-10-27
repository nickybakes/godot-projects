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
						
						var blockerDirection = -directionsFromVictims[i];
						var newBlockerVelocity = blockerDirection;
						newBlockerVelocity *= max(victimController.traits.strikeBlockerMinBounceSpeed, min(victimController.traits.strikeBlockerMaxBounceSpeed, activatorSpeed));
						var blockerVelScalar = Vector3(victimController.traits.strikeBlockerTopDownSpeedScalar, victimController.traits.strikeBlockerVerticalSpeedScalar, victimController.traits.strikeBlockerTopDownSpeedScalar)
						victimController.velocity = newBlockerVelocity * blockerVelScalar;
						
						pass;
					else:
						victimController.TakeDamageFromStrike(activatorController, activatorSpeed, activatorFire);
						victimController.ForceSetState("strikeVictim");
						
						var victimDirection = -directionsFromVictims[i];
						var newVictimVelocity = victimDirection;
						newVictimVelocity *= max(victimController.traits.strikeVictimMinBounceSpeed, min(victimController.traits.strikeVictimMaxBounceSpeed, activatorSpeed));
						var victimVelScalar = Vector3(victimController.traits.strikeVictimTopDownSpeedScalar, victimController.traits.strikeVictimVerticalSpeedScalar, victimController.traits.strikeVictimTopDownSpeedScalar)
						victimController.velocity = newVictimVelocity * victimVelScalar;
						
						pass;
						
				totalDirection += directionsFromVictims[i];
				
				totalVictims += 1;
				if(victimController.blocking):
					totalBlocked += 1;
				else:
					totalHit += 1;
				pass;
		
		var newActivatorVelocity = totalDirection.normalized();
		newActivatorVelocity *= max(activatorController.traits.strikeActivatorMinBounceSpeed, min(activatorController.traits.strikeActivatorMaxBounceSpeed, activatorSpeed));
		var activatorVelScalar = Vector3(activatorController.traits.strikeActivatorTopDownSpeedScalar, activatorController.traits.strikeActivatorVerticalSpeedScalar, activatorController.traits.strikeActivatorTopDownSpeedScalar)
		activatorController.velocity = newActivatorVelocity * activatorVelScalar;
