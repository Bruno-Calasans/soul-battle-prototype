extends CreatureCard
class_name CreatureEffectsManager

@onready var creature: CreatureCard = $"../.."
@onready var active_effects_container: FlowContainer = $ActiveEffectsContainer

var effects: Array[Effect] = []


func show_effect_on_scene(effect: Effect):
	if active_effects_container and active_effects_container.ready:
		active_effects_container.add_child(effect)
		print('Showing effect on scene = ', effect.base_name)


func remove_effect_from_scene(effect: Effect):
	if active_effects_container and active_effects_container.ready:
		active_effects_container.remove_child(effect)
		print('Removing effect from scene = ', effect.base_name)


func can_add_effect(effect: Effect):
	var debuff_immunity: DebuffImmunity = creature.status.debuff_immunity
	return !debuff_immunity.is_immune_to(effect.base_name) and !effect.is_expired()


# Add status effect to effects array
func add_effect(effect: Effect):
	if(can_add_effect(effect)):
		effects.append(effect)
		show_effect_on_scene(effect)
		print('applying ', effect.base_name)
		
	else:
		print('creature is immune to ' + effect.base_name)
	

func remove_effect(effect_name: String):
	effects = effects.filter(func(effect: Effect): 
		effect.remove(self)
		return effect.base_name != effect_name
	)
	
	
func clear_effects():
	for effect in effects:
		effect.remove(creature)
		remove_effect_from_scene(effect)
	effects.clear()


func remove_expired_effects():
	var non_expired_effects: Array[Effect] = []
	for effect in effects:
		if effect.is_expired():
			effect.remove(creature)
			remove_effect_from_scene(effect)
		else:
			non_expired_effects.append(effect)
			
	effects = non_expired_effects


# Apply effects this turn
func apply_effects():
	if len(effects) == 0: return
	
	# apply effectss
	for effect in effects:
		effect.apply(creature)
		effect.decrease_turn()
		print('effect = ', effect.base_name)
		print('effect left turns = ', effect.left_turns)

	# Remove expired effects
	remove_expired_effects()
