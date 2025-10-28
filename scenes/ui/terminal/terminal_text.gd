extends Control
class_name TerminalText

# Controls display of text and blinking cursor
# See Chat Controller for overall text choices

# Type Line displays a slowly typed line.

@onready var terminal_text_display: RichTextLabel = %TerminalTextDisplay
@onready var terminal_input: LineEdit = %TerminalInput
@onready var typing_timer: Timer = %TypingTimer


var lines: Array[String] = []
const MAX_LINES := 200
const TYPING_SPEED := 0.02 # seconds per character

var cursor_visible := true
var blink_timer := 0.0
const BLINK_SPEED := 0.5

var bottom_line := 28

func _ready() -> void:
	add_to_group("terminal_text")

	terminal_text_display.clear()
	for line in bottom_line:
		add_line("")
	terminal_text_display.scroll_active = true
	terminal_text_display.scroll_following = true
	terminal_text_display.bbcode_enabled = true
	terminal_text_display.scroll_to_line(-1)
	typing_timer.one_shot = true


	## Only allow input of numbers, and 1 character at a time
	terminal_input.text_changed.connect(on_text_changed)
	terminal_input.max_length = 1

	# System start
	await type_line("> SYSTEM BOOTING...")
	await type_line("> CONNECTION ESTABLISHED.")
	await type_line("> WELCOME, ADMINISTRATOR.")


## Only numbers
func on_text_changed(new_text: String) -> void:
	var filtered := ""
	for c in new_text:
		if c.is_valid_int(): # keeps only digits 0–9
			filtered += c
	terminal_input.text = filtered
	terminal_input.caret_column = filtered.length() # keeps caret at end


func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer > BLINK_SPEED:
		blink_timer = 0
		cursor_visible = !cursor_visible
		_update_display()

func add_line(disp_text: String) -> void:
	lines.append(disp_text)
	_update_display()

func _update_display() -> void:
	terminal_text_display.clear()
	var cursor_char
	if cursor_visible:
		cursor_char = "_"
	else:
		cursor_char = " "
	terminal_text_display.append_text("\n".join(lines) + cursor_char)
	terminal_text_display.scroll_to_line(terminal_text_display.get_line_count() - 1)

func type_line(line: String) -> void:
	var output = ""
	for c in line:
		output += c
		if lines.is_empty():
			lines.append(output)
		else:
			lines[-1] = output
		terminal_text_display.clear()
		terminal_text_display.append_text("\n".join(lines))
		terminal_text_display.scroll_to_line(terminal_text_display.get_line_count() - 1)
		typing_timer.start(TYPING_SPEED)
		await typing_timer.timeout


	add_line("") # move to next line

func on_start_chat(denizen):
	var chat_response = denizen.start_chat_response()
	type_line(chat_response)
