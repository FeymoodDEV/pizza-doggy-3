extends Control
class_name TerminalText

# Controls display of text and blinking cursor
# See Chat Controller for overall text choices

# Can use queue_line to safely add any line to the queue to display in terminal

@onready var terminal_text_display: RichTextLabel = %TerminalTextDisplay
@onready var terminal_input: LineEdit = %TerminalInput
@onready var typing_timer: Timer = %TypingTimer

var lines: Array[String] = []
var message_queue: Array[String] = []     # queued messages waiting to display
var is_typing := false                    # prevents overlap
var input_locked := false
const MAX_LINES := 200
const TYPING_SPEED := 0.02
const BLINK_SPEED := 0.5

var cursor_visible := true
var blink_timer := 0.0

func _ready() -> void:
	add_to_group("terminal_text")

	terminal_text_display.clear()
	for i in range(28):
		add_line("")

	terminal_text_display.scroll_active = true
	terminal_text_display.scroll_following = true
	terminal_text_display.bbcode_enabled = true
	typing_timer.one_shot = true

	# restrict input to single digit and allow to change by clicking another number without selecting all
	terminal_input.text_changed.connect(on_text_changed)
	terminal_input.max_length = 2
	terminal_input.keep_editing_on_text_submit = true

	# Boot sequence queued instead of awaited
	queue_line("> SYSTEM BOOTING...")
	queue_line("> CONNECTION ESTABLISHED.")
	queue_line("> WELCOME, ADMINISTRATOR.")


func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer > BLINK_SPEED:
		blink_timer = 0
		cursor_visible = !cursor_visible
		_update_display()

	# Process queued lines only if not already typing
	if not is_typing and message_queue.size() > 0:
		var next_line = message_queue.pop_front()
		is_typing = true
		input_locked = true
		await type_line(next_line)
		is_typing = false
		input_locked = false



func on_text_changed(new_text: String) -> void:
	var filtered := ""
	for c in new_text:
		if c.is_valid_int():
			filtered = c  # keep only the most recent valid number

	terminal_input.text = filtered
	terminal_input.caret_column = filtered.length()



func add_line(disp_text: String) -> void:
	lines.append(disp_text)
	if lines.size() > MAX_LINES:
		lines.pop_front()
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


# Public entry point — safe to call anytime
func queue_line(text: String) -> void:
	message_queue.append(text)

func clear_queue() -> void:
	message_queue.clear()
	is_typing = false
	input_locked = false


# Internal typewriter
func type_line(line: String) -> void:
	var output := ""
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

	add_line("") # newline
