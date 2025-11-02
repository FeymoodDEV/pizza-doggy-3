extends MarginContainer

# Icon should change based on task type
@onready var drone_icon: TextureRect = %DroneIcon
@onready var task_title: RichTextLabel = %TaskTitle
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var task_info: RichTextLabel = %TaskInfo


var task : Timer

func setup(title: String, type) -> void:
	task_title.text = task.title
	task_info.text = "TODO"
	progress_bar.max_value = task.time_left

func refresh() -> void:
	progress_bar.value = progress_bar.max_value - task.time_left
