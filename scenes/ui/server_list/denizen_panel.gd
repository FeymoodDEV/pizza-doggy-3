extends Panel

@onready var denizen_names_container: VBoxContainer = %DenizenNamesContainer


func _ready() -> void:
	# Remove debug labels
	if denizen_names_container.get_children().size() > 0:
		for child in denizen_names_container.get_children():
			child.queue_free()
