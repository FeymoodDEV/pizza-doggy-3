extends Node
class_name Server
# Should locations and servers be the same class?
# Probably, right?

## If true, denizens cannot move in or out of this server
var closed : bool = false

var server_locations: Array = [
	"Fountain",
	"Hotel",
	"Grocery Store",
	"Garbage Dump",
	"The Office"
]

var server_name: String
## The server's name.
var integrity: float
## The server's 'health'; goes does as it wears down.

#var server_max_occupants: int
