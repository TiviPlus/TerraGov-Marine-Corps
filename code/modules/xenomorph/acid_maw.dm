/// non-singleton ammo datum for maw launches. One is created every time the maw fires for every fire.
/datum/maw_ammo
	var/name = "generic maw ammo"
	var/radial_icon_state = "acid_smoke" //  askgregorforhugger?
	var/cooldown_time = 1
	///NEVER SET THIS BELOW 2 SECONDS
	var/impact_time = 3 SECONDS

///called when the maw fires its payload
/datum/maw_ammo/proc/launch_animation(turf/target, obj/structure/xeno/acid_maw/maw)
	CRASH("UNIMPLEMENTED MAW OR CALLED PARENT")

///called 2 seconds before impact
/datum/maw_ammo/proc/impact_visuals(turf/target)
	return

///actual impact effects after the impact visuals
/datum/maw_ammo/proc/on_impact(turf/target)
	CRASH("UNIMPLEMENTED MAW OR CALLED PARENT")

/datum/maw_ammo/smoke
	///radius of the smoke we deploy
	var/smokeradius = 4
	///The duration of the smoke in 2 second ticks
	var/duration = 5
	///datum typepath for the smoke we wanna use
	var/smoke_type = /datum/effect_system/smoke_spread/bad

/datum/maw_ammo/smoke/on_impact(turf/target)
	var/datum/effect_system/smoke_spread/smoke = new smoke_type
	smoke.set_up(smokeradius, target, smoke_duration)
	smoke.start()

/datum/maw_ammo/smoke/neuro
	radial_icon_state = "smoke_mortar"
	smoke_type = /datum/effect_system/smoke_spread/xeno/neuro

/datum/maw_ammo/smoke/acid_big
	cooldown_time = 10 MINUTES
	radial_icon_state = "acid_smoke_mortar"
	smoke_type = /datum/effect_system/smoke_spread/xeno/acid
	smokeradius = 10
	duration = 10

/datum/maw_ammo/hugger
	radial_icon_state = "cas_laser"
	var/drop_range = 8
	var/hugger_count = 30
	var/list/hugger_options = list(
		/obj/item/clothing/mask/facehugger,
		/obj/item/clothing/mask/facehugger/combat/slash,
		/obj/item/clothing/mask/facehugger/combat/acid,
		/obj/item/clothing/mask/facehugger/combat/resin,
	)
	var/list/spawned_huggers = list()

/datum/maw_ammo/hugger/impact_visuals(turf/target)
	var/list/turf/turfs = RANGE_TURFS(drop_range, target)
	while(length(turfs) && hugger_count) // does not double stackhuggers: if 5 tiles free 5 huggers spawn
		var/turf/candidate = pick_n_take(turfs)
		if(candidate.density)
			continue
		var/hugger_type = pick(hugger_options)
		var/obj/item/clothing/mask/facehugger/paratrooper = new hugger_type(candidate)
		paratrooper.go_idle()
		spawned_huggers += paratrooper
		CHECK_TICK // not in a hurry, we have 2 sec after all :)

/datum/maw_ammo/hugger/on_impact(turf/target)
	for(var/obj/item/clothing/mask/facehugger/paratrooper AS in spawned_huggers)
		paratrooper.go_active()

/datum/maw_ammo/xeno_fire
	name = "plasma fire"
	radial_icon_state = "incendiary_mortar"

/obj/effect/temp_visual/fireball
	icon = 'icons/obj/items/projectiles.dmi'
	icon_state = "xeno_fireball"
	duration = 4 SECONDS

/datum/maw_ammo/xeno_fire/launch_animation(turf/target, obj/structure/xeno/acid_maw/maw)
	var/obj/effect/temp_visual/fireball/fireball = new
	maw.vis_contents += fireball
	animate(fireball, fireball.duration, easing=EASE_IN|CUBIC_EASING, pixel_y=600)
	animate(icon=null)

/datum/maw_ammo/xeno_fire/impact_visuals(turf/target)
	var/obj/effect/temp_visual/fireball/fireball = new(target)
	fireball.pixel_y = 600
	animate(fireball, 2 SECONDS, pixel_y=0)
	animate(icon=null)

/datum/maw_ammo/xeno_fire/on_impact(turf/target)
	for(var/turf/affecting AS in RANGE_TURFS(4, target))
		new /obj/fire/melting_fire(affecting)
		for(var/mob/living/carbon/fired in affecting)
			fired.take_overall_damage(PYROGEN_FIREBALL_AOE_DAMAGE, BURN, FIRE, FALSE, FALSE, TRUE, 0, , max_limbs = 2)



/obj/structure/xeno/acid_maw
	name = "acid maw"
	desc = "A deep hole in the ground. it's walls are coated with resin and you see the occasional vent or fang."
	icon = 'icons/Xeno/3x3building.dmi'
	icon_state = "maw"
	bound_width = 96
	bound_height = 64
	max_integrity = 400
	xeno_structure_flags = CRITICAL_STRUCTURE|IGNORE_WEED_REMOVAL
	var/list/maw_options = list(
		/datum/maw_ammo/smoke/acid_big,
	)

/obj/structure/xeno/acid_maw/Initialize(mapload, _hivenumber)
	. = ..()
	SSminimaps.add_marker(src, MINIMAP_FLAG_XENO, image('icons/UI_icons/map_blips.dmi', null, "acid_maw", ABOVE_FLOAT_LAYER))
	var/list/parsed_maw_options = list()
	for(var/datum/maw_ammo/path AS in maw_options)
		parsed_maw_options[path] = image(icon='icons/mob/radial.dmi', icon_state=path::radial_icon_state)
	maw_options = parsed_maw_options

/obj/structure/xeno/acid_maw/attack_alien(mob/living/carbon/xenomorph/xeno_attacker, damage_amount, damage_type, armor_type, effects, armor_penetration, isrightclick)
	. = ..()
	if(xeno_attacker.hivenumber != hivenumber)
		balloon_alert(xeno_attacker, "wrong hive")
		return FALSE
	if(xeno_attacker.hive.living_xeno_ruler != xeno_attacker)
		balloon_alert(xeno_attacker, "must be ruler")
		return FALSE
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_MAW_GLOB)) // repeat this every time after we have a sleep for quick feedback
		var/timeleft = S_TIMER_COOLDOWN_TIMELEFT(src, COOLDOWN_MAW_GLOB)
		balloon_alert(xeno_attacker, "cooldown: [timeleft/10] seconds")
		return FALSE
	var/selected_type = show_radial_menu(xeno_attacker, src, maw_options, require_near=TRUE)
	if(!selected_type)
		return FALSE

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_MAW_GLOB))
		var/timeleft = S_TIMER_COOLDOWN_TIMELEFT(src, COOLDOWN_MAW_GLOB)
		balloon_alert(xeno_attacker, "cooldown: [timeleft/10] seconds")
		return FALSE

	var/datum/maw_ammo/ammo = new selected_type

	var/atom/movable/screen/minimap/map = SSminimaps.fetch_minimap_object(z, MINIMAP_FLAG_XENO)
	xeno_attacker.client.screen += map
	var/list/polled_coords = map.get_coords_from_click(xeno_attacker)
	xeno_attacker?.client?.screen -= map
	if(!polled_coords)
		return

	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_MAW_GLOB))
		var/timeleft = S_TIMER_COOLDOWN_TIMELEFT(src, COOLDOWN_MAW_GLOB)
		balloon_alert(xeno_attacker, "cooldown: [timeleft/10] seconds")
		return FALSE

	var/turf/clicked_turf = locate(polled_coords[1], polled_coords[2], z)
	addtimer(CALLBACK(src, PROC_REF(maw_impact_start), ammo, clicked_turf, xeno_attacker), ammo.impact_time-2 SECONDS)
	ammo.launch_animation(clicked_turf, src)
	S_TIMER_COOLDOWN_START(src, COOLDOWN_MAW_GLOB, ammo.cooldown_time)

/obj/structure/xeno/acid_maw/proc/maw_impact_start(datum/maw_ammo/ammo, turf/target, mob/living/user)
	addtimer(CALLBACK(src, PROC_REF(maw_impact), ammo, target, user), 2 SECONDS)
	ammo.impact_visuals(target)
	user.reset_perspective(target)

/obj/structure/xeno/acid_maw/proc/maw_impact(datum/maw_ammo/ammo, turf/target, mob/living/user)
	ammo.on_impact(target)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, reset_perspective)), 1 SECONDS)

/obj/structure/xeno/acid_maw/acid_jaws
	name = "acid jaws"
	desc = "A hole in the ground. It's walls are coated with resin and there is some smoke billowing out."
	icon = 'icons/Xeno/2x2building.dmi'
	icon_state = "jaws"
	maw_options = list(
		/datum/maw_ammo/smoke/neuro,
		/datum/maw_ammo/hugger,
		/datum/maw_ammo/xeno_fire,
	)
