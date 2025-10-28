extends Node
class_name Server
# Should locations and servers be the same class?
# Probably, right?

@export var server_name: String
## The server's name.
var integrity: float
## The server's 'health'; goes does as it wears down.
