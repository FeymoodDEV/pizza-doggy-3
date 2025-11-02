extends MarginContainer

@onready var server_icon: TextureRect = %ServerIcon
@onready var server_name: RichTextLabel = %ServerName
@onready var server_info: RichTextLabel = %ServerInfo

var server : Server

func setup() -> void:
	server_name.text = server.server_name
	server.status_changed.connect(refresh)
	refresh()

func refresh() -> void:
	#server_icon.texture = something[integrity]
	server_info.text = """INTEGRITY: %.1f%%
	RAM: %s
	CPU: %s
	""" % [
		server.integrity / server.MAX_INTEGRITY * 100,
		"UNIMPLEMENTED",
		"UNIMPLEMENTED",
	]
