class_name InteractionCreator

static func NewBasic() -> Dictionary:
	return {"timeStamp": NetTime.clock, "ownerId" : Network.myId};
	pass;
	
static func NewStrikeAttempt(activatorController : BallMCC, victimControllers : Array[BallMCC]) -> IStrikeAttempt:
	var victimNumbers : Array[int] = [];
	var directionsFromVictims : Array[Vector3] = [];
	
	for victim in victimControllers:
		victimNumbers.push_back(victim.playerNumber);
		directionsFromVictims.push_back((activatorController.global_position - victim.global_position).normalized())
		
	var interaction : IStrikeAttempt = IStrikeAttempt.new(NewBasic());
	interaction.type = 'strikeAttempt';
	interaction.activator = activatorController.playerNumber;
	interaction.victims = victimNumbers;
	interaction.directionsFromVictims = directionsFromVictims;
	interaction.activatorSpeed = activatorController.currentSpeed;
	interaction.activatorFire = activatorController.fireStat.value;
	
	return interaction;
	pass;
	
static func NewGrabAttempt(activatorController : BallMCC, victimControllers : Array[BallMCC], _angleOffset : float) -> IGrabAttempt:
	var victimNumbers : Array[int] = [];
	
	for victim in victimControllers:
		victimNumbers.push_back(victim.playerNumber);
		
	var interaction : IGrabAttempt = IGrabAttempt.new(NewBasic());
	interaction.type = 'grabAttempt';
	interaction.activator = activatorController.playerNumber;
	interaction.victims = victimNumbers;
	interaction.activatorSpeed = activatorController.currentSpeed;
	interaction.activatorFire = activatorController.fireStat.value;
	interaction.angleOffset = _angleOffset;
	
	return interaction;
	pass;
	
#static func NewClash(victims : Array[int]) -> IClash:
	#var interaction = IClash.new(NewBasic());
	#interaction.type = 'clash';
	#interaction.victims = victims;
	#return interaction;
	#pass;
