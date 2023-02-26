extends Node;

# Creates a deep copy of an array of floats
func clone_array_float(arr: Array[float]) -> Array[float]:
	var out: Array[float] = [];
	for x in arr:
		out.append(x);
	return out;
# Create a new array of floats with each value set to init_value
func generate_array_float(size: int, init_value: float) -> Array[float]:
	var out: Array[float] = [];
	for x in range(size):
		out.append(init_value);
	return out;
# Create a deep copy of an array of Matrix2d objects. Each matrix
# is copied using Matrix2d.copy()
func clone_array_matrix2d(arr:Array[Matrix2d]) -> Array[Matrix2d]:
	var out: Array[Matrix2d] = [];
	for x in arr:
		out.append(x.copy());
	return out;
