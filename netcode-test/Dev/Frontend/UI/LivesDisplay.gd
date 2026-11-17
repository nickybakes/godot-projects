extends Control
class_name LivesDisplay

@export var boxContainer : BoxContainer;

@export var spritePrefab : Control;
@export var numLabel : Label;

@export var spriteBased : Control;
@export var numberBased : Control;

@export var maxSprites : int = 5;

@export var spriteSeparations : Array[int];

var sprites : Array[Control];


func Display(numLives : int):
	if(numLives <= maxSprites):
		spriteBased.visible = true;
		numberBased.visible = false;
		for i in sprites.size():
			sprites[i].visible = i < numLives;
		
		boxContainer.add_theme_constant_override("separation", spriteSeparations[numLives]);
		pass;
	else:
		spriteBased.visible = false;
		numberBased.visible = true;
		numLabel.text = str(numLives);
		pass;
	pass;

func Setup():
	sprites = [];
	for i in maxSprites:
		var newSprite = spritePrefab.duplicate() as Control;
		boxContainer.add_child(newSprite);
		sprites.push_back(newSprite);
