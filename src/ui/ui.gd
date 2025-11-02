extends Control

@onready var denizen_overview: VFlowContainer = %DenizenOverview
@onready var server_overview: VFlowContainer = %ServerOverview
@onready var drone_controls: HBoxContainer = %DroneControls
@onready var task_overview: VFlowContainer = %TaskOverview
@onready var text_log: VBoxContainer = %TextLog
@onready var input_area: HBoxContainer = %InputArea

## Initial UI setup. 
func setup(servers: Array[Server]) -> void:
	for server in servers:
		server_overview.add_card(server)
		for denizen in server.get_children().filter(func(x): return x is Denizen):
			var den_card = denizen_overview.add_card(denizen)
