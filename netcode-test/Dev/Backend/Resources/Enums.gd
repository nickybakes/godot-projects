class_name Enums

enum InputAction
{
	Join,
	Jump,
	Leave,
	StartGame,
	Charge,
	Block,
	EndGame,
	Grab,
	ToggleInvert,
	CycleColorNext,
	CycleColorPrev,
}


enum GameMode
{
	Lives,
	Timed,
	BattleRoyale,
	Spotlight,
	KingOfTheHill,
	Random = 9999,
}

enum MatchOption
{
	Map,
	GameMode,
	InfiniteLives,
	NumLives,
	TimeLength,
	InfiniteScore,
	ScoreLimit,
	InfiniteTime
}

enum DamageType
{
	Strike,
	Grab
}
