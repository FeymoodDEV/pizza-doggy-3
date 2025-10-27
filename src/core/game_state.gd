extends Node
class_name GameState

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



func _ready() -> void:
	drones = INITIAL_DRONE_COUNT
	
	# We need to:
	# - Create initial servers. Keep track of em
	# - Create initial denizens and parent them to those servers. Keep track of em
	# - Connect relevant signals
	# - and do whatever else might be relevant at the start of the game.
	# Because we're just working with test objects, we can leave creating them for later.
	
	var children := get_children()
	var servers : Array[Server] = children.filter(func (x): return x is Server)
	var denizens : Array[Denizen] = []
	for s in servers:
		for i in s.get_children():
			if i is Denizen:
				denizens.append(i)
		
	

func _process(delta: float) -> void:
	pass

# TODO: Drone task handling
# 
