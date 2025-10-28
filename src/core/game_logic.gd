extends Node
class_name GameLogic

@export var INITIAL_DRONE_COUNT = 2

var drones : int
## Available drone count

enum CraftingResource {
	SILICA,
	COPPER,
	GLASS,
	PLASTIC,
	GOLD,
	ALUMINUM,
	HAFNIUM,
}
## Resources that exist in the game

var resources : Dictionary[CraftingResource, int] = {
	CraftingResource.SILICA: 0,
	CraftingResource.COPPER: 0,
	CraftingResource.GLASS: 0,
	CraftingResource.PLASTIC: 0,
	CraftingResource.GOLD: 0,
	CraftingResource.ALUMINUM: 0,
	CraftingResource.HAFNIUM: 0,
}
## Resources available
# change this to stringnames if you hate enums; but it's not like we'll add more
# and i don't really like magic strings


var servers: Array[Node]
var denizens: Array[Node]


func _ready() -> void:
	##drones = INITIAL_DRONE_COUNT

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
	var selected_denizen : Denizen = available_denizens.pick_random()
	
	selected_denizen.accept_interaction(emitter)

func _on_requesting_random_move(emitter: Denizen):
	var target_server = servers.pick_random()
	# don't move to the same server
	while target_server == emitter.get_parent(): # TODO: do better
		target_server = servers.pick_random()
	
	if target_server.closed:
		print("Server %s refused move request from %s due to being closed" % [target_server, emitter])
	else:
		emitter.reparent(target_server)

func _process(delta: float) -> void:
	pass

# TODO: Drone task handling
#
