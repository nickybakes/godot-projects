extends BallState
class_name StrikeVictim

@export var cooldown : Cooldown;

func StartStateVisuals(params : Dictionary = {}):
	if(mcc.strikePrioritied):
		mcc.visuals.ShowStrikePriorityMessage();
		
	mcc.strikePrioritied = false;

func StartStatePhysics(params : Dictionary = {}):
	mcc.invulnStat.Add(1.0);
	cooldown.Restart();
	
func ProcessPhysics(delta : float):
	super(delta);
	mcc.GetPhysics().Gravity(delta);
	mcc.GetPhysics().MoveAndCollide(delta);
	mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.strikeVictimDeceleration);
	mcc.GetPhysics().CheckDeflectRegion(delta);
