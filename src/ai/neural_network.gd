class_name NeuralNetwork;

# Eulers number, to 6 decimal places
const eulers:float = 2.718281
# The chance a weight or bias will be mutated when a network reproduces
const mutation_chance: float = 0.2;
# The amount a matrix can mutate either positively or negatively
const mutation_amount: float = 0.1;

# How many input nodes this matrix has
var input_nodes: int;
# How many output nodes this matrix has
var output_nodes: int;
# Each element of hidden_layers represents how many nodes that layer has,
# with the net having hidden_layers hidden layers of nodes
var hidden_layers: Array[int];

# The weight matrices for each layer. Each matrix i has the weights for layer i-1 to i
var weights: Array[Matrix2d];
# The bias matrices for each layer. Each matrix i has the biases for layer i-1 to i
var biases: Array[Matrix2d];

# Creates a new neural network from a list of weight and bias matrices.
# Ideally, don't use this constructor unless you're calling it from another function
func _init(_weights: Array[Matrix2d], _biases: Array[Matrix2d]):
	assert(_weights.size() == _biases.size(), "There must be an equal number of weight and bias matrices");
	weights = Utils.clone_array_matrix2d(_weights);
	biases = Utils.clone_array_matrix2d(_biases);
	
	hidden_layers = [];
	for i in range(weights.size()-1):
		var w: Matrix2d = weights[i];
		hidden_layers.append(w.rows);
	input_nodes = weights.front().cols;
	output_nodes = weights.back().rows;

# A sigmoid curve
func _sigmoid(value: float) -> float:
	return 1.0/(1.0+pow(eulers,-value));

# Creates a new neural network with the given size. All weights and biases
# will be between -1.0 and 1.0
static func new_random(_input_nodes: int, _output_nodes: int, _hidden_layers: Array[int]) -> NeuralNetwork:
	var arr: Array[int] = [_input_nodes]
	arr.append_array(_hidden_layers);
	arr.append(_output_nodes);
	var _weights: Array[Matrix2d] = [];
	var _biases: Array[Matrix2d] = [];
	for i in range(1,arr.size()):
		_weights.append(Matrix2d.new_random(arr[i],arr[i-1]));
		_biases.append(Matrix2d.new_random(arr[i],1));
	return NeuralNetwork.new(_weights,_biases);

# Runs a set of inputs through the neural network and returns the value of each output node
# The inputs are multiplied by each layers weight matrix, added to each layers bias matrix and then
# each value is run through an activation function
func forward_propogate(_inputs: Array[float]) -> Array[float]:
	assert(_inputs.size() == input_nodes, "The amount of inputs must match the amount of input neurons");
	var current_matrix: Matrix2d = Matrix2d.new(input_nodes,1,_inputs);
	for i in range(weights.size()):
		var weight: Matrix2d = weights[i];
		var bias: Matrix2d = biases[i];
		current_matrix = weight.multiply(current_matrix).addition(bias).map(Callable(self,"_sigmoid"));
	return current_matrix.data;

# Creates a new neural network by reproducing each corresponding weight and bias matrix
# in the other neural network
func reproduce(other: NeuralNetwork) -> NeuralNetwork:
	var _weights: Array[Matrix2d] = [];
	var _biases: Array[Matrix2d] = [];
	for i in range(weights.size()):
		_weights.append(weights[i].reproduce(other.weights[i], mutation_chance, mutation_amount));
		_biases.append(biases[i].reproduce(other.biases[i], mutation_chance, mutation_amount));
	return NeuralNetwork.new(_weights,_biases)

# Creates a deep copy of this neural network
func copy() -> NeuralNetwork:
	var _weights = Utils.clone_array_matrix2d(weights);
	var _biases = Utils.clone_array_matrix2d(biases);
	return NeuralNetwork.new(_weights,_biases);
