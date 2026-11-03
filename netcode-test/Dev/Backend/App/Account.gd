extends Object
class_name Account

var id : int;
var displayName : String;
var avatar : Texture;

var accountDisplays : Array[AccountDisplay];

func _init() -> void:
	accountDisplays = [];
	
func RegisterAccountDisplay(display : AccountDisplay):
	accountDisplays.push_back(display);
	RefreshAccountDisplays();
	
func RefreshAccountDisplays():
	for accountDisplay in accountDisplays:
		accountDisplay.SetDisplayName(displayName);
		accountDisplay.SetAvatarTexture(avatar);
		pass;

func SetDisplayName(newDisplayName : String):
	displayName = newDisplayName;
	RefreshAccountDisplays();
	
func SetAvatar(newAvatar : Texture):
	avatar = newAvatar;
	RefreshAccountDisplays();
