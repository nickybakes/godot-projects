extends Lobby
class_name SteamLobby

func _init() -> void:
	Steam.lobby_created.connect(LobbyCreated);
	Steam.lobby_joined.connect(LobbyJoined);
	Steam.lobby_kicked.connect(LobbyKicked);
	pass

#func _notification(what: int) -> void:
	#if (what == NOTIFICATION_PREDELETE):
		#Steam.lobby_created.disconnect(LobbyCreated);
		#Steam.lobby_joined.disconnect(LobbyJoined);
		

func HostLobby():
	Network.Log("Steam Lobby Host");
	isHost = true;
	startConnecting();
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, MAX_CONNECTIONS);
	
func JoinLobby():
	isHost = false;
	startConnecting();
	Steam.joinLobby(SteamGlobal.steamLobbyId);
	
func LobbyCreated(connect : int, lobbyId : int):
	SteamGlobal.steamLobbyId = lobbyId;
	Network.OnHostSuccess();
	var peer : SteamMultiplayerPeer = SteamMultiplayerPeer.new();
	var lobbyName = str(LOBBY_SPECIAL_PREFIX, SteamGlobal.displayName);
	Steam.setLobbyData(lobbyId, "name", lobbyName);
	peer.create_host(0);
	Network.multiplayer.set_multiplayer_peer(peer);
	pass;
	
func LobbyJoined(lobbyId: int, _permissions: int, _locked: bool, response: int):
	if(isHost):
		return;
	
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		SteamGlobal.steamLobbyId = lobbyId;
		Network.Log("Steam Lobby Joined");
		var peer : SteamMultiplayerPeer = SteamMultiplayerPeer.new();
		peer.create_client(SteamGlobal.steamId, 0);
		Network.multiplayer.set_multiplayer_peer(peer);
	else:
		# Get the failure reason
		var FAIL_REASON: String
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST:
				FAIL_REASON = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED:
				FAIL_REASON = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL:
				FAIL_REASON = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR:
				FAIL_REASON = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED:
				FAIL_REASON = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED:
				FAIL_REASON = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED:
				FAIL_REASON = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN:
				FAIL_REASON = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU:
				FAIL_REASON = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER:
				FAIL_REASON = "A user you have blocked is in the lobby."
		Network.Log(FAIL_REASON);
	pass;

func LobbyKicked(lobbyId: int, adminId: int, dueToDisconnect: int):
	Network.Log("Kicked From Steam Lobby");
	Network.OnServerDisconnected();
	pass;
	

func LeaveLobby():
	Steam.leaveLobby(SteamGlobal.steamLobbyId);
	Network.Log("Leave Steam Lobby");
	pass;
