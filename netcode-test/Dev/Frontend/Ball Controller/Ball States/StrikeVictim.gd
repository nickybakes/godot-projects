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
	mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.strikeVictimDeceleration * delta)
	mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.strikeVictimDeceleration * delta)
	mcc.currentPhysics.CheckDeflectRegion(delta);
