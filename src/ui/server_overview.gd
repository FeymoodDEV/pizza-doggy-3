extends VFlowContainer

const SERVER_CARD = preload("uid://x48k1kbnayiq")

func add_card(server: Server):
	var card = SERVER_CARD.instantiate()
	card.server = server
	add_child(card)
	card.setup()
	
