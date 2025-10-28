extends Node

@onready var game_logic: GameState = $GameLogic

@onready var server_list: GridContainer = %ServerList

var server_occupants_scene = preload("res://scenes/debug/server_occupants.tscn")
var denizen_label_scene = preload("res://scenes/ui/server_list/denizen_name.tscn")

func _ready() -> void:
	setup_UI()

func setup_UI():
	var server_loc_names = game_logic.servers[0].server_locations.duplicate()
	for server in game_logic.servers:
		var server_occupants = server_occupants_scene.instantiate()
		server_list.add_child(server_occupants, true)

		var random_index = randi_range(0, server_loc_names.size() - 1)
		server.server_name = server_loc_names.pop_at(random_index)
		server_occupants.server_label.text = server.server_name

		var denizen_panel = server_occupants.denizen_panel

		for child in server.get_children():
			#print(child)
			if child is Denizen:
				child.generate_name()
				#print(child.denizen_name)
				var denizen_label = denizen_label_scene.instantiate()
				denizen_panel.denizen_names_container.add_child(denizen_label, true)

				denizen_label.text = child.denizen_name
