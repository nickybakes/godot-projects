extends BallState
class_name GrabAttempt

var victims : Array[BallMCC];

var subState : SubState;

var randomAngleOffset : float;

func StartStateVisuals(params : Dictionary = {}):
	mcc.visuals.StartGrabVisual();
	
func ExitStateVisuals():
	mcc.visuals.StopGrabVisual();

func StartStatePhysics(params : Dictionary = {}):
	mcc.grabCooldown.Restart();
	mcc.strikeCooldown.Restart();
	
	subState = SubState.new([mcc.traits.grabCheckDelay, mcc.traits.grabCheckDuration]);

	mcc.GetPhysics().BounceVelocity(mcc.currentFacingDirection, mcc.currentSpeed, mcc.traits.grabAttemptBoost);
	mcc.staminaStat.Spend(mcc.traits.grabStaminaCost);
	
	victims = [];
	
	randomAngleOffset = randf();
	pass;
	
func ExitStatePhysics():
	mcc.grabCooldown.Restart();
	mcc.autoAimCooldown = 0;

func ProcessPhysics(delta : float):
	super(delta);
	
	var startNewStep : bool = subState.Update(delta);
	match(subState.currentIndex):
		1:
			for i in min(mcc.grabRegion.ballsInsideThisRegion.size(), mcc.traits.maxNumOfGrabbedBalls):
				var hitBall = mcc.grabRegion.ballsInsideThisRegion[i];
				if(!victims.has(hitBall)):
					victims.push_back(hitBall);
			pass;
		2:
			if(startNewStep):
				if(victims.size() > 0):
					InteractionManager.Manager.SendInteraction(InteractionCreator.NewGrabAttempt(mcc, victims, randomAngleOffset));
			pass;
	
	if(victims.size() > 0):
		var targetPosition = Vector3.ZERO;
		for target in victims:
			targetPosition += target.global_position;
		targetPosition /= victims.size();
		if(targetPosition != mcc.global_position):
			var direction = (targetPosition - mcc.global_position).normalized()
			var travelSpeed = (targetPosition - mcc.global_position).length() * mcc.traits.grabAttemptSuccessSpeed;
			mcc.GetPhysics().BounceVelocitySpecific(direction, travelSpeed, mcc.traits.grabAttemptSuccessMinSpeed, mcc.traits.grabAttemptSuccessMaxSpeed, 1.0, 1.0);
	else:
		mcc.GetPhysics().DecelerateTopDown(delta, mcc.traits.grabAttemptDeceleration);
		mcc.velocity.y = move_toward(mcc.velocity.y, 0, mcc.traits.grabAttemptDeceleration * delta)
		mcc.GetPhysics().AutoAim(delta);
		pass;
		
	mcc.GetPhysics().MoveAndCollide(delta);
