extends Node
class_name DuelistSlots

@onready var front_slots_container: BoxContainer = $FrontSlots
@onready var back_slots_container: BoxContainer = $BackSlots


func get_front_slots(only_empty: bool = false) -> Array[CardSlot]:
	var slots: Array[CardSlot] = []
	
	for slot in front_slots_container.get_children() as Array[CardSlot]:
		# get all empty slots
		if only_empty and slot.is_empty():
			slots.append(slot)
			
		# get all slots
		if not only_empty:
			slots.append(slot)
		
	return slots
		

func get_back_slots(only_empty: bool = false) -> Array[CardSlot]:
	var slots: Array[CardSlot] = []
	for slot in back_slots_container.get_children():
		# get all empty slots
		if only_empty and slot.is_empty():
			slots.append(slot)
			
		# get all slots
		if not only_empty:
			slots.append(slot)
	return slots
	

func get_all_summoned_creatures_on_field() -> Array[CreatureCard]:
	var cards: Array[CreatureCard] = []
	for slot in front_slots_container.get_children() as Array[CardSlot]:
		if not slot.is_empty(): cards.append(slot.card_in_slot)
	return cards
