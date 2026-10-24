extends MCCPhysics
class_name BallPhysics

var mcc : BallMCC;

func ProcessPhysics(delta : float):
	Gravity(delta);
		
	MovementControl(delta);
		
	mcc.move_and_slide();
	pass;

func Gravity(delta : float):
	if not mcc.is_on_floor():
		if(mcc.velocity.y > 0):
			mcc.velocity.y -= mcc.traits.gravity * delta
		else:
			mcc.velocity.y -= mcc.traits.gravity * mcc.traits.gravityFallMultiplier * delta

func MovementControl(delta : float):
	if mcc.requestedMoveDirection:
		mcc.velocity.x = mcc.requestedMoveDirection.x * mcc.traits.moveSpeed
		mcc.velocity.z = mcc.requestedMoveDirection.z * mcc.traits.moveSpeed
	else:
		mcc.velocity.x = move_toward(mcc.velocity.x, 0, mcc.traits.deceleration * delta)
		mcc.velocity.z = move_toward(mcc.velocity.z, 0, mcc.traits.deceleration * delta)
	
	#if(mcc.is_on_floor()):
		#if not mcc.requestedMoveDirection:
			#var decelAmount = 100
			#if(mcc.currentTopDownSpeed > .2):
				#var currentVelDirection : Vector2 = mcc.topDownVelocity/mcc.currentTopDownSpeed
				#var newTopDownSpeed = move_toward(mcc.currentTopDownSpeed, 0, decelAmount * delta)
				#mcc.velocity.x = currentVelDirection.x * newTopDownSpeed
				#mcc.velocity.z = currentVelDirection.y * newTopDownSpeed
			#else:
				#mcc.velocity.x = 0
				#mcc.velocity.z = 0
		#else:
			#var decelAmount = 70
			#if(mcc.currentTopDownSpeed > mcc.traits.baseMoveSpeed):
				#var currentVelDirection : Vector2 = mcc.topDownVelocity/mcc.currentTopDownSpeed
				#var newTopDownSpeed = move_toward(mcc.currentTopDownSpeed, 0, decelAmount * delta)
				#mcc.velocity.x = currentVelDirection.x * newTopDownSpeed
				#mcc.velocity.z = currentVelDirection.y * newTopDownSpeed
			#else:
				#mcc.velocity.x = move_toward(mcc.velocity.x, mcc.requestedMoveDirection.x * mcc.traits.baseMoveSpeed, 1 * delta)
				#mcc.velocity.z = move_toward(mcc.velocity.z, mcc.requestedMoveDirection.z * mcc.traits.baseMoveSpeed, 1 * delta)
				#
		#if(abs(mcc.velocity.x) < .5): mcc.velocity.x = 0
		#if(abs(mcc.velocity.z) < .5): mcc.velocity.z = 0
		#
	#else:
		#var decelAmount = 10
		#if(mcc.currentVelDirection.dot(Vector2( mcc.requestedMoveDirection.x,  mcc.requestedMoveDirection.z)) > .9 and mcc.currentTopDownSpeed > mcc.currentSpeed):
			#var newTopDownSpeed = mcc.currentTopDownSpeed - decelAmount * delta
			#mcc.velocity.x = mcc.currentVelDirection.x * mcc.currentTopDownSpeed
			#mcc.velocity.z = mcc.currentVelDirection.y * mcc.currentTopDownSpeed
		#else:
			#var differenceX = mcc.velocity.x - (mcc.currentSpeed * mcc.requestedMoveDirection.x)
			#var differenceZ = mcc.velocity.z - (mcc.currentSpeed * mcc.requestedMoveDirection.z)
			#var speedDecayDirection = Vector2(differenceX, differenceZ) / current_speed()
			#if(current_speed() == 0):
				#speedDecayDirection = Vector2.ZERO
			#velocity.x = velocity.x - speedDecayDirection.x * AIR_SPEED_CHANGE_AMOUNT * delta
			#velocity.z = velocity.z - speedDecayDirection.y * AIR_SPEED_CHANGE_AMOUNT * delta
