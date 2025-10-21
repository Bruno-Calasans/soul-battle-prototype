extends VBoxContainer
class_name OpponentSlots

@onready var front_slots_container = $FrontSlots
@onready var back_slots_container = $BackSlots


func get_front_slots(empty: bool = false) -> Array[CardSlot]:
	var slots: Array[CardSlot] = []
	for slot in front_slots_container.get_children() as Array[CardSlot]:
		if empty and not slot.card_in_slot:
			slots.append(slot)
		else:
			slots.append(slot)
	return slots
		

func get_back_slots(empty: bool = false) -> Array[CardSlot]:
	var slots: Array[CardSlot] = []
	for slot in back_slots_container.get_children():
		if empty and not slot.card_in_slot:
			slots.append(slot)
		else:
			slots.append(slot)
	return slots
	
