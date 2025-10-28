extends DenController

const INTERACTION_TIMER_MINIMUM_DURATION : float = 5.0
const INTERACTION_TIMER_MAXIMUM_DURATION : float = 20.0
const MOVE_CHANCE : float = 0.2

@onready var timer = randf_range(INTERACTION_TIMER_MINIMUM_DURATION, INTERACTION_TIMER_MAXIMUM_DURATION)

func _process(delta: float) -> void:
	if enabled:
		timer -= delta
		if timer <= 0:
			print("%s doing stuff" % target.denizen_name)
			if randf() <= MOVE_CHANCE:
				target.requesting_random_interaction.emit()
				print("%s requesting random interaction" % target.denizen_name)
			else:
				target.requesting_random_move.emit()
				print("%s requesting random move" % target.denizen_name)
			timer = randf_range(INTERACTION_TIMER_MINIMUM_DURATION, INTERACTION_TIMER_MAXIMUM_DURATION)
