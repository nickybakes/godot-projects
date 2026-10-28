extends Node
class_name InteractionManager

static var Manager : InteractionManager;
@export var traits : InteractionTraits;

@export var interactionTimeDecay : float = 10.0;
var loggedInteractions : Array[Interaction];


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager = self;
	loggedInteractions = [];
	pass # Replace with function body.
	
	
func SendInteraction(interaction : Interaction):
	if(Network.currentLobby.isHost):
		SendHostInteraction(interaction.GetParams());
	else:
		rpc_id(1, "SendHostInteraction", interaction.GetParams());
	pass;

@rpc("any_peer", "call_remote")
func SendHostInteraction(params : Dictionary):
	rpc("SendClientsInteraction", params);
	pass;

@rpc("authority", "call_local")
func SendClientsInteraction(params : Dictionary):
	loggedInteractions.push_back(ParseNewInteraction(params));
	OrderInteractionsByTime();
	EvaluateInteractions();
	pass;
	
func OrderInteractionsByTime():
	var orderedList: Array[Interaction] = [];
	
	while(loggedInteractions.size() > 0):
		var index = GetEarliestLoggedInteractionIndex();
		orderedList.push_back(loggedInteractions[index]);
		loggedInteractions.remove_at(index);
		
	loggedInteractions = orderedList;
	
func GetEarliestLoggedInteractionIndex() -> int:
	var earliestTimeStamp = INT64_MAX;
	var index = 0;
	for i in loggedInteractions.size():
		if(loggedInteractions[i].timeStamp < earliestTimeStamp):
			index = i;
			earliestTimeStamp = loggedInteractions[i].timeStamp;
	
	return index;
	
func EvaluateInteractions():
	var removeIndices: Array[int] = []; 
	
	for i in loggedInteractions.size():
		var interaction : Interaction = loggedInteractions[i];
		interaction.Evaluate();
		if(interaction.removeFromLog):
			removeIndices.push_back(i);
		elif(interaction.GetLifeTime() > interactionTimeDecay):
			removeIndices.push_back(i);
	
	for indexToRemove in removeIndices:
		loggedInteractions.remove_at(indexToRemove);
	
	pass;
	
func ParseNewInteraction(params : Dictionary) -> Interaction:
	var interaction;
	match(params['type']):
		'strikeAttempt':
			interaction = IStrikeAttempt.new(params);
		'clash':
			interaction = IClash.new(params);
	
	return interaction;

func _physics_process(delta: float) -> void:
	EvaluateInteractions();
	pass
