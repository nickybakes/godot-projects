extends Node
class_name AccountDisplay

@export var avatarDisplay : TextureRect;
@export var nameDisplay : Label;

signal NameReady(displayName : String);
signal AvatarReady(avatar : Texture);

var id : int;

func Setup(id : int, playerNumber : int = -1):
	self.id = id;
	AccountManager.UnregisterAccountDisplay(self);
	AccountManager.RegisterAccountDisplay(self);

func _exit_tree() -> void:
	AccountManager.UnregisterAccountDisplay(self);
	
func SetDisplayName(displayName : String):
	if(nameDisplay):
		nameDisplay.text = displayName;
	NameReady.emit(displayName);
	
func SetAvatarTexture(avatar : Texture):
	if(avatarDisplay):
		avatarDisplay.texture = avatar;
	AvatarReady.emit(avatar);
