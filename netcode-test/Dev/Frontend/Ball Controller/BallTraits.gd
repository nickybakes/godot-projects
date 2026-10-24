extends MCCTraits
class_name BallTraits

@export var gravity : float = 10;
@export var gravityFallMultiplier : float = 1.5;
@export var moveSpeed : float = 5;
@export var deceleration : float = 3;
@export var jumpHeight : float = 3;

@export_category("Charge and Launch")
@export var timeTilMaxCharge : float = .5;
@export var minChargeTime : float = .1;
@export var chargeDeceleration : float = 7;
@export var minLaunchSpeed : float = 20;
@export var maxLaunchSpeed : float = 40;
