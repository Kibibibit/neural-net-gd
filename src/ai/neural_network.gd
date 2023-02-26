class_name NeuralNetwork;

const eulers:float = 2.718281
const mutation_chance: float = 0.2;
const mutation_amount: float = 0.1;

var input_nodes: int;
var output_nodes: int;
var hidden_layers: Array[int];

var weights: Array[Matrix2d];
var biases: Array[Matrix2d];

func _init(_weights: Array[Matrix2d], _biases: Array[Matrix2d]):
	weights = Utils.clone_array_matrix2d(_weights);
	biases = Utils.clone_array_matrix2d(_biases);
	
	hidden_layers = [];
	for i in range(weights.size()-1):
		var w: Matrix2d = weights[i];
		hidden_layers.append(w.rows);
	input_nodes = weights.front().cols;
	output_nodes = weights.back().rows;

func _sigmoid(value: float) -> float:
	return 1.0/(1.0+pow(eulers,-value));

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

func forward_propogate(_inputs: Array[float]) -> Array[float]:
	var current_matrix: Matrix2d = Matrix2d.new(input_nodes,1,_inputs);
	for i in range(weights.size()):
		var weight: Matrix2d = weights[i];
		var bias: Matrix2d = biases[i];
		current_matrix = weight.multiply(current_matrix).addition(bias).map(Callable(self,"_sigmoid"));
	return current_matrix.data;

func reproduce(other: NeuralNetwork) -> NeuralNetwork:
	var _weights: Array[Matrix2d] = [];
	var _biases: Array[Matrix2d] = [];
	for i in range(weights.size()):
		_weights.append(weights[i].reproduce(other.weights[i], mutation_chance, mutation_amount));
		_biases.append(biases[i].reproduce(other.biases[i], mutation_chance, mutation_amount));
	return NeuralNetwork.new(_weights,_biases)

func copy() -> NeuralNetwork:
	var _weights = Utils.clone_array_matrix2d(weights);
	var _biases = Utils.clone_array_matrix2d(biases);
	return NeuralNetwork.new(_weights,_biases);
