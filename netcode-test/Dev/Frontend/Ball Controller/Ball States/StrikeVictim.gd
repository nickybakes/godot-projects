extends BallState
class_name StrikeVictim

@export var cooldown : Cooldown;

func StartStatePhysics(params : Dictionary = {}):
	mcc.invulnStat.Add(1.0);
	cooldown.Restart();
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.currentPhysics.Gravity(delta);
	mcc.currentPhysics.MoveAndCollide(delta);
	mcc.currentPhysics.DecelerateTopDown(delta, mcc.traits.strikeVictimDeceleration);
	mcc.currentPhysics.CheckDeflectRegion(delta);
