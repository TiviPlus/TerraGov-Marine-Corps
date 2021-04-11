//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define DIRECT_INPUT(A, B) A >> B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define READ_FILE(file, text) DIRECT_INPUT(file, text)
//This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)
#endif

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#else
#define testing(msg)
#endif

/* Items with private are stripped from public logs. */
/proc/log_admin(text)
	LAZYADD(GLOB.admin_log, "\[[stationTimestamp()]\] ADMIN: [text]")


/proc/log_admin_private(text)
	LAZYADD(GLOB.adminprivate_log, "\[[stationTimestamp()]\] PRIVATE: [text]")


/proc/log_admin_private_asay(text)
	LAZYADD(GLOB.asay_log, "\[[stationTimestamp()]\] ASAY: [text]")


/proc/log_admin_private_msay(text)
	LAZYADD(GLOB.msay_log, "\[[stationTimestamp()]\] MSAY: [text]")


/proc/log_dsay(text)
	LAZYADD(GLOB.admin_log, "\[[stationTimestamp()]\] DSAY: [text]")



/* All other items are public. */
/proc/log_game(text)
	LAZYADD(GLOB.game_log, "\[[stationTimestamp()]\] GAME: [text]")


/proc/log_access(text)
	LAZYADD(GLOB.access_log, "\[[stationTimestamp()]\] ACCESS: [text]")


/proc/log_asset(text)
	WRITE_LOG(GLOB.world_asset_log, "ASSET: [text]")

/proc/log_attack(text)
	LAZYADD(GLOB.attack_log, "\[[stationTimestamp()]\] ATTACK: [text]")


/proc/log_ffattack(text)
	LAZYADD(GLOB.ffattack_log, "\[[stationTimestamp()]\] FFATTACK: [text]")


/proc/log_explosion(text)
	LAZYADD(GLOB.explosion_log, "\[[stationTimestamp()]\] EXPLOSION: [text]")


/proc/log_manifest(text)
	LAZYADD(GLOB.manifest_log, "\[[stationTimestamp()]\] MANIFEST: [text]")


/proc/log_say(text)
	LAZYADD(GLOB.say_log, "\[[stationTimestamp()]\] SAY: [text]")


/proc/log_telecomms(text)
	LAZYADD(GLOB.telecomms_log, "\[[stationTimestamp()]\] TCOMMS: [text]")


/proc/log_ooc(text)
	LAZYADD(GLOB.say_log, "\[[stationTimestamp()]\] OOC: [text]")


/proc/log_looc(text)
	LAZYADD(GLOB.say_log, "\[[stationTimestamp()]\] LOOC: [text]")

/proc/log_hivemind(text)
	LAZYADD(GLOB.telecomms_log, "\[[stationTimestamp()]\] HIVEMIND: [text]")

/proc/log_whisper(text)
	LAZYADD(GLOB.say_log, "\[[stationTimestamp()]\] WHISPER: [text]")


/proc/log_emote(text)
	LAZYADD(GLOB.say_log, "\[[stationTimestamp()]\] EMOTE: [text]")

/proc/log_prayer(text)
	LAZYADD(GLOB.game_log, "\[[stationTimestamp()]\] PRAY: [text]")

/proc/log_vote(text)
	LAZYADD(GLOB.game_log, "\[[stationTimestamp()]\] VOTE: [text]")


/proc/log_topic(text)
	WRITE_LOG(GLOB.world_game_log, "TOPIC: [text]")


/proc/log_href(text)


/proc/log_sql(text)
	WRITE_LOG(GLOB.sql_error_log, "SQL: [text]")


/proc/log_qdel(text)
	WRITE_LOG(GLOB.world_qdel_log, "QDEL: [text]")


/* Log to both DD and the logfile. */
/proc/log_world(text)
	WRITE_LOG(GLOB.world_runtime_log, text)
	SEND_TEXT(world.log, text)


/proc/log_debug(text)
	WRITE_LOG(GLOB.world_debug_log, "DEBUG: [text]")

/* Log to the logfile only. */
/proc/log_runtime(text)
	WRITE_LOG(GLOB.world_runtime_log, text)


/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)


/proc/log_paper(text)
	WRITE_LOG(GLOB.world_paper_log, "PAPER: [text]")

/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window?.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	WRITE_LOG(GLOB.tgui_log, entry)

/* For logging round startup. */
/proc/start_log(log)
	WRITE_LOG(log, "Starting up round ID [GLOB.round_id].\n-------------------------")


/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	rustg_log_close_all()


/* Helper procs for building detailed log lines */
/proc/key_name(whom, include_link = null, include_name = TRUE)
	var/mob/M
	var/client/C
	var/key
	var/ckey
	var/fallback_name

	if(!whom)
		return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		C = GLOB.directory[ckey]
		if(C)
			M = C.mob
	else if(istype(whom,/datum/mind))
		var/datum/mind/mind = whom
		key = mind.key
		ckey = ckey(key)
		if(mind.current)
			M = mind.current
			if(M.client)
				C = M.client
		else
			fallback_name = mind.name
	else // Catch-all cases if none of the types above match
		var/swhom = null

		if(istype(whom, /atom))
			var/atom/A = whom
			swhom = "[A.name]"
		else if(istype(whom, /datum))
			swhom = "[whom]"

		if(!swhom)
			swhom = "*invalid*"

		return "\[[swhom]\]"

	. = ""

	if(!ckey)
		include_link = FALSE

	if(key)
		if(C?.holder?.fakekey && !include_name)
			if(include_link)
				. += "<a href='?priv_msg=[C.find_stealth_key()]'>"
			. += "Administrator"
		else
			if(include_link)
				. += "<a href='?priv_msg=[ckey]'>"
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	if(include_name)
		if(M)
			if(M.real_name)
				. += "/([M.real_name])"
			else if(M.name)
				. += "/([M.name])"
		else if(fallback_name)
			. += "/([fallback_name])"


/proc/key_name_admin(whom, include_name = TRUE)
	return key_name(whom, TRUE, include_name)


/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if(!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([AREACOORD(T)])"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"
