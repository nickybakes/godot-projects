extends Control
class_name ClockDisplay

@export var minuteLabel : Label;
@export var secondLabel : Label;


func DisplayTime(time : float):
	var min = floor(time/60.0);
	var sec = time - (min * 60);
	minuteLabel.text = "%02d" % min;
	secondLabel.text = "%02d" % sec;
