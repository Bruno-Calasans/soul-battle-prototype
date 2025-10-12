extends CreatureCard
class_name CreatureEffectsManager

var effects: Array[Effect] = []


func can_add_effect(effect: Effect):
	var debuff_immunity: DebuffImmunity = get_parent().status.debuff_immunity
	return !debuff_immunity.is_immune_to(effect.base_name) and !effect.is_expired()


# Add status effect to effects array
func add_effect(effect: Effect):
	if(can_add_effect(effect)):
		effects.append(effect)
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
		effect.remove(self)
	effects.clear()


func remove_expired_effects():
	var non_expired_effects: Array[Effect] = []
	for effect in effects:
		if effect.is_expired():
			effect.remove(get_parent())
		else:
			non_expired_effects.append(effect)
			
	effects = non_expired_effects

# Apply effects this turn
func apply_effects():
	print('Runnning effects...' + str(effects))
	
	if len(effects) == 0: return
	
	# apply effectss
	for effect in effects:
		effect.apply(get_parent())
		effect.decrease_turn()
		print('effect = ', effect.base_name)
		print('effect left turns = ', effect.left_turns)

	# Remove expired effects
	remove_expired_effects()
