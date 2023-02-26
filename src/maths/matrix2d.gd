class_name Matrix2d;

### An implementation of a standard 2d Mathematical
### Matrix

# The amount of vertical columns in the matrix
var cols: int;
# The amount of horizontal rows in the matrix
var rows: int;

# The data of each part of the matrix, stored in a 1d array of floats
var data: Array[float];

# Takes in sizes and forces _data to match the shape. Don't use this constructor
# unless you're calling it from within this class. Use from_2d_array or new_random
# instead
func _init(_rows:int, _cols: int, _data:Array[float]):
	assert(_rows*_cols == _data.size(), "Rows*Columns must equal length of array");
	data = _data;
	rows = _rows;
	cols = _cols;

# Takes in a 2d array of floats and converts it to a matrix. The outer array stores each row,
# so _data[y][x] should represent the item at x,y in the matrix
static func from_2d_array(_data:Array[Array]) -> Matrix2d:
	assert(_data.size() > 1, "You need at least 1 row to create a matrix");
	var _rows: int = _data.size();
	var _cols: int = _data.front().size();
	var _new_data: Array[float] = [];
	for row in _data:
		assert(_rows == _data.front().size(), "Each row must have the same length");
		for x in row:
			_new_data.append(x as float);
	return Matrix2d.new(_rows,_cols,_new_data);

# For getting a 1d array index for a matrix that is not this one.
# _cols is the width of other matrix
func other_index(_cols:int, x:int, y:int) -> int:
	assert(x >= 0 && x < _cols && y >= 0, "x and y must be within the matrix");
	return (y*_cols) + x;
# Takes an x and y coordinate and turns it into a 1d array index based on
# the size of the matrix
func index(x:int, y:int) -> int:
	assert(x >= 0 && x < cols && y >= 0 && y < rows, "x and y must be within the matrix");
	return (y*cols) + x;

# Get the value at x,y in the matrix
func get_value(x:int, y:int) -> float:
	assert(x >= 0 && x < cols && y >= 0 && y < rows, "x and y must be within the matrix");
	return data[index(x,y)];

# Sets the value at x,y in the matrix
func set_value(x:int,y:int,value:float) -> void:
	assert(x >= 0 && x < cols && y >= 0 && y < rows, "x and y must be within the matrix");
	data[index(x,y)] = value;

# Returns a deep copy of this matrix
func copy() -> Matrix2d:
	return Matrix2d.new(rows,cols,Utils.clone_array_float(data));

# Creates a new matrix of width _cols and height _rows, with each value set
# to a random value between -1.0 and 1.0
static func new_random(_rows:int, _cols:int) -> Matrix2d:
	randomize();
	var _data: Array[float] = [];
	for i in range(_rows*_cols):
		_data.append(randf_range(-1.0,1.0));
	return Matrix2d.new(_rows,_cols,_data);

# Multiplies this matrix by another matrix. The other matrix must have the same amount
# of rows as this matrix has columns. The resulting matrix will have the same amount of rows
# as this matrix and the same amount of columns as the other matrix
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

# Adds each value of this matrix to the matching value in the other matrix.
# The matrices must be the same size
func addition(other:Matrix2d) -> Matrix2d:
	assert(cols == other.cols && rows == other.rows, "Matrices must be the same size to add");
	var _data: Array[float] = Utils.generate_array_float(rows*cols,0.0);
	for y in range(cols):
		for x in range(rows):
			_data[index(x,y)] = get_value(x,y) + other.get_value(x,y);
	return Matrix2d.new(rows,cols,_data);

# Creates a new matrix where each value from this matrix has been passed through
# a function fn.
func map(fn: Callable) -> Matrix2d:
	var _data: Array[float] = [];
	for i in data:
		_data.append(fn.call(i));
	return Matrix2d.new(rows,cols,_data);

# Combines this matrix with another matrix randomly. Each value of the new 
# matrix has a %50 percent chance to be from either matrix. The value then has a 
# mutation_chance% chance of being adjusted by -mutation_amount to mutation_amount
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

# Prints the matrix out in a slightly more readable way
func nice_print() -> void:
	for y in range(rows):
		var out: Array[float] = [];
		for x in range(cols):
			out.append(get_value(x,y));
		print(out);
