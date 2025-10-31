extends Control

@onready var context_menu: PanelContainer = $ContextMenu
@onready var hover_border: Panel = $HoverBorder

var shown : bool = false

func _ready() -> void:
	# hide context menu after any option is selected
	for c in context_menu.get_children().filter(func(x): return x is Button):
		c.connect(hide_context_menu)
	# TODO: generalize

func show_context_menu() -> void:
	context_menu.global_position = get_global_mouse_position()
	context_menu.show()
	context_menu.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
	#context_menu.grab_focus()

func hide_context_menu() -> void:
	context_menu.hide()
	context_menu.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	#context_menu.release_focus()

func _on_mouse_entered() -> void:
	hover_border.show()

func _on_mouse_exited() -> void:
	hover_border.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			show_context_menu()

func _input(event: InputEvent) -> void:
	if context_menu.visible:
		if event is InputEventMouseButton and event.pressed:
			if not context_menu.get_global_rect().has_point(event.position):
				hide_context_menu()
