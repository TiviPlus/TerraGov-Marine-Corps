/**
 * The absolute base class for everything
 *
 * A datum instantiated has no physical world prescence, use an atom if you want something
 * that actually lives in the world
 *
 * Be very mindful about adding variables to this class, they are inherited by every single
 * thing in the entire game, and so you can easily cause memory usage to rise a lot with careless
 * use of variables at this level
 */
/datum
	/**
	  * Tick count time when this object was destroyed.
	  *
	  * If this is non zero then the object has been garbage collected and is awaiting either
	  * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	  */
	var/gc_destroyed

	/// Open uis owned by this datum
	/// Lazy, since this case is semi rare
	var/list/open_uis

	/// Active timers with this datum as the target
	var/list/_active_timers
	/// Status traits attached to this datum. associative list of the form: list(trait name (string) = list(source1, source2, source3,...))
	var/list/_status_traits

	var/hidden_from_codex = FALSE //set to TRUE if you want something to be hidden.
	var/interaction_flags = NONE //Defined at the datum level since some can be interacted with.

	/**
	  * Components attached to this datum
	  *
	  * Lazy associated list in the structure of `type -> component/list of components`
	  */
	var/list/_datum_components
	/**
	  * Any datum registered to receive signals from this datum is in this list
	  *
	  * Lazy associated list in the structure of `signal -> registree/list of registrees`
	  */
	var/list/_listen_lookup
	/// Lazy associated list in the structure of `target -> list(signal -> proctype)` that are run when the datum receives that signal
	var/list/list/_signal_procs

	/// Datum level flags
	var/datum_flags = NONE

	/// A cached version of our \ref
	/// The brunt of \ref costs are in creating entries in the string tree (a tree of immutable strings)
	/// This avoids doing that more then once per datum by ensuring ref strings always have a reference to them after they're first pulled
	var/cached_ref

	/// A weak reference to another datum
	var/datum/weakref/weak_reference
	/**
	 * Lazy associative list of currently active cooldowns.
	 *
	 * cooldowns [ COOLDOWN_INDEX ] = add_timer()
	 * add_timer() returns the truthy value of -1 when not stoppable, and else a truthy numeric index
	 */
	var/list/cooldowns

	/// List for handling persistent filters.
	var/list/datum/filter_data/filter_data

#ifdef DATUMVAR_DEBUGGING_MODE
	var/list/cached_vars
#endif

#ifdef REFERENCE_TRACKING
	var/running_find_references
	var/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
#endif


/**
 * Default implementation of clean-up code.
 *
 * This should be overridden to remove all references pointing to the object being destroyed, if
 * you do override it, make sure to call the parent and return it's return value by default
 *
 * Return an appropriate [QDEL_HINT][QDEL_HINT_QUEUE] to modify handling of your deletion;
 * in most cases this is [QDEL_HINT_QUEUE].
 *
 * The base case is responsible for doing the following
 * * Erasing timers pointing to this datum
 * * Erasing compenents on this datum
 * * Notifying datums listening to signals from this datum that we are going away
 *
 * Returns [QDEL_HINT_QUEUE]
 */
/datum/proc/Destroy(force=FALSE, ...)
	SHOULD_CALL_PARENT(TRUE)
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null	//ensure prompt GCing of weakref.

	cooldowns = null

	var/list/timers = _active_timers
	_active_timers = null
	for(var/datum/timedevent/timer as anything in timers)
		if(timer.spent && !(timer.flags & TIMER_DELETE_ME))
			continue
		qdel(timer)

	#ifdef REFERENCE_TRACKING
	#ifdef REFERENCE_TRACKING_DEBUG
	found_refs = null
	#endif
	#endif

	//BEGIN: ECS SHIT

	var/list/dc = _datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/datum/component/component as anything in all_components)
				qdel(component, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		dc.Cut()

	clear_signal_refs()
	//END: ECS SHIT
	return QDEL_HINT_QUEUE


/datum/proc/clear_signal_refs()
	var/list/lookup = _listen_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/datum/component/comp as anything in comps)
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		_listen_lookup = lookup = null

	for(var/target in _signal_procs)
		UnregisterSignal(target, _signal_procs[target])

/datum/proc/GenerateTag()
	SHOULD_CALL_PARENT(TRUE)
	datum_flags |= DF_USE_TAG

#ifdef DATUMVAR_DEBUGGING_MODE
/datum/proc/save_vars()
	cached_vars = list()
	for(var/i in vars)
		if(i == "cached_vars")
			continue
		cached_vars[i] = vars[i]

/datum/proc/check_changed_vars()
	. = list()
	for(var/i in vars)
		if(i == "cached_vars")
			continue
		if(cached_vars[i] != vars[i])
			.[i] = list(cached_vars[i], vars[i])

/datum/proc/txt_changed_vars()
	var/list/l = check_changed_vars()
	var/t = "[src]([REF(src)]) changed vars:"
	for(var/i in l)
		t += "\"[i]\" \[[l[i][1]]\] --> \[[l[i][2]]\] "
	t += "."

/datum/proc/to_chat_check_changed_vars(target = world)
	to_chat(target, txt_changed_vars())
#endif

/// Return a list of data which can be used to investigate the datum, also ensure that you set the semver in the options list
/datum/proc/serialize_list(list/options, list/semvers)
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	.["tag"] = tag

	SET_SERIALIZATION_SEMVER(semvers, "1.0.0")
	return .

///Accepts a LIST from deserialize_datum. Should return whether or not the deserialization was successful.
/datum/proc/deserialize_list(json, list/options)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

///Serializes into JSON. Does not encode type.
/datum/proc/serialize_json(list/options)
	. = serialize_list(options)
	if(!islist(.))
		. = null
	else
		. = json_encode(.)

///Deserializes from JSON. Does not parse type.
/datum/proc/deserialize_json(list/input, list/options)
	var/list/jsonlist = json_decode(input)
	. = deserialize_list(jsonlist)
	if(!istype(., /datum))
		. = null

///Convert a datum into a json blob
/proc/json_serialize_datum(datum/D, list/options)
	if(!istype(D))
		return
	var/list/jsonlist = D.serialize_list(options)
	if(islist(jsonlist))
		jsonlist["DATUM_TYPE"] = D.type
	return json_encode(jsonlist)

/// Convert a list of json to datum
/proc/json_deserialize_datum(list/jsonlist, list/options, target_type, strict_target_type = FALSE)
	if(!islist(jsonlist))
		if(!istext(jsonlist))
			CRASH("Invalid JSON")
		jsonlist = json_decode(jsonlist)
		if(!islist(jsonlist))
			CRASH("Invalid JSON")
	if(!jsonlist["DATUM_TYPE"])
		return
	if(!ispath(jsonlist["DATUM_TYPE"]))
		if(!istext(jsonlist["DATUM_TYPE"]))
			return
		jsonlist["DATUM_TYPE"] = text2path(jsonlist["DATUM_TYPE"])
		if(!ispath(jsonlist["DATUM_TYPE"]))
			return
	if(target_type)
		if(!ispath(target_type))
			return
		if(strict_target_type)
			if(target_type != jsonlist["DATUM_TYPE"])
				return
		else if(!ispath(jsonlist["DATUM_TYPE"], target_type))
			return
	var/typeofdatum = jsonlist["DATUM_TYPE"]			//BYOND won't directly read if this is just put in the line below, and will instead runtime because it thinks you're trying to make a new list?
	var/datum/D = new typeofdatum
	var/datum/returned = D.deserialize_list(jsonlist, options)
	if(!istype(returned, /datum))
		qdel(D)
	else
		return returned


/**
 * Called when a href for this datum is clicked
 *
 * Sends a [COMSIG_TOPIC] signal
 */
/datum/Topic(href, list/href_list)
	. = ..()
	if(.)
		return

	if(!can_interact(usr))
		return TRUE

	SEND_SIGNAL(src, COMSIG_TOPIC, usr, href_list)


/datum/proc/can_interact(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	return TRUE


/datum/proc/on_set_interaction(mob/user)
	return


/datum/proc/on_unset_interaction(mob/user)
	return


/datum/proc/check_eye()
	return


/datum/proc/interact(mob/user) //Return value = handled (same as attack_hand)
	user.set_interaction(src)
	if(interaction_flags & INTERACT_UI_INTERACT)
		return ui_interact(user)
	return FALSE


/proc/end_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	TIMER_COOLDOWN_END(source, index)


/datum/filter_data
	///Filter priority used when sorting the filter
	var/priority

	var/draw_original
	///Assoc List of actual arglist arguments to pass to filter()
	var/list/arguments
	/**
	 * Reference to the filter
	 * Keep in mind, dm_filter is snowflake cus lummy loves us
	 * So it runtimes if you access vars on it that it isnt using
	 * oh also type isnt actually the type, its the string of the filter type
	 * Just use the fuckin arguments var man
	 */
	var/dm_filter/filter

/datum/filter_data/New(priority, list/params, draw_original)
	. = ..()
	src.priority = priority
	src.draw_original = draw_original
	arguments = params
	var/atom/renderer = params["render_source"]
	if(renderer)
		renderer.relay_render_to(src, draw_original)

///Called when the sources render_target is updated to sync our filters' render_target
/datum/filter_data/proc/update_render_source()
	//this is only called by managed render source code so assume render_source is accessible
	filter?.render_source = rendering_from?.provider.render_target
	arguments["render_source"] = rendering_from?.provider.render_target

/datum/filter_data/proc/set_render_from(datum/render_relay/new_relay)
	rendering_from = new_relay
	update_render_source()

///returns the original args used when creating this filter, unmodified
/datum/filter_data/proc/get_unmodified_args()
	RETURN_TYPE(/list)
	var/list/changed_args = arguments.Copy()
	if(!changed_args["render_source"])
		return changed_args
	changed_args["render_source"] = rendering_from.provider
	return changed_args

/** Add a filter to the datum.
 * This is on datum level, despite being most commonly / primarily used on atoms, so that filters can be applied to images / mutable appearances.
 * Can also be used to assert a filter's existence. I.E. update a filter regardless if it exists or not.
 *
 * Arguments:
 * * name - Filter name
 * * priority - Priority used when sorting the filter.
 * * params - Parameters of the filter.
 * * update_filters - whether to update filters. should only be used by [/datum/proc/add_filters] to reduce update_filters calls
 * * update_filters - whether to update filters. should only be used by [/datum/proc/add_filters] to reduce update_filters calls
 */
/datum/proc/add_filter(name, priority, list/params, render_source_keep_original = TRUE, update_filters=TRUE)
	if(params["render_source"])
		ASSERT(isatom(params["render_source"]) || isimage(params["render_source"]), "Do not pass non-atom render_sources to add_filter")
	LAZYINITLIST(filter_data)
	if(filter_data[name])
		qdel(filter_data[name])
	var/list/copied_parameters = params.Copy()
	var/datum/filter_data/data = new(priority, copied_parameters, render_source_keep_original)
	filter_data[name] = data
	if(update_filters)
		update_filters()

///A version of add_filter that takes a list of filters to add rather than being individual, to limit calls to update_filters().
/datum/proc/add_filters(list/list/filters)
	LAZYINITLIST(filter_data)
	for(var/list/individual_filter as anything in filters)
		individual_filter["update_filters"] = FALSE
		add_filter(arglist(individual_filter))
	update_filters()

///Sorts our filters by priority and reapplies them
/datum/proc/update_filters()
	ASSERT(isatom(src) || isimage(src))
	var/atom/atom_cast = src // filters only work with images or atoms.
	atom_cast.filters = null
	filter_data = sortTim(filter_data, GLOBAL_PROC_REF(cmp_filter_data_priority), TRUE)
	for(var/f in filter_data)
		var/datum/filter_data/data = filter_data[f]
		var/dm_filter/newfilter = filter(arglist(data.arguments.Copy()))
		data.filter = newfilter
		atom_cast.filters += newfilter

/** Update a filter's parameter to the new one. If the filter doesnt exist we won't do anything.
 *
 * Arguments:
 * * name - Filter name
 * * new_params - New parameters of the filter
 * * overwrite - TRUE means we replace the parameter list completely. FALSE means we only replace the things on new_params.
 */
/datum/proc/modify_filter(name, list/new_params, overwrite = FALSE, keep_render_original = TRUE)
	var/datum/filter_data/data = filter_data[name]
	if(!data)
		return
	if(overwrite)
		data.arguments = new_params
	else
		for(var/thing in new_params)
			data.arguments[thing] = new_params[thing]
	var/atom/renderer = new_params["render_source"]
	if(renderer)
		renderer.relay_render_to(data, keep_render_original)
	update_filters()

/** Update a filter's parameter and animate this change. If the filter doesnt exist we won't do anything.
 * Basically a [datum/proc/modify_filter] call but with animations. Unmodified filter parameters are kept.
 *
 * Arguments:
 * * name - Filter name
 * * new_params - New parameters of the filter
 * * time - time arg of the BYOND animate() proc.
 * * easing - easing arg of the BYOND animate() proc.
 * * loop - loop arg of the BYOND animate() proc.
 */
/datum/proc/transition_filter(name, list/new_params, time, easing, loop)
	var/filter = get_filter(name)
	if(!filter)
		return
	// This can get injected by the filter procs, we want to support them so bye byeeeee
	new_params -= "type"
	//render_source is implicitly set here to an atom if provided but itll get overridden in a sec by modify filter anyway to relay properly
	animate(filter, new_params, time = time, easing = easing, loop = loop)
	modify_filter(name, new_params)

/// Updates the priority of the passed filter key
/datum/proc/change_filter_priority(name, new_priority)
	if(!filter_data || !filter_data[name])
		return
	var/datum/filter_data/data = filter_data[name]
	data.priority = new_priority
	update_filters()

/// Returns the filter associated with the passed key
/datum/proc/get_filter(name)
	ASSERT(isatom(src) || isimage(src))
	if(filter_data && filter_data[name])
		var/datum/filter_data/data = filter_data[name]
		return data.filter

///returns the filter data datum associated with this
/datum/proc/get_filter_data(name)
	ASSERT(isatom(src) || isimage(src))
	if(filter_data && filter_data[name])
		return filter_data[name]

/// Returns the indice in filters of the given filter name.
/// If it is not found, returns null.
/datum/proc/get_filter_index(name)
	return filter_data?.Find(name)

/// Removes the passed filter, or multiple filters, if supplied with a list.
/datum/proc/remove_filter(name_or_names)
	if(!filter_data)
		return

	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			qdel(filter_data[name])
			filter_data -= name
	update_filters()
	UNSETEMPTY(filter_data)

/datum/proc/clear_filters()
	ASSERT(isatom(src) || isimage(src))
	var/atom/atom_cast = src // filters only work with images or atoms.
	for(var/name in filter_data)
		qdel(filter_data[name])
	filter_data = null
	atom_cast.filters = null
