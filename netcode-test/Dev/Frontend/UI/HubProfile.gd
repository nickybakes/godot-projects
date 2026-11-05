extends Resource
class_name HubProfile

@export var separationAmounts : Array[int];


func GetSeparationAmount(elementAmount : int) -> int:
	if(elementAmount >= separationAmounts.size()):
		return 0;
		
	return separationAmounts[elementAmount];
