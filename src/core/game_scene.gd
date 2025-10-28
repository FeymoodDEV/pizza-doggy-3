extends Node

@onready var game_logic: GameLogic = $GameLogic

@onready var server_list: GridContainer = %ServerList

var server_occupants_scene = preload("res://scenes/ui/server_list/server_occupants.tscn")
var denizen_data_display_scene = preload("res://scenes/ui/server_list/denizen_data_display.tscn")

func _ready() -> void:
	SignalBus.purge_denizen.connect(on_purge_button_pressed)

	setup_UI()

func setup_UI():
	if server_list.get_children().size() > 0:
		for child in server_list.get_children():
			child.queue_free()
	var server_loc_names = game_logic.servers[0].server_locations.duplicate()
	for server in game_logic.servers:
		var server_occupants = server_occupants_scene.instantiate()
		server_list.add_child(server_occupants, true)

		if server.server_name == "":
			var random_index = randi_range(0, server_loc_names.size() - 1)
			server.server_name = server_loc_names.pop_at(random_index)
		server_occupants.server_label.text = server.server_name

		var denizen_panel = server_occupants.denizen_panel
		#var denizen_count: int = 0
		for child in server.get_children():
			#print(child)
			if child is Denizen:
				#denizen_count += 1
				if child.denizen_name == "":
					child.generate_name()
				#print(child.denizen_name)
				var denizen_data_display = denizen_data_display_scene.instantiate()
				denizen_panel.denizen_names_container.add_child(denizen_data_display, true)

				denizen_data_display.denizen_name_label.text = child.denizen_name
				denizen_data_display.denizen = child

			# Not sure if we care about max occupants? may scrap
			#server_occupants.set_max_occupants(5, denizen_count)

func on_purge_button_pressed(_denizen):
	await get_tree().process_frame
	setup_UI()
