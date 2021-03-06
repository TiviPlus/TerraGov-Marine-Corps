


//marine gloves

/obj/item/clothing/gloves/marine
	name = "marine combat gloves"
	desc = "Standard issue marine tactical gloves. It reads: 'knit by Marine Widows Association'."
	icon_state = "gloves_marine"
	item_state = "gloves_marine"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	flags_cold_protection = HANDS
	flags_heat_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	flags_armor_protection = HANDS
	var/flags_marine_gloves = GLOVES_SQUAD_OVERLAY
	armor = list("melee" = 15, "bullet" = 20, "laser" = 15, "energy" = 20, "bomb" = 20, "bio" = 10, "rad" = 10, "fire" = 20, "acid" = 20)

/obj/item/clothing/gloves/marine/Initialize(mapload, squad, rank)
	. = ..()
	if(squad)
		var/dat = ""
		if(rank == SQUAD_ENGINEER)
			dat += "insulated "
			siemens_coefficient = 0
			desc = "Insulated marine tactical gloves that protect against electrical shocks."
		name = dat + "marine combat gloves"

/obj/item/clothing/gloves/marine/officer
	name = "officer gloves"
	desc = "Shiny and impressive. They look expensive."
	icon_state = "black"
	item_state = "bgloves"

/obj/item/clothing/gloves/marine/officer/chief
	name = "chief officer gloves"
	desc = "Blood crusts are attached to its metal studs, which are slightly dented."

/obj/item/clothing/gloves/marine/officer/chief/sa
	name = "spatial agent's gloves"
	desc = "Gloves worn by a Spatial Agent."
	siemens_coefficient = 0
	permeability_coefficient = 0

/obj/item/clothing/gloves/marine/techofficer
	name = "tech officer gloves"
	desc = "Sterile AND insulated! Why is not everyone issued with these?"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.01

/obj/item/clothing/gloves/marine/techofficer/captain
	name = "captain's gloves"
	desc = "You may like these gloves, but THEY think you are unworthy of them."
	icon_state = "captain"
	item_state = "egloves"

/obj/item/clothing/gloves/marine/specialist
	name = "\improper B18 defensive gauntlets"
	desc = "A pair of heavily armored gloves."
	icon_state = "armored"
	item_state = "bgloves"
	armor = list("melee" = 25, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 20, "rad" = 20, "fire" = 20, "acid" = 25)
	resistance_flags = UNACIDABLE

/obj/item/clothing/gloves/marine/veteran/PMC
	name = "armored gloves"
	desc = "Armored gloves used in special operations. They are also insulated against electrical shock."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor = list("melee" = 60, "bullet" = 60, "laser" = 35, "energy" = 30, "bomb" = 30, "bio" = 15, "rad" = 15, "fire" = 30, "acid" = 30)

/obj/item/clothing/gloves/marine/veteran/PMC/commando
	name = "\improper PMC commando gloves"
	desc = "A pair of heavily armored, insulated, acid-resistant gloves."
	icon_state = "brown"
	item_state = "browngloves"
	armor = list("melee" = 90, "bullet" = 120, "laser" = 100, "energy" = 90, "bomb" = 50, "bio" = 30, "rad" = 30, "fire" = 90, "acid" = 90)
	resistance_flags = UNACIDABLE


/obj/item/clothing/gloves/marine/som
	name = "\improper SoM gloves"
	desc = "Gloves with origins dating back to the old mining colonies."
	icon_state = "som"
	item_state = "som"
	armor = list("melee" = 60, "bullet" = 60, "laser" = 35, "energy" = 30, "bomb" = 30, "bio" = 15, "rad" = 15, "fire" = 30, "acid" = 30)


/obj/item/clothing/gloves/marine/som/veteran
	name = "\improper SoM veteran gloves"
	desc = "Gloves with origins dating back to the old mining colonies. Seem to have more care and wear on them."
	icon_state = "som_veteran"
	item_state = "som_veteran"
	armor = list("melee" = 70, "bullet" = 70, "laser" = 45, "energy" = 40, "bomb" = 40, "bio" = 25, "rad" = 25, "fire" = 40, "acid" = 40)
