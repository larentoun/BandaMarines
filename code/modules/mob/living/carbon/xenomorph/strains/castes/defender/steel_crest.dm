/datum/xeno_strain/steel_crest
	name = DEFENDER_STEELCREST
	description = "Вы обмениваете размах хвостом и немного урона от когтей на немного увеличенные отталкивание и урон гребнем, а также возможность передвигаться и ударять гребнем в укреплении. Вы получите способность накапливать урон, чтобы излечить себя на небольшое количество здоровья и восстановить перезарядку удара хвостом."
	flavor_description = "Она, как и моя воля, несгибаема. Она станет моим стальным гребнем против тех, кто осмеливается бросить мне вызов."
	icon_state_prefix = "Steelcrest"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/headbutt/steel_crest,
		/datum/action/xeno_action/onclick/soak,
		/datum/action/xeno_action/activable/fortify/steel_crest,
	)

/datum/xeno_strain/steel_crest/apply_strain(mob/living/carbon/xenomorph/defender/defender)
	defender.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	if(defender.fortify)
		defender.ability_speed_modifier += 2.5
	defender.recalculate_stats()
