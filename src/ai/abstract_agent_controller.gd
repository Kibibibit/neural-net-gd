class_name AbstractAgentController;
extends Node2D;


var network: NeuralNetwork
var fitness: float = 0.0;


func fitness_function() -> float:
	Utils.implement();
	return 0.0

func get_inputs() -> Array[float]:
	Utils.implement();
	return [];

func process_outputs(_outputs: Array[float]) -> void:
	Utils.implement();
	pass;

func pre_process(_delta: float) -> void:
	pass;

func post_process(_delta: float) -> void:
	pass;

func _process(delta):
	pre_process(delta);
	var inputs: Array[float] = get_inputs();
	process_outputs( network.forward_propogate(inputs));
	post_process(delta);
	fitness += fitness_function();
