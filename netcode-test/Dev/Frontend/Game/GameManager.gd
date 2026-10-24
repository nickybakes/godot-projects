extends Node
class_name GameManager

var ballPrefabPath := "uid://2rolpfky2ye3";

func _ready() -> void:
	if(Network.currentLobby.isHost):
		#await get_tree().create_timer(1).timeout;
		SpawnPlayerBalls();

func SpawnPlayerBalls():
	if(LobbyManager.Lobby):
		var tokenArray : Array[PlayerToken] = LobbyManager.Lobby.playerTokens.duplicate();
		var totalPlayers = tokenArray.size();
		for tokenNum in totalPlayers:
			var pickedPlayerToken : PlayerToken = tokenArray.pick_random();
			tokenArray.erase(pickedPlayerToken);
			var ballPosition = GameSceneSetup.GSS.GetSpawnPosition(tokenNum + 1, totalPlayers);
			var spawnParams = {"playerNumber": pickedPlayerToken.playerNumber, "position": ballPosition, "velocity": Vector3.ZERO};
			GameNetManager.GameNet.netObjectManager.SpawnNetObjectWithOwnerId(ballPrefabPath, spawnParams, pickedPlayerToken.ownerId);
			pass;
	pass;
