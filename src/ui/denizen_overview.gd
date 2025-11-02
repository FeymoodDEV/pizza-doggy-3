extends VFlowContainer

const DEN_CARD = preload("uid://hulqp3iqhd7a")

func add_card(denizen: Denizen):
	var card = DEN_CARD.instantiate()
	card.denizen = denizen
	add_child(card)
	card.setup()
