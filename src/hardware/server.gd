extends Node
class_name Server
# Should locations and servers be the same class?
# Probably, right?

signal broken_down

const MAX_INTEGRITY : float = 500.0
const BASE_WEAR_RATE : float = 1.0
const DENIZEN_WEAR_RATE_BONUS : float = 1.0
const ANOMALY_WEAR_RATE_BONUS : float = 10.0
const START_INTEGRITY_VARIATION_MAX : float = 75.0

## If true, the server is up and running.
var alive : bool = true
## If true, denizens cannot move in or out of this server
var closed : bool = false

static var server_locations: Array = [
	"Fountain",
	"Hotel",
	"Grocery Store",
	"Garbage Dump",
	"Office",
	"Plaza",
	"Coffee Shop",
	"Factory",
	"Theatre"
]

## The server's name.
var server_name: String
## The server's 'health'; goes does as it wears down.
var integrity: float

#var server_max_occupants: int

func _ready() -> void:
	# vary servers' starting integrity slightly
	integrity = MAX_INTEGRITY - (randf_range(0.0, START_INTEGRITY_VARIATION_MAX))

func _physics_process(delta: float) -> void:
	if alive:
		if integrity <= 0.0:
			alive = false
			broken_down.emit()
		else: 
			integrity -= get_wear_rate()
	

func get_wear_rate() -> float :
	var wear_rate : float = BASE_WEAR_RATE
	for c in get_children():
		if c is Denizen:
			wear_rate += DENIZEN_WEAR_RATE_BONUS
		if c is Anomaly:
			wear_rate += ANOMALY_WEAR_RATE_BONUS
	return wear_rate

func get_repair_costs():
	# TODO: this should be based on parts later on
	return {&"silica": 1}	
