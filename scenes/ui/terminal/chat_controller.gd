extends Node
class_name ChatController

signal option_chosen(option: int)

var terminal
var terminal_input

var current_denizen: Denizen
var awaiting_input := false

func _ready() -> void:
	terminal = get_tree().get_first_node_in_group("terminal_text")
	terminal_input = terminal.terminal_input
	terminal_input.visible = false
	terminal_input.connect("text_submitted", Callable(self, "_on_text_submitted"))
	SignalBus.start_chat.connect(on_start_chat)


func on_start_chat(denizen: Denizen) -> void:
	current_denizen = denizen
	await play_intro()
	await show_chat_options()

func play_intro() -> void:
	await terminal.type_line("> SUBJECT: " + current_denizen.denizen_name)
	await terminal.type_line("> STATUS: " + str(current_denizen.describe_mood()))

func show_chat_options() -> void:
	await terminal.type_line("> Ask about")
	await terminal.type_line("> [1] origin")
	await terminal.type_line("> [2] last seen event")
	await terminal.type_line("> [3] mood")
	terminal_input.visible = true
	terminal_input.grab_focus()
	var option := await wait_for_input()

	match option:
		1:
			await terminal.type_line("> You: Where did you come from?")
			await terminal.type_line("> " + current_denizen.denizen_name + ": " + current_denizen.start_chat_response())
		2:
			await terminal.type_line("> You: What did you last witness?")
			await terminal.type_line("> " + current_denizen.denizen_name + ": " + current_denizen.describe_last_event())
		3:
			await terminal.type_line("> You: How are you feeling?")
			await terminal.type_line("> " + current_denizen.denizen_name + ": " + current_denizen.describe_mood())
		_:
			await terminal.type_line("> Invalid selection.")
			await show_chat_options()  # re-ask
	await show_chat_options()

func wait_for_input() -> int:
	awaiting_input = true
	var user_choice: int = await self.option_chosen
	awaiting_input = false
	terminal_input.visible = false
	return user_choice

func _on_text_submitted(text: String) -> void:
	if not awaiting_input:
		return
	terminal_input.text = ""
	var choice := int(text) if text.is_valid_int() else 0
	option_chosen.emit(choice)
