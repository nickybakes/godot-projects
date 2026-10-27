class_name ComparisonRule extends MCCRule

enum Comparison{
	GreaterThan,
	GreaterThanOrEqualTo,
	Equal,
	NotEqual,
	LessThan,
	LessThanOrEqualTo
}

@export var node : Node;
@export var property : String;
@export var comparisonType : Comparison;
@export var node2 : Node;
@export var property2 : String;

func CheckForPass(state : MCCState, transition : MCCTransition, delta : float) -> bool:
	var value = node.get(property);
		
	var value2 = node2.get(property2);
	
	return DoComparison(value, value2);

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
