extends Node
class_name GameLogic

@export var INITIAL_DRONE_COUNT = 2

## Available drone count
var drones : int

@export var hardware_info : HardwareInfo

## Current resource counts
var current_resources : Dictionary[StringName, int]

## Server parts currently in storage
var current_parts : Dictionary[StringName, int]


var servers: Array[Node]
var denizens: Array[Node]

func _ready() -> void:
	drones = INITIAL_DRONE_COUNT
	
	# initialize resource counts
	for i in hardware_info.resources.keys():
		current_resources[i] = 0

	# We need to:
	# - Create initial servers. Keep track of em
	# - Create initial denizens and parent them to those servers. Keep track of em
	# - Connect relevant signals
	# - and do whatever else might be relevant at the start of the game.
	# Because we're just working with test objects, we can leave creating them for later.

	var children := get_children()
	# Amended to Node instead of Server
	servers = children.filter(func (x): return x is Server)
	denizens = []
	for s in servers:
		# connect relevant server signals here
		
		# denizens:
		for c in s.get_children():
			if c is Denizen:
				c.requesting_random_interaction.connect(_on_requesting_random_interaction.bind(c))
				c.requesting_random_move.connect(_on_requesting_random_move.bind(c))
				denizens.append(c)

func _on_requesting_random_interaction(emitter: Denizen):
	var server = emitter.get_parent() # TODO: do better
	
	# Get all denizens in the same server that can interact
	var available_denizens = server.get_children().filter(func(x): 
		return x is Denizen and x != emitter and x.can_interact()
		)
	if available_denizens.size() <= 0: 
		# "[x] is feeling lonely..."
		return
	var selected_denizen : Denizen = available_denizens.pick_random()
	
	selected_denizen.accept_interaction(emitter)

func _on_requesting_random_move(emitter: Denizen):
	var target_server = servers.pick_random()
	# don't move to the same server
	while target_server == emitter.get_parent(): # TODO: do better
		target_server = servers.pick_random()
	
	if target_server.closed:
		print("Server %s refused move request from %s due to being closed" % [target_server, emitter])
		# "[x] is annoyed/feeling claustrophobic..."
	else:
		print("%s moving to %s" % [emitter.denizen_name, target_server.server_name])
		emitter.reparent(target_server)

func _process(delta: float) -> void:
	pass

#region Drones
# TODO: Drone task handling
func order_harvest(resource: StringName):
	if drones <= 0:
		return
	
	var task := Timer.new()
	task.timeout.connect(_on_successful_harvest.bind(
		task,
		resource
	))
	# TODO: ui
	task.start(hardware_info.resources[resource][&"harvest_time"])

func order_repair(server: Server):
	if drones <= 0:
		return
	
	# check if we meet the cost requirements
	var requirements = server.get_repair_costs()
	for resource in requirements.keys():
		if current_resources[resource] < requirements[resource]:
			return
	
	# pay the cost
	for resource in requirements.keys():
		current_resources[resource] -= requirements[resource]
	
	# create the task
	var task := Timer.new()
	task.timeout.connect(_on_successful_harvest.bind(
		task,
		server
	))
	# TODO: ui
	task.start(30.0)

func order_synthesis(recipe: StringName):
	if drones <= 0:
		return
	
	var requirements : Dictionary = hardware_info.recipes[recipe]
	var harvest_time = requirements[&"harvest_time"]
	requirements.erase(&"harvest_time") # this sucks i know
	for resource in requirements.keys():
		if current_resources[resource] < requirements[resource]:
			return
	
	# pay the cost
	for resource in requirements.keys():
		current_resources[resource] -= requirements[resource]
	
	var task := Timer.new()
	task.timeout.connect(_on_successful_synthesis.bind(
		task,
		recipe
	))
	# TODO: ui
	task.start(harvest_time)

func _on_successful_harvest(task: Timer, resource: StringName):
	drones += 1
	current_resources[resource] += hardware_info.resources[resource][&"harvest_count"]
	# TODO: ui
	task.queue_free()
	
func _on_successful_repair(task: Timer, server: Server):
	drones += 1
	server.integrity = server.MAX_INTEGRITY
	server.alive = true

func _on_successful_synthesis(task: Timer, item: StringName):
	drones += 1
	if item == &"new_drone":
		drones += 1
	else:
		current_parts[item] = 1 if item in current_parts else current_parts[item] + 1
#endregion
