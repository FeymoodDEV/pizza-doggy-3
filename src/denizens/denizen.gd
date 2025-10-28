extends Node
class_name Denizen
## A denizen.

# I'm not sure what type to extend this from right now; I think it'll need to be serializable, so
# I picked Node but Resource could probably work as well

#

signal attempting_move(server: Server)

enum Mood {
	NORMAL,
	DISTURBED
}
## Moods that a denizen can be under. Displayed on UI.
# Add more as necessary

var denizen_name : String
## The name of the denizen. Randomly generated
var memory : Array = []
## Record of recent notable events the denizen was a witness to
var status : Mood

func delete():
	pass
