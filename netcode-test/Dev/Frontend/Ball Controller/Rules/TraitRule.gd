class_name TraitRule extends MCCRule

enum Comparison{
	GreaterThan,
	GreaterThanOrEqualTo,
	Equal,
	NotEqual,
	LessThan,
	LessThanOrEqualTo
}

@export var stateProperty : String;
@export var comparisonType : Comparison;
@export var traitProperty : String;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	var stateValue = state.get(stateProperty);
	var traitValue = state.GetMCC().GetTraits().get(traitProperty);
	
	return DoComparison(stateValue, traitValue);

func DoComparison(a : float, b : float) -> bool:
	match(comparisonType):
		Comparison.GreaterThan:
			return a > b;
		Comparison.GreaterThanOrEqualTo:
			return a >= b;
		Comparison.Equal:
			return a == b;
		Comparison.NotEqual:
			return a != b;
		Comparison.LessThan:
			return a < b;
		Comparison.LessThanOrEqualTo:
			return a <= b;
	return false;
