extends MarginContainer

@onready var den_icon: TextureRect = %DenIcon
@onready var den_name: RichTextLabel = %DenName
@onready var den_location: RichTextLabel = %DenLocation

var denizen : Denizen

func setup() -> void:
	den_name.text = denizen.denizen_name
	denizen.status_changed.connect(refresh)
	refresh()

func refresh() -> void:
	#den_icon.texture = something[denizen.mood]
	den_location.text = """IN: %s""" % denizen.get_parent().server_name #AAAAAAAAAAAAAAAA
