extends Node2D;


# Called when the node enters the scene tree for the first time.
func _ready():
	var net = NeuralNetwork.new_random(3,2,[2,4]);
	
	print(net.forward_propogate([0.3,0.6,1.0]));

