/obj/vehicle/xeno
	name = "you shouldnt see this"
	icon = 'icons/obj/xeno_vehicles.dmi'
	vehicle_flags = NONE
	deconstruct_results = list(
		/obj/effect/spawner/gibspawner/xeno,
		/obj/effect/decal/cleanable/blood/xeno
	)
	move_delay = 1.2
	max_integrity = 100
	destroy_descriptor = "grotesquely bulges and bursts!"

/obj/vehicle/xeno/roller
	name = "roller"
	desc = "fuk"
	icon_state = "rollerwalking"
	pixel_x = -2
	var/rolling = FALSE
	var/mature = FALSE
	var/hivenum

#define ROLLER_MATURE_TIME 10 SECONDS
#define ROLLER_TYPE_ROLLAT "rollerrollat"
#define ROLLER_TYPE_EXPLODE "rollerexplode"

/obj/vehicle/xeno/roller/Initialize(mapload, hivenumber)
	. = ..()
	hivenum = hivenumber
	addtimer(CALLBACK(src, .proc/mature_roller), ROLLER_MATURE_TIME)

/obj/vehicle/xeno/roller/proc/connect(obj/item/roller_remote/remote)
	RegisterSignal(src, COMSIG_REMOTECONTROL_CHANGED, .proc/on_remote_toggle)

/obj/vehicle/xeno/roller/proc/mature_roller()
	mature = TRUE
	update_icon()

///Called when remote control is taken, plays a neat sound effect aong other things
/obj/vehicle/xeno/roller/proc/on_remote_toggle(datum/source, is_on, mob/user)
	SIGNAL_HANDLER
	if(is_on)
		playsound(src, 'sound/machines/drone/weapons_engaged.ogg', 70)
		RegisterSignal(user, COMSIG_MOB_CLICK_RIGHT, .proc/toggle_rolling)
	else
		playsound(src, 'sound/machines/drone/droneoff.ogg', 70)
		UnregisterSignal(user, COMSIG_MOB_CLICK_RIGHT)

/obj/vehicle/xeno/roller/proc/toggle_rolling()
	SIGNAL_HANDLER
	rolling = !rolling
	icon_state = "rollerrolling"
	if(rolling)
		move_delay *= 1.5
	else
		move_delay /= 1.5
	if(mature)
		SEND_SIGNAL(src, COMSIG_UNMANNED_TURRET_UPDATED, rolling ? ROLLER_TYPE_ROLLAT : ROLLER_TYPE_EXPLODE)

/obj/vehicle/xeno/roller/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(isxeno(user))
		to_chat(user, "The roller is [mature ? "matured" : "still maturing"].")

/obj/vehicle/xeno/roller/update_icon_state()
	if(mature)
		if(rolling)
			icon_state = "rollerrolling"
		else
			icon_state = "rollerwalking"
	else
		if(rolling)
			icon_state = "rollerrolling"
		else
			icon_state = "rollerwalkingthin"

/obj/vehicle/xeno/roller/update_overlays()
	. = ..()
	switch(PERCENT(obj_integrity/max_integrity))
		if(0 to 50)
			if(rolling)
				. += image('icons/obj/xeno_vehicles.dmi', "rollerwoundroll")
			else
				. += image('icons/obj/xeno_vehicles.dmi', "rollerwoundwalk")
		if(51 to 100)
			return

/obj/vehicle/xeno/roller/obj_destruction(damage_amount, damage_type, damage_flag)
	. = ..()
	new /obj/effect/overlay/temp/exploder_death(loc)


/obj/effect/overlay/temp/exploder_death
	icon = 'icons/obj/xeno_vehicles.dmi'
	icon_state = "rollerexplode"
	effect_duration = 21

/obj/effect/overlay/temp/exploder_explode
	icon = 'icons/obj/xeno_vehicles.dmi'
	icon_state = "rollerexplode"
	effect_duration = 13

/obj/item/roller_pod
	name = "roller pod"
	desc = "yucky"
	icon = 'icons/obj/xeno_vehicles.dmi'
	icon_state = "rollerpod"
	var/hivenumber

/obj/item/roller_pod/Initialize(mapload, hivenum)
	. = ..()
	if(!hivenumber)
		hivenumber = hivenum

/obj/item/roller_pod/examine(mob/user)
	. = ..()
	if(isxeno(user))
		to_chat(user, "Tt needs to be planted on weeds to allow us to hatch the roller within.")

/obj/item/roller_pod/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	try_plant(target, user)

/obj/item/roller_pod/proc/try_plant(atom/target, mob/living/carbon/xenomorph/user)
	if(!isxeno(user))
		return
	var/turf/T = get_turf(src)
	if(!T.check_alien_construction(user))
		return
	if(!user.check_plasma(30))
		return
	if(!(locate(/obj/effect/alien/weeds) in T))
		to_chat(user, "<span class='xenowarning'>[src] can only be planted on weeds.</span>")
		return
	user.visible_message("<span class='xenonotice'>[user] starts planting [src].</span>", \
					"<span class='xenonotice'>We start planting [src].</span>", null, 5)
	var/plant_time = 3.5 SECONDS
	if(!isxenodrone(user))
		plant_time = 2.5 SECONDS
	if(!do_after(user, plant_time, TRUE, T, BUSY_ICON_BUILD, extra_checks = CALLBACK(T, /turf/proc/check_alien_construction, user)))
		return
	if(!user.check_plasma(30))
		return
	if(!locate(/obj/effect/alien/weeds) in T)
		return
	user.use_plasma(30)
	new /obj/effect/alien/roller_pod(T, user.hivenumber)
	playsound(T, 'sound/effects/splat.ogg', 15, 1)
	qdel(src)

/obj/item/roller_pod/attack_self(mob/user)
	try_plant(get_turf(user), user)

/obj/effect/alien/roller_pod
	name = "roller pod"
	desc = "stinky"
	icon = 'icons/obj/xeno_vehicles.dmi'
	icon_state = "rollerpod"
	var/used = FALSE
	var/hivenumber

/obj/effect/alien/roller_pod/Initialize(mapload, hivenum)
	. = ..()
	if(!hivenumber)
		hivenumber = hivenum

/obj/effect/alien/roller_pod/attack_alien(mob/living/carbon/xenomorph/X, damage_amount = X.xeno_caste.melee_damage, damage_type = BRUTE, damage_flag = "", effects = TRUE, armor_penetration = 0, isrightclick = FALSE)
	if(used)
		to_chat(X, erp)
		return
	if(!issamexenohive(X))
		return
	used = TRUE
	to_chat(X, erp)
	var/obj/vehicle/xeno/roller/rolly = new(loc, hivenumber)
	var/obj/item/roller_remote/remote = new(loc, rolly)
	rolly.connect(remote)
	//effects

/obj/item/roller_remote
	name = "chitin psychic interface"
	desc = "reg"
	icon = 'icons/unused/Marine_Research.dmi'
	icon_state = "chitin-armor"

/obj/item/roller_remote/Initialize(mapload, obj/vehicle/xeno/roller/rolly)
	. = ..()
	if(!rolly)
		return
	AddComponent(/datum/component/remote_control, rolly, ROLLER_TYPE_ROLLAT)
	RegisterSignal(rolly, COMSIG_PARENT_QDELETING, .proc/on_roller_del)

/obj/item/roller_remote/proc/on_roller_del(datum/source)
	SIGNAL_HANDLER //FIX ME
	visible_message("The [src] crumbles away!")
	qdel(src)

/obj/item/roller_remote/attack_self(mob/user)
	if(SEND_SIGNAL(src, COMSIG_REMOTECONTROL_TOGGLE, user))
		return
	return ..()

/obj/item/roller_remote/attack_alien(mob/living/carbon/xenomorph/X, damage_amount = X.xeno_caste.melee_damage, damage_type = BRUTE, damage_flag = "", effects = TRUE, armor_penetration = 0, isrightclick = FALSE)
	return attack_hand(X)
