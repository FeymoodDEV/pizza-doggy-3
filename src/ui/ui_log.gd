extends VBoxContainer
class_name UiLog

@export var LIMIT_MESSAGE_COUNT : bool = true
@export var MAX_MESSAGE_COUNT := 250

@onready var log_messages: VBoxContainer = $LogScroll/LogMessages
@onready var send_button: Button = $InputArea/SendButton

@onready var den_dialogue := preload("res://scenes/ui/alt/den_dialogue.tscn")
#@onready var standard_message := preload("")

## Print dialogue from a denizen or the player, complete with infobox
func print_dialogue(speaker: Denizen, text: String):
	# limit message count
	if LIMIT_MESSAGE_COUNT and log_messages.get_child_count() >= MAX_MESSAGE_COUNT:
		log_messages.get_child(0).queue_free()
	
	var message := den_dialogue.instantiate()
	# TODO: add some for admin
	
	#message.den_image = ...
	message.den_name = speaker.name
	message.message_text = text
	
	log_messages.add_child(message)
	# TODO: scroll

func print_message(text: String):
	pass
