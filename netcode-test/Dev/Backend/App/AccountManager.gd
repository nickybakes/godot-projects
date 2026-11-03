extends Node

enum AccountType{
	LOCAL,
	STEAM
}

@onready var PLACEHOLDER_AVATAR = preload("res://icon.svg") as Texture2D;

var accounts : Dictionary[int, Account];
var accountType : AccountType = AccountType.LOCAL;

var myAccountId : int = -1;

func _ready() -> void:
	accounts = {};
	
func LoadAccount(id : int, onlyLoadIfNotNew : bool = false):
	var isNew : bool;
	var loadedAccount : Account;
	if(accounts.has(id)):
		loadedAccount = accounts[id];
		isNew = false;
	else:
		if(onlyLoadIfNotNew):
			return;
		loadedAccount = Account.new();
		loadedAccount.id = id;
		accounts.set(id, loadedAccount);
		isNew = true;
	
	match(accountType):
		AccountType.LOCAL:
			LoadLocalAccount(loadedAccount, isNew);
		AccountType.STEAM:
			LoadSteamAccount(loadedAccount, isNew);
	pass;
	
func LoadLocalAccount(account : Account, isNew : bool):
	account.SetDisplayName("Local Player");
	account.SetAvatar(PLACEHOLDER_AVATAR);
	pass;

func LoadSteamAccount(account : Account, isNew : bool):
	var newName = Steam.getFriendPersonaName(account.id);
	account.SetDisplayName(newName);
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, account.id);
	pass;
	
func RegisterAccountDisplay(display : AccountDisplay):
	LoadAccount(display.id);
	var account = accounts[display.id];
	account.RegisterAccountDisplay(display);
	pass;

func UnregisterAccountDisplay(display : AccountDisplay):
	if(accounts.has(display.id)):
		var loadedAccount = accounts[display.id];
		loadedAccount.accountDisplays.erase(display);
		pass;
	pass;
