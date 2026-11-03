extends Node
class_name AccountDisplay

@export var avatarDisplay : TextureRect;
@export var nameDisplay : Label;

var id : int;

func Setup(id : int):
	self.id = id;
	AccountManager.UnregisterAccountDisplay(self);
	AccountManager.RegisterAccountDisplay(self);

func _exit_tree() -> void:
	AccountManager.UnregisterAccountDisplay(self);
	
func SetDisplayName(displayName : String):
	if(nameDisplay):
		nameDisplay.text = displayName;
	
func SetAvatarTexture(avatar : Texture):
	if(avatarDisplay):
		avatarDisplay.texture = avatar;
