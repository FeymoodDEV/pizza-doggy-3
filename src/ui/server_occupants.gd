extends HBoxContainer
class_name ServerOccupants

@onready var server_label: Label = %ServerLabel
@onready var max_occupants_label: Label = %MaxOccupantsLabel
@onready var denizen_panel: Panel = $VBoxContainer/DenizenPanel

var limit: int = 0
var current_occupants: int = 0

func set_max_occupants(new_limit: int, new_current_occupants: int):
	limit = new_limit
	current_occupants = new_current_occupants
	max_occupants_label.text = "Max Occupants - " + str(current_occupants) + "/" + str(limit)
