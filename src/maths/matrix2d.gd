class_name Matrix2d;


var cols: int;
var rows: int;
var data: Array[float];


func _init(_rows:int, _cols: int, _data:Array[float]):
	assert(_rows*_cols == _data.size(), "Rows*Columns must equal length of array");
	data = _data;
	rows = _rows;
	cols = _cols;

static func from_2d_array(_data:Array[Array]) -> Matrix2d:
	var _rows: int = _data.size();
	var _cols: int = _data[0].size();
	var _new_data: Array[float] = [];
	for row in _data:
		for x in row:
			_new_data.append(x as float);
	return Matrix2d.new(_rows,_cols,_new_data);

func other_index(_cols:int, x:int, y:int) -> int:
	return (y*_cols) + x;

func index(x:int, y:int) -> int:
	return (y*cols) + x;

func get_value(x:int, y:int) -> float:
	return data[index(x,y)];

func set_value(x:int,y:int,value:float) -> void:
	data[index(x,y)] = value;

func copy() -> Matrix2d:
	return Matrix2d.new(rows,cols,Utils.clone_array_float(data));

static func new_random(_rows:int, _cols:int) -> Matrix2d:
	randomize();
	var _data: Array[float] = [];
	for i in range(_rows*_cols):
		_data.append(randf_range(-1.0,1.0));
	return Matrix2d.new(_rows,_cols,_data);

func multiply(other: Matrix2d) -> Matrix2d:
	assert(cols == other.rows, "A.columns must equal B.rows");
	var _rows: int = rows;
	var _cols: int = other.cols;
	var _data: Array[float] = Utils.generate_array_float(_rows*_cols,0.0);
	
	for y in range(_rows):
		for x in range(_cols):
			var value: float = 0;
			for j in range(cols):
				value += get_value(j,y)*other.get_value(x,j);
			_data[other_index(_cols,x,y)] = value;
			
	return Matrix2d.new(_rows,_cols,_data);

func addition(other:Matrix2d) -> Matrix2d:
	assert(cols == other.cols && rows == other.rows, "Matrices must be the same size to add");
	var _data: Array[float] = Utils.generate_array_float(rows*cols,0.0);
	for y in range(cols):
		for x in range(rows):
			_data[index(x,y)] = get_value(x,y) + other.get_value(x,y);
	return Matrix2d.new(rows,cols,_data);

func map(fn: Callable) -> Matrix2d:
	var _data: Array[float] = [];
	for i in data:
		_data.append(fn.call(i));
	return Matrix2d.new(rows,cols,_data);

func reproduce(other:Matrix2d, mutation_chance: float, mutation_amount: float) -> Matrix2d:
	assert(cols == other.cols && rows == other.rows, "Matrices must be the same size to reproduce");
	var _data: Array[float] = Utils.clone_array_float(data);
	for i in range(other.data).size():
		randomize();
		#Select one of two values
		var r = randf_range(0.0,1.0);
		if (r > 0.5):
			_data[i] = other.data[i];
		#Mutate
		var m = randf_range(0.0,1.0);
		if (m < mutation_chance):
			_data[i] += randf_range(-mutation_amount, mutation_amount);
	return Matrix2d.new(rows,cols,_data);

func nice_print() -> void:
	for y in range(rows):
		var out: Array[float] = [];
		for x in range(cols):
			out.append(get_value(x,y));
		print(out);
