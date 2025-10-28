extends RichTextLabel

@onready var typing_timer: Timer = $TypingTimer

var lines: Array[String] = []
const MAX_LINES := 200
const TYPING_SPEED := 0.02 # seconds per character

var bottom_line := 28

func _ready() -> void:
	clear()
	for line in bottom_line:
		add_line("")
	scroll_active = true
	scroll_following = true
	bbcode_enabled = true
	scroll_to_line(-1)
	typing_timer.one_shot = true

	# System start
	await type_line("> SYSTEM BOOTING...")
	await type_line("> CONNECTION ESTABLISHED.")
	await type_line("> WELCOME, ADMINISTRATOR.")


func add_line(disp_text: String) -> void:
	lines.append(disp_text)
	if lines.size() > MAX_LINES:
		lines.pop_front()

	clear()
	append_text("\n".join(lines))
	scroll_to_line(get_line_count() - 1)


func type_line(line: String) -> void:
	var output = ""
	for c in line:
		output += c
		if lines.is_empty():
			lines.append(output)
		else:
			lines[-1] = output
		clear()
		append_text("\n".join(lines))
		scroll_to_line(get_line_count() - 1)
		await typing_timer.timeout
		typing_timer.start(TYPING_SPEED)

	add_line("") # move to next line
