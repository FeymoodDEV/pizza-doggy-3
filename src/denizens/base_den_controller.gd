extends DenController

const INTERACTION_TIMER_MINIMUM_DURATION : float = 2.0
const INTERACTION_TIMER_MAXIMUM_DURATION : float = 5.0
const MOVE_CHANCE : float = 0.2

@onready var timer = randf_range(INTERACTION_TIMER_MINIMUM_DURATION, INTERACTION_TIMER_MAXIMUM_DURATION)

func process(delta):
	timer -= delta
	if timer <= 0:
		if randf() <= MOVE_CHANCE:
			target.requesting_random_interaction.emit()
		else:
			target.requesting_random_move.emit()
		timer = randf_range(INTERACTION_TIMER_MINIMUM_DURATION, INTERACTION_TIMER_MAXIMUM_DURATION)
