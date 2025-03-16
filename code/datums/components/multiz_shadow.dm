/datum/component/multiz_shadow
	///shadow that we relay our appearance to
	var/obj/effect/abstract/shadow_relay/relay

/datum/component/multiz_shadow/Initialize()
	. = ..()
	if(!ismovable(parent)) // no turfs cus their viscontents behaves different. change if you need it
		return COMPONENT_INCOMPATIBLE
	relay = new(null, parent)
	update_shadow_z()

/datum/component/multiz_shadow/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(update_shadow_z))

/datum/component/multiz_shadow/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED)

/datum/component/multiz_shadow/proc/update_shadow_z()
	SIGNAL_HANDLER
	var/turf/lowest = get_lowest_turf(get_turf(parent))
	start_tracking(lowest)
/*
/datum/component/multiz_shadow/proc/update_shadow_z()
	SIGNAL_HANDLER
	if(!length(SSmapping.get_connected_levels()))
		stop_tracking()
		return
	var/turf/floor = get_turf(parent)
	var/turf/lowest = get_lowest_turf(floor)
	if(floor == lowest)
		stop_tracking()
		return
	start_tracking(lowest)
*/

/// starts relaying the parent down to the relay loc. we pass the relay loc in cus we just had to check it anyway
/datum/component/multiz_shadow/proc/start_tracking(turf/relay_loc)
	// your moved() code bores me
	// we really dont care about do any moving, or movement related shit
	// we are a fake entity and just want to relay
	relay.loc = relay_loc
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_move))

///stop tracking and hide the relay
/datum/component/multiz_shadow/proc/stop_tracking()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	relay.moveToNullspace()

/datum/component/multiz_shadow/proc/on_parent_move(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(isturf(mover.loc))
		//relay.glide_size = mover.glide_size
		relay.loc = get_lowest_turf(mover.loc)
	else
		relay.moveToNullspace()

/obj/effect/abstract/shadow_relay
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = ABOVE_LIGHTING_PLANE
	appearance_flags = KEEP_TOGETHER|NO_CLIENT_COLOR

/obj/effect/abstract/shadow_relay/Initialize(mapload, atom/movable/mirroring)
	. = ..()
	// todo do we use viscontents or hook onto updates
	//RegisterSignals(mirroring, list(COMSIG_ATOM_UPDATE_ICON, COMSIG_XENOMORPH_UPDATE_ICONS,))
	vis_contents += mirroring
