extends HBoxContainer

@onready var denizen_name_label: Label = %DenizenNameLabel
@onready var chat_button: Button = %ChatButton
@onready var purge_button: Button = %PurgeButton

var denizen

func _ready() -> void:
	chat_button.pressed.connect(on_chat_button_pressed)
	purge_button.pressed.connect(on_purge_button_pressed)

func on_chat_button_pressed():
	SignalBus.start_chat.emit(denizen)

func on_purge_button_pressed():
	SignalBus.purge_denizen.emit(denizen)
