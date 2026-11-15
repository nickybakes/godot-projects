extends Node
class_name MatchOptions

static var Instance : MatchOptions;

@export_category("Option Elements")
@export var mapOption : Option;
@export var gameModeOption : Option;
@export var modeOptions : Array[Option];

@export_category("Title Elements")
@export var livesTitle : Option;

@export_category("Game Mode Options Lists")
@export var gameModeOptionsListsParent : Node;

@export_category("Available Selections")
@export var globalRandomID = 9999;

var modeOptionsDict : Dictionary[Enums.MatchOption, Option];
var optionsListsDict : Dictionary[Enums.GameMode, GameModeOptionsList];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance = self;
	
	modeOptionsDict = {};
	for modeOption in modeOptions:
		modeOptionsDict.set(modeOption.matchOption, modeOption);
		modeOption.ValueChanged.connect(OptionChanged);
		
	optionsListsDict = {};
	for child in gameModeOptionsListsParent.get_children():
		if(child is GameModeOptionsList):
			var optionList = child as GameModeOptionsList;
			optionsListsDict.set(optionList.gameMode, optionList);
		
	mapOption.ValueChanged.connect(OptionChanged);
	gameModeOption.ValueChanged.connect(OptionChanged);
	
	if(LobbyManager.Lobby && Network.currentLobby.isHost):
		UpdateMatchOptions(LobbyManager.Lobby.matchOptions);
		pass;
	else:
		LobbyManager.Lobby.rpc_id(1, "RequestHostMatchOptionsSync", Network.myId);
		pass;
	

func OptionChanged(matchOption : Enums.MatchOption, value : int):
	if(LobbyManager.Lobby):
		var newOptions = LobbyManager.Lobby.matchOptions.duplicate();
		newOptions.set(matchOption, value);
		LobbyManager.Lobby.SetMatchOptions(newOptions);
	pass;

func UpdateMatchOptions(newOptions : Dictionary[Enums.MatchOption, int]):
	HideAllModeOptions();
	
	mapOption.ReadValue(newOptions[Enums.MatchOption.Map]);
	gameModeOption.ReadValue(newOptions[Enums.MatchOption.GameMode]);
	
	for key in newOptions.keys():
		if(modeOptionsDict.keys().has(key)):
			modeOptionsDict[key].ReadValue(newOptions[key]);
		
	
	var optionsList : GameModeOptionsList = optionsListsDict.get(newOptions[Enums.MatchOption.GameMode]);
	if(optionsList != null):
		
		if(optionsList.infiniteLives):
			livesTitle.SetVisible(true);
			modeOptionsDict[Enums.MatchOption.InfiniteLives].SetVisible(true);
		
		pass;
	pass;

func HideAllModeOptions():
	livesTitle.SetVisible(false);
	for modeOption in modeOptions:
		modeOption.SetVisible(false);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
