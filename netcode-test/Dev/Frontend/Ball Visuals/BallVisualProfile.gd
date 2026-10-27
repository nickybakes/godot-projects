extends Resource
class_name BallVisualProfile

@export_category("Roll")
@export var rollSpeedScalar : float;
@export var spinFaceMinSpeed : float;
@export var pitchChangeSpeed : float;
@export var rollStretchSpeedScalar : float;
@export var maxRollStretch : float;
@export var rollMinThin : float;

@export_category("Fire")
@export var fireRollSpeedScalar : float;

@export_category("Invuln")
@export var invulnBlinkSpeed : float;

@export_category("Charge")
@export var maxStretchCharge : float;
@export var minThinCharge : float;
@export var maxOffsetCharge : float;
@export var maxChargeRollSpeed : float;
