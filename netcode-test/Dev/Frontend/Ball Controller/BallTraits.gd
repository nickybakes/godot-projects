extends MCCTraits
class_name BallTraits

@export var gravity : float = 10;
@export var gravityFallMultiplier : float = 1.5;
@export var moveSpeed : float = 5;
@export var moveControl : float = 5;
@export var deceleration : float = 3;
@export var overSpeedThreshold : float = 5;
@export var overSpeedLimitDirectionalControl : float = .5;
@export var overSpeedMoveControl : float = 5;
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
@export_range(0.0, 1.0, .01) var basicBounceTopDownSpeedScalar : float = .7;
@export_range(0.0, 1.0, .01) var basicBounceVerticalSpeedScalar : float = .7;
@export var basicBounceMinSpeed : float = 4;

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

@export_category("Deflect")
@export var minDeflectBounceSpeed : float = 5;
@export_range(0.0, 1.0, .01) var deflectTopDownSpeedScalar : float = .7;
@export_range(0.0, 1.0, .01) var deflectVerticalSpeedScalar : float = .7;

@export_category("Strike")
@export var maxNumOfStrikedBalls : int = 1;

@export var minRequiredFireForStrike : float = 1;

@export var minRequiredStrikeSpeed : float = 10;

@export_group("Damage Calculation")
@export var minStrikeDamage : float = 10;
@export var strikeDamageSpeedScalar : float = 10;
@export var strikeDamageFireMultScalar : float = 1;

@export_group("Recovery")
@export var strikeActivatorRecoveryTime : float = .5;
@export var strikeVictimRecoveryTime : float = .5;

@export var strikeActivatorDeceleration : float = 1;
@export var strikeVictimDeceleration : float = .5;

@export_group("Activator Bounce")
@export var strikeActivatorMinBounceSpeed : float = 5;
@export var strikeActivatorMaxBounceSpeed : float = 15;
@export var strikeActivatorTopDownSpeedScalar : float = .7;
@export var strikeActivatorVerticalSpeedScalar : float = .7;

@export_group("Victim Bounce")
@export var strikeVictimMinBounceSpeed : float = 5;
@export var strikeVictimMaxBounceSpeed : float = 15;
@export var strikeVictimTopDownSpeedScalar : float = .7;
@export var strikeVictimVerticalSpeedScalar : float = .7;

@export_group("Blocker Bounce")
@export var strikeBlockerMinBounceSpeed : float = 5;
@export var strikeBlockerMaxBounceSpeed : float = 15;
@export var strikeBlockerTopDownSpeedScalar : float = .7;
@export var strikeBlockerVerticalSpeedScalar : float = .7;


@export_category("Clash")
@export var maxClashTime : float = 1.0;

@export_category("Misc")
@export var fallbackMaxTimeInState : float = 8;

var zero = 0.0;
