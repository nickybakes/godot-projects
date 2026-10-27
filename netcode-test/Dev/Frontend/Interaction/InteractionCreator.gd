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
		
	var interaction = IStrikeAttempt.new(NewBasic());
	interaction.type = 'strikeAttempt';
	interaction.activator = activatorController.playerNumber;
	interaction.victims = victimNumbers;
	interaction.directionsFromVictims = directionsFromVictims;
	interaction.activatorSpeed = activatorController.currentSpeed;
	interaction.activatorFire = activatorController.fireStat.value;
	
	return interaction;
	pass;
	
static func NewClash(victims : Array[int]) -> IClash:
	var interaction = IClash.new(NewBasic());
	interaction.type = 'clash';
	interaction.victims = victims;
	return interaction;
	pass;

#static func NewStartBlock(ballController : BallMCC) -> Dictionary:
	#return {"timeStamp": NetTime.clock, "playerNumber": ballController.playerNumber, "type": "startBlock"};
	#pass;
#
#static func NewEndBlock(ballController : BallMCC) -> Dictionary:
	#return {"timeStamp": NetTime.clock, "playerNumber": ballController.playerNumber, "type": "endBlock"};
	#pass;
