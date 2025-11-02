extends VFlowContainer

const TASK_CARD = preload("uid://cs4g2sfswgycw")

func add_card(task: Timer):
	var card = TASK_CARD.instantiate()
	card.task = task
	add_child(card)
	card.setup()
