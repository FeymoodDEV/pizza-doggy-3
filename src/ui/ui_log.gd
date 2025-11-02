extends VBoxContainer

@export var LIMIT_MESSAGE_COUNT : bool = true
@export var MAX_MESSAGE_COUNT := 250

@onready var log_scroll: ScrollContainer = $LogScroll
@onready var log_messages: VBoxContainer = $LogScroll/LogMessages
@onready var send_button: Button = $InputArea/SendButton

@onready var den_dialogue := preload("res://scenes/ui/alt/den_dialogue.tscn")
@onready var standard_message := preload("res://scenes/ui/alt/standard_message.tscn")

func _ready() -> void:
	SignalBus.standard_message.connect(print_message)

## Print dialogue from a denizen or the player, complete with infobox
func print_dialogue(speaker: Denizen, text: String):
	# limit message count
	cull_message_count()
	
	var message := den_dialogue.instantiate()
	
	log_messages.add_child(message)
	
	# TODO: add some for admin
	#message.den_image = ...
	message.den_name.text = speaker.name
	message.message_text.text = text
	
	# TODO: scroll

func print_message(text: String):
	var stick_to_bottom := (log_scroll.scroll_vertical >= log_messages.size.y - log_scroll.size.y)
		
	# limit message count
	cull_message_count()
	
	var message := standard_message.instantiate()
	log_messages.add_child(message)
	message.message.text = text
	
	print("[LOG]" + text)
	print(stick_to_bottom)
	if stick_to_bottom:
		await get_tree().process_frame
		scroll_to_bottom()

func scroll_to_bottom():
	log_scroll.scroll_vertical = log_messages.size.y + 999999

func cull_message_count() -> void:
	if LIMIT_MESSAGE_COUNT and log_messages.get_child_count() >= MAX_MESSAGE_COUNT:
		log_messages.get_child(0).queue_free()
