extends MCCTraits
class_name BallTraits

@export var gravity : float = 10;
@export var gravityFallMultiplier : float = 1.5;
@export_range(0.0, 1.0, .01) var floorMinNormalY : float = .2;
@export var moveSpeed : float = 5;
@export var moveControl : float = 5;
@export var deceleration : float = 3;
@export var overSpeedThreshold : float = 5;
@export var overSpeedLimitDirectionalControl : float = .5;
@export var overSpeedMoveControl : float = 5;
@export var overSpeedDeceleration : float = 1.0;
@export var basicBounceMoveControlCooldown : Curve

@export_category("Fire")
@export var fireBuildUpBySpeed : Curve

@export_category("Jump")
@export var jumpForce : float = 3;
@export var jumpHover : float = 3;
@export var jumpInitialStaminaCost : float = 1;
@export var jumpHoverStaminaCost : float = 1;
@export var maxJumpTime : float = 1;

@export_category("Bounce")
@export_range(0.0, 1.0, .01) var basicBounceMinDotProduct : float = .3;
@export var basicBounceRequiredMinSpeed : float = 4;
@export var basicBounceTraits : BallBounceTraits;

@export_category("Charge")
@export var timeTilMaxCharge : float = .5;
@export var minChargeTime : float = .1;
@export var chargeDeceleration : float = 7;
@export_range(-1, 1, .01) var chargeDirectionMaxY : float = 0;
@export var chargeStaminaCost : float = 1;
@export var chargeMinStaminaCost : float = .3;

@export_category("Launch")
@export var minLaunchSpeed : float = 20;
@export var maxLaunchSpeed : float = 40;

@export_category("Block")
@export var blockDecelMin : float = 10;
@export var blockDecelMax : float = 30;
@export var blockDecelMaxSpeed : float = 40;
@export var blockStaminaSpeedBoost : float = 0.5;
@export var basicBounceWhileBlockingTraits : BallBounceTraits;

@export_range(0.0, 1.0, .01) var blockVerticalBounceDamp : float = 0.5;

@export_category("Deflect")
@export var deflectBounceTraits : BallBounceTraits;

@export_category("Strike")
@export var maxNumOfStrikedBalls : int = 1;
@export var minRequiredFireForStrike : float = 1;
@export var minRequiredStrikeSpeed : float = 10;

@export_group("Damage Calculation")
@export var baseStrikeDamage : float = 4;
@export var strikeDamageSpeedScalar : float = 10;
@export var strikeDamageFireMultScalar : float = 1;
@export var maxStrikeDamage : float = 20;

@export_group("Recovery")
@export var strikeActivatorRecoveryTime : float = .5;
@export var strikeVictimRecoveryTime : float = .5;

@export var strikeActivatorDeceleration : float = 1;
@export var strikeVictimDeceleration : float = .5;

@export_group("Strike Bounce")
@export var strikeSuccessBounceTraits : BallBounceTraits;
@export var strikeFailedBounceTraits : BallBounceTraits;
@export var strikeVictimBounceTraits : BallBounceTraits;
@export var strikeBlockerBounceTraits : BallBounceTraits;

@export_category("Clash")
@export var maxClashTime : float = 1.0;
@export var clashDeceleration : float = 10;
@export var clashBounceTraits : BallBounceTraits;

@export_category("Grab")
@export var maxNumOfGrabbedBalls : int = 8;
@export var grabAttemptBoost : BallBounceTraits;
@export var grabAttemptDeceleration : float = 5.0;
@export var grabStaminaCost : float = .5;
@export var grabCheckTime : float = .25;
@export var grabRecoveryTime : float = .25;

@export_group("Damage Calculation")
@export var baseGrabDamage : float = 10;
@export var grabDamageFireMultScalar : float = 1;

@export_group("Success")
@export var grabVerticalSpeedOverTime : Curve;
@export var grabAimPowerOverTime : Curve;
@export var grabSuccessDeceleration : float = 10.0;
@export var grabAimingTime : float;
@export_range(-1, 1, .01) var grabDirectionMaxY : float = 0;
@export var grabMinTime : float;
@export var grabSuccessBounce : BallBounceTraits;

@export_group("Victim")
@export var grabVictimSuction : float = 10.0;
@export var grabVictimTopDownOffset : float = 3.0;
@export var grabVictimVerticalOffset : float = 3.0;
@export_range(0.0, 1.0, 0.01) var grabVictimBounceAngleMix : float = .5;
@export var grabVictimBounceAnglePower : float = 1.0;
@export var grabVictimBounce : BallBounceTraits;


@export_group("Fail")
@export var grabFailRecoveryTime : float = 1.0;
@export var grabFailDeceleration : float = 6.0;


@export_category("Misc")
@export var fallbackMaxTimeInState : float = 8;

var zero := 0.0;
var one := 1.0;
