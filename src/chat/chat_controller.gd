extends Node
class_name ChatController

signal option_chosen(option: int)

var terminal: Control
var terminal_input: LineEdit

var current_denizen: Denizen
var awaiting_input := false
var active_session_id: int = 0  # increments each time a new chat begins

func _ready() -> void:
	terminal = get_tree().get_first_node_in_group("terminal_text")
	terminal_input = terminal.terminal_input
	terminal_input.visible = false
	terminal_input.connect("text_submitted", Callable(self, "_on_text_submitted"))
	SignalBus.start_chat.connect(on_start_chat)
	SignalBus.purge_denizen.connect(on_purge_denizen)

func on_start_chat(denizen: Denizen) -> void:
	active_session_id += 1  # cancel any old coroutines
	current_denizen = denizen
	play_intro()
	show_chat_options(active_session_id)

func play_intro() -> void:
	terminal.queue_line("> SUBJECT: " + current_denizen.denizen_name)
	terminal.queue_line("> STATUS: " + str(current_denizen.describe_mood()))

func show_chat_options(session_id: int) -> void:
	while current_denizen != null and session_id == active_session_id:
		terminal.queue_line("> Ask about")
		terminal.queue_line("> [1] origin")
		terminal.queue_line("> [2] last seen event")
		terminal.queue_line("> [3] mood")

		terminal_input.visible = true
		terminal_input.grab_focus()

		var option := await wait_for_input()
		if session_id != active_session_id:
			return  # chat replaced mid-wait

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


func wait_for_input() -> int:
	awaiting_input = true
	var user_choice: int = await self.option_chosen
	awaiting_input = false
	terminal_input.visible = false
	return user_choice

func _on_text_submitted(text: String) -> void:
	if terminal.is_typing or terminal.input_locked:
		return  # ignore premature or repeated input

	# Reset field
	terminal_input.text = ""

	# Parse choice
	var choice := int(text) if text.is_valid_int() else 0
	option_chosen.emit(choice)
	terminal_input.grab_focus()

func on_purge_denizen(denizen):
	terminal.queue_line("> " + denizen.denizen_name + " has been purged from the system.")
