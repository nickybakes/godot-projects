extends Resource
class_name BallVisualProfile

@export_category("Roll")
@export var rollSpeedScalar : float;
@export var spinFaceMinSpeed : float;
@export var pitchChangeSpeed : float;
@export var rollStretchSpeedScalar : float;
@export var maxRollStretch : float;
@export var rollMinThin : float;

@export_category("Electric")
@export var electricRollSpeedScalar : float;

@export_category("Invuln")
@export_range(0.0, 1.0, 0.01) var invulnBlinkOff : float = .15;
@export var invulnBlinkTime : float = 1.0;

@export_category("Charge")
@export var maxStretchCharge : float;
@export var minThinCharge : float;
@export var maxOffsetCharge : float;
@export var maxChargeRollSpeed : float;

@export_category("Grab")
@export var grabAimTopDownAngleScalar : float = 4;

@export_category("Messages")
@export var eliminatedMessageTime : float = 4;
@export var strikePriorityMessageTime : float = 1.5;
@export var unblockableMessageTime : float = 1.5;

@export_category("Tracker Line")
@export var trackerLineSpeedAlphaMultiply : float = 1.0;
@export var trackerLineSpeedAlphaMultiplyMax : float = 1.0;
@export var trackerLineStrikeHeartbeat : float = 2.0;
@export var trackerLineGrabHeartbeat : float = 2.0;
@export var trackerLineStrikeAlphaMultiply : float = 7.0;
@export var trackerLineGrabAlphaMultiply : float = 10.0;

@export_category("Camera Shake")
@export var strikeCameraShake : float = .25;
@export var grabCameraShake : float = .25;
@export var eliminationCameraShake : float = .75;
