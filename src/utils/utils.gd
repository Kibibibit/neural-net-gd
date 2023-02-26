extends Node;


func clone_array_float(arr: Array[float]) -> Array[float]:
	var out: Array[float] = [];
	for x in arr:
		out.append(x);
	return out;

func generate_array_float(size: int, init_value: float) -> Array[float]:
	var out: Array[float] = [];
	for x in range(size):
		out.append(init_value);
	return out;

func clone_array_matrix2d(arr:Array[Matrix2d]) -> Array[Matrix2d]:
	var out: Array[Matrix2d] = [];
	for x in arr:
		out.append(x.copy());
	return out;
