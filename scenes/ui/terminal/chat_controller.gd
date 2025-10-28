extends Node
class_name ChatController

signal option_chosen(option: int)

var terminal
var terminal_input

var current_denizen: Denizen
var ng_input := false

func _ready() -> void:
	terminal = get_tree().get_first_node_in_group("terminal_text")
	terminal_input = terminal.terminal_input
	terminal_input.visible = false
	terminal_input.connect("text_submitted", Callable(self, "_on_text_submitted"))
	SignalBus.start_chat.connect(on_start_chat)
	SignalBus.purge_denizen.connect(on_purge_denizen)

func on_start_chat(denizen: Denizen) -> void:
	current_denizen = denizen
	play_intro()
	show_chat_options()

func play_intro() -> void:
	terminal.queue_line("> SUBJECT: " + current_denizen.denizen_name)
	terminal.queue_line("> STATUS: " + str(current_denizen.describe_mood()))

func show_chat_options() -> void:
	terminal.queue_line("> Ask about")
	terminal.queue_line("> [1] origin")
	terminal.queue_line("> [2] last seen event")
	terminal.queue_line("> [3] mood")
	# Add unique denizen options here?
	# ~ if denizen.has_flag("experienced break in reality") ~
	# ~ "> [4] glitches" ~
	terminal_input.visible = true
	terminal_input.grab_focus()
	var option := await wait_for_input()

	match option:
		1:
			terminal.queue_line("> You: Where did you come from?")
			terminal.queue_line("> " + current_denizen.denizen_name + ": " + current_denizen.start_chat_response())
		2:
			terminal.queue_line("> You: What did you last witness?")
			terminal.queue_line("> " + current_denizen.denizen_name + ": " + current_denizen.describe_last_event())
		3:
			terminal.queue_line("> You: How are you feeling?")
			terminal.queue_line("> " + current_denizen.denizen_name + ": " + current_denizen.describe_mood())
		_:
			terminal.queue_line("> Invalid selection.")
			show_chat_options()  # re-ask
	show_chat_options()

func wait_for_input() -> int:
	ng_input = true
	var user_choice: int = await self.option_chosen
	ng_input = false
	terminal_input.visible = false
	return user_choice

func _on_text_submitted(text: String) -> void:
	if not ng_input:
		return
	terminal_input.text = ""
	var choice := int(text) if text.is_valid_int() else 0
	option_chosen.emit(choice)

func on_purge_denizen(denizen):
	terminal.queue_line("> " + denizen.denizen_name + " has been purged from the system.")
