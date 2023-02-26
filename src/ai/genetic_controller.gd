class_name GeneticController;
extends Node2D;

const agent_count: int = 100;
const surviving_agents: int = 10;
# Function that creates a new agent object
var create_agent: Callable;

var agent_map: Dictionary = {};
var active_agents: Array[int] = [];

var generation: int = 0;
var running: bool = false;

func _init(_create_agent: Callable):
	create_agent = _create_agent;

func _sort_ids(a:int, b:int):
	return (agent_map[a] as AbstractAgentController).fitness > (agent_map[b] as AbstractAgentController).fitness;

func create_initial_generation(input_nodes: int, output_nodes: int, hidden_layers: Array[int]):
	for i in range(agent_count):
		var brain: NeuralNetwork = NeuralNetwork.new_random(input_nodes, output_nodes, hidden_layers);
		var agent: AbstractAgentController = (create_agent.call() as AbstractAgentController);
		agent.network = brain;
		agent_map[agent.get_instance_id()] = agent;
		active_agents.append(agent.get_instance_id());
		add_child(agent);
	running = true;

func create_next_generation():
	
	var agent_ids: Array[int] = agent_map.keys();
	agent_ids.sort_custom(Callable(self,"_sort_ids"));
	
	var survivors: Array[NeuralNetwork] = [];
	for i in range(surviving_agents):
		var agent: AbstractAgentController = agent_map[agent_ids[i]];
		survivors.append(agent.network.copy());
	
	var new_brains: Array[NeuralNetwork] = [];
	while new_brains.size() < agent_count-surviving_agents:
		var brain_a_index: int = randi_range(0,surviving_agents);
		var brain_b_index: int = brain_a_index;
		while brain_a_index == brain_b_index:
			brain_b_index = randi_range(0,surviving_agents);
		new_brains.append(survivors[brain_a_index].reproduce(survivors[brain_b_index]));
	new_brains.append_array(survivors);
	
	for agent in agent_map.values():
		agent.queue_free();
		remove_child(agent);
	
	agent_map = {};
	active_agents = [];
	generation += 1;
	
	for brain in new_brains:
		var agent: AbstractAgentController = (create_agent.call() as AbstractAgentController);
		agent.network = brain;
		agent_map[agent.get_instance_id()] = agent;
		active_agents.append(agent.get_instance_id());
		add_child(agent);
	
