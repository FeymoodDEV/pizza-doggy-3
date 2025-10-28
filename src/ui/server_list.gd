extends GridContainer
class_name ServerList

func _ready() -> void:
	# remove debug occupants
	if get_children().size() > 0:
		for child in get_children():
			child.queue_free()
