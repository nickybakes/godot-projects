extends NetObject
class_name Cursor

@export var transform: Node3D
@export var sprite: Sprite3D
@export var text: Label3D
@export var textShadow: Label3D

@export var normalizedPosition : Vector2;
var currentNormalizedPosition : Vector2;

var hubElement : CursorHubElement;

var currentColorIndex : int = -1;

var playerNumber : int;
var playerToken : PlayerToken;
var inputDevice : InputDevice;

var requestedColorCycle : bool;

func DoSpawnParams():
	if(spawnParams.has("playerNumber")):
		playerNumber = spawnParams["playerNumber"];
	if(spawnParams.has("normalizedPosition")):
		normalizedPosition = spawnParams["normalizedPosition"];
		currentNormalizedPosition = spawnParams["normalizedPosition"];
		
	if(CursorManager.Manager):
		CursorManager.Manager.CursorAdded(playerNumber, self);
		CursorManager.Manager.SetTransformFromNormalizedPosition(currentNormalizedPosition, transform);
			
	text.text = str("P", playerNumber);
	textShadow.text = text.text;
	
	playerToken = LobbyManager.Lobby.GetPlayerTokenByPlayerNumber(playerNumber);
	
	UpdateColor();
	
	if(!isDummy):
		inputDevice = playerToken.inputDevice;
		
	pass;

func _process(delta: float) -> void:
	if(!playerToken):
		return;
				
	if(CursorManager.Manager != null):
		if(isDummy):
			currentNormalizedPosition = lerp(currentNormalizedPosition, normalizedPosition, .5);
		elif(inputDevice != null):
			currentNormalizedPosition = CursorManager.Manager.MoveNormalizedPosition(currentNormalizedPosition, inputDevice.moveInput, delta);
			normalizedPosition = currentNormalizedPosition;
			if(inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.ToggleInvert, 1)):
				playerToken.customization.invertChargeAim = !playerToken.customization.invertChargeAim;
				pass;
			if(!requestedColorCycle && inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.CycleColorNext, 1)):
				requestedColorCycle = true;
				CustomizationManager.Manager.CycleColor(playerToken.customization.colorIndex, 1, playerNumber);
				pass;
			if(!requestedColorCycle && inputDevice.inputBuffer.IsActionJustPressedThisFrame(Enums.InputAction.CycleColorPrev, 1)):
				requestedColorCycle = true;
				CustomizationManager.Manager.CycleColor(playerToken.customization.colorIndex, -1, playerNumber);
				pass;
			
		CursorManager.Manager.SetTransformFromNormalizedPosition(currentNormalizedPosition, transform);
		if(playerToken.customization.colorIndex != currentColorIndex):
			UpdateColor();

func UpdateColor():
	if(CursorManager.Manager):
		currentColorIndex = playerToken.customization.colorIndex;
		sprite.modulate = CursorManager.Manager.cursorCustomizationDirectory.cursorColors[playerToken.customization.colorIndex];
		hubElement.UpdateColor();

func _exit_tree() -> void:
	if(CursorManager.Manager != null):
		CursorManager.Manager.CursorRemoved(playerNumber);
