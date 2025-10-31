extends Node
class_name Denizen
## A denizen.

# I'm not sure what type to extend this from right now; I think it'll need to be serializable, so
# I picked Node but Resource could probably work as well

signal requesting_random_move
signal requesting_random_interaction

enum Mood {
	NORMAL,
	DISTURBED
}
## Moods that a denizen can be under. Displayed on UI.
# Add more as necessary

@onready var base_den_controller: DenController = $BaseDenController

static var name_list = [
	"Fred",
	"Barry",
	"Sally",
	"Morticia",
	"Leopold",
	"Lilith",
	"Chris",
	"Sanae",
	"Hiren",
	"Josh",
	"Jon",
	"Stuart",
	"Randall",
	"Lauren",
	"Sanju",
	"Paul",
	"Sharon",
	"Kendle",
	"Gina",
	"Kathleen",
	"Prajakta",
	"Cynthia",
	"Jeffrey",
	"Bruce",
	"Naomi",
	"Andrew"
]

var denizen_name : String
## The name of the denizen. Randomly generated
var memory : Array = []
## Record of recent notable events the denizen was a witness to
var status : Mood

func _ready() -> void:
	SignalBus.purge_denizen.connect(on_purge_denizen_button_pressed)
	base_den_controller.target = self
	base_den_controller.enabled = true

func generate_name():
	randomize()
	var rand_index = randi_range(0, name_list.size() - 1)
	denizen_name = name_list[rand_index]

func start_chat_response() -> String:
	match status:
		Mood.NORMAL:
			return "I am having a good time."
		Mood.DISTURBED:
			return "The voices are loud again. They won't stop."
		_:
			return "No data available."

func describe_mood() -> String:
	var mood: String
	match status:
		Mood.NORMAL:
			mood = "Calm."
		Mood.DISTURBED:
			mood = "Unstable."
		_: "Unknown."
	return mood

func describe_last_event() -> String:
	if memory.is_empty():
		return  "I do not recall anything recent."
	else:
		return memory[-1]
		

func on_purge_denizen_button_pressed(denizen):
	delete(denizen)

func delete(denizen):
	if denizen == self:
		queue_free()

## Interact with a denizen.
func accept_interaction(denizen: Denizen):
	print("%s is interacting with %s" % [denizen.denizen_name, self.denizen_name])
	pass

## Returns true if the denizen is available for interaction with other denizens.
## Anomalies could be made to affect this
func can_interact():
	return true
