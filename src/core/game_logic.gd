extends Node
class_name GameLogic

const DENIZEN = preload("uid://rccmoiibmewl")

@onready var ui: Control = %UI

## Number of drones the player starts with
@export var INITIAL_DRONE_COUNT : int = 2
## Resource that contains resource types, components and recipes
@export var HARDWARE_INFO : HardwareInfo
## Number of randomly generated servers to start with
@export var START_SERVER_COUNT : int = 6
## Number of randomly generated denizens to start with
@export var START_DENIZEN_COUNT : int = 20

## References to all servers
var servers: Array[Server]
## References to all denizens
var denizens: Array[Denizen]
## Available drone count
var drones : int
## Current resource counts
var current_resources : Dictionary[StringName, int]
## Server parts currently in storage
var current_parts : Dictionary[StringName, int]

#region Setup
func _ready() -> void:
	randomize()
	drones = INITIAL_DRONE_COUNT
	
	# initialize resource counts
	for i in HARDWARE_INFO.resources.keys():
		current_resources[i] = 0
	
	# Initials entities
	#setup_with_predefined()
	setup_with_random()
	
	# Setup ui cards and signals; see ui.gd
	ui.setup(servers)

## Generate new Servers and Denizens and perform setup operations.
func setup_with_random() -> void:
	for i in range(0, START_SERVER_COUNT):
		var new_server : Server = Server.new()
		# Select random name while ensuring it's unique
		new_server.server_name = Server.server_locations.pick_random()
		while servers.any(func(x): return x.server_name == new_server.server_name):
			new_server.server_name = Server.server_locations.pick_random()
		
		new_server.name = new_server.server_name
		servers.append(new_server)
		add_child(new_server)
	
	for i in range(0, START_DENIZEN_COUNT):
		var new_den : Denizen = DENIZEN.instantiate()
		# Select random name while ensuring it's unique
		new_den.denizen_name = Denizen.name_list.pick_random()
		while denizens.any(func(x): return x.denizen_name == new_den.denizen_name):
			new_den.denizen_name = Denizen.name_list.pick_random()
		
		new_den.name = new_den.denizen_name
		denizens.append(new_den)
		# choose a random server to put them in
		servers.pick_random().add_child(new_den)
		# connect signals
		new_den.requesting_random_interaction.connect(_on_requesting_random_interaction.bind(new_den))
		new_den.requesting_random_move.connect(_on_requesting_random_move.bind(new_den))

## Searches existing Server and Denizen children of the node and perform setup
## operations.
func setup_with_predefined() -> void:
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
#endregion

#region Denizen base AI requests
func _on_requesting_random_interaction(emitter: Denizen) -> void:
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
	selected_denizen.status_changed.emit()
	emitter.status_changed.emit()

func _on_requesting_random_move(emitter: Denizen) -> void:
	var target_server = servers.pick_random()
	# don't move to the same server
	while target_server == emitter.get_parent(): # TODO: do better
		target_server = servers.pick_random()
	
	if target_server.closed:
		SignalBus.standard_message.emit("Server %s refused move request from %s due to being closed." % [target_server, emitter])
		# "[x] is annoyed/feeling claustrophobic..."
	else:
		SignalBus.standard_message.emit("%s has entered %s." % [emitter.denizen_name, target_server.server_name])
		emitter.reparent(target_server)
		emitter.status_changed.emit()
#endregion

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
	task.start(HARDWARE_INFO.resources[resource][&"harvest_time"])

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
	
	var requirements : Dictionary = HARDWARE_INFO.recipes[recipe]
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

func _on_successful_harvest(task: Timer, resource: StringName) -> void:
	drones += 1
	current_resources[resource] += HARDWARE_INFO.resources[resource][&"harvest_count"]
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
