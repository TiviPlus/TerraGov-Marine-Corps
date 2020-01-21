/datum/job/imperial
	comm_title = "IMP"
	faction = "Imperium of Mankind"
	skills_type = /datum/skills/imperial
	supervisors = "the sergeant"
	access = ALL_ANTAGONIST_ACCESS
	minimal_access = ALL_ANTAGONIST_ACCESS

/datum/outfit/job/imperial
	name = "Imperial Standard"
	jobtype = /datum/job/imperial

	id = /obj/item/card/id
	//belt =
	ears = /obj/item/radio/headset/distress/imperial
	w_uniform = /obj/item/clothing/under/marine/imperial
	shoes = /obj/item/clothing/shoes/marine/imperial
	//wear_suit =
	gloves = /obj/item/clothing/gloves/marine
	//head =
	//mask =
	//glasses =
	//suit_store =
	//r_store =
	//l_store =
	//back =

/datum/outfit/job/imperial/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.grant_language(/datum/language/imperial)

/datum/job/imperial/guardsman
	title = "Guardsman"
	comm_title = "Guard"
	paygrade = "Guard"
	outfit = /datum/outfit/job/imperial/guardsman

/datum/outfit/job/imperial/guardsman
	name = "Imperial Guardsman"
	jobtype = /datum/job/imperial/guardsman

	belt = /obj/item/storage/belt/marine
	wear_suit = /obj/item/clothing/suit/storage/marine/imperial
	head = /obj/item/clothing/head/helmet/marine/imperial
	r_store = /obj/item/storage/pouch/firstaid/full
	l_store = /obj/item/storage/pouch/flare/full
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/guardsman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)

	var/obj/item/weapon/gun/energy/lasgun/M43/G = new /obj/item/weapon/gun/energy/lasgun/M43(H)
	G.reload(H, new /obj/item/cell/lasgun/M43(G)) // starts out full
	H.equip_to_slot_or_del(G, SLOT_S_STORE)

/datum/job/imperial/guardsman/sergeant
	title = "Guardsman Sergeant"
	comm_title = "Sergeant"
	skills_type = /datum/skills/imperial/SL
	paygrade = "Sergeant"
	outfit = /datum/outfit/job/imperial/sergeant

/datum/outfit/job/imperial/sergeant // don't inherit guardsman equipment
	name = "Guardsman Sergeant"
	jobtype = /datum/job/imperial/guardsman/sergeant

	belt = /obj/item/storage/belt/marine
	wear_suit = /obj/item/clothing/suit/storage/marine/imperial/sergeant
	head = /obj/item/clothing/head/helmet/marine/imperial/sergeant
	r_store = /obj/item/storage/pouch/explosive/upp
	l_store = /obj/item/storage/pouch/field_pouch/full
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/sergeant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)

	var/obj/item/weapon/gun/energy/lasgun/M43/G = new /obj/item/weapon/gun/energy/lasgun/M43(H)
	G.reload(H, new /obj/item/cell/lasgun/M43/highcap(G)) // starts out reloaded
	H.equip_to_slot_or_del(G, SLOT_S_STORE)

/datum/job/imperial/guardsman/krieg //Basically a guardsman reskin
	title = "Krieg Guardsman"
	comm_title = "Krieg Guard"
	outfit = /datum/outfit/job/imperial/guardsman/krieg

/datum/outfit/job/imperial/guardsman/krieg
	name = "Imperial Krieg Guardsman"
	jobtype = /datum/job/imperial/guardsman/krieg

	wear_suit = /obj/item/clothing/suit/storage/marine/imperial
	head = /obj/item/clothing/head/helmet/marine/imperial

/datum/outfit/job/imperial/guardsman/krieg/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BELT)

	var/obj/item/weapon/gun/energy/lasgun/M43/G = new /obj/item/weapon/gun/energy/lasgun/M43(H)
	G.reload(H, new /obj/item/cell/lasgun/M43(G)) // starts out full
	H.equip_to_slot_or_del(G, SLOT_S_STORE)

/datum/job/imperial/guardsman/sergeant/krieg
	title = "Krieg Guardsman Sergeant"
	comm_title = "Sergeant"
	outfit = /datum/outfit/job/imperial/sergeant/krieg

/datum/outfit/job/imperial/sergeant/krieg
	name = "Krieg Guardsman Sergeant"
	jobtype = /datum/job/imperial/guardsman/sergeant/krieg

	wear_suit = /obj/item/clothing/suit/storage/marine/imperial/sergeant
	head = /obj/item/clothing/head/helmet/marine/imperial/sergeant

/datum/outfit/job/imperial/sergeant/krieg/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43/highcap, SLOT_IN_BELT)

	var/obj/item/weapon/gun/energy/lasgun/M43/G = new /obj/item/weapon/gun/energy/lasgun/M43(H)
	G.reload(H, new /obj/item/cell/lasgun/M43/highcap(G)) // starts out reloaded
	H.equip_to_slot_or_del(G, SLOT_S_STORE)

/datum/job/imperial/guardsman/medicae
	title = "Guardsman Medicae"
	comm_title = "Medicae"
	skills_type = /datum/skills/imperial/medicae
	paygrade = "Medicae"
	outfit = /datum/outfit/job/imperial/medicae

/datum/outfit/job/imperial/medicae
	name = "Guardsman Medicae"
	jobtype = /datum/job/imperial/guardsman/medicae

	belt = /obj/item/storage/belt/combatLifesaver
	wear_suit = /obj/item/clothing/suit/storage/marine/imperial/medicae
	head = /obj/item/clothing/head/helmet/marine/imperial
	glasses = /obj/item/clothing/glasses/hud/health
	l_store = /obj/item/storage/pouch/medkit
	r_store = /obj/item/storage/pouch/autoinjector
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/medicae/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/cell/lasgun/M43, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/defibrillator, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/zoom, SLOT_IN_BELT) // closest thing to combat performance drugs

	var/obj/item/weapon/gun/energy/lasgun/M43/G = new /obj/item/weapon/gun/energy/lasgun/M43(H)
	G.reload(H, new /obj/item/cell/lasgun/M43(G)) // starts out reloaded
	H.equip_to_slot_or_del(G, SLOT_S_STORE)

/datum/job/imperial/commissar
	title = "Imperial Commissar"
	comm_title = "Commissar"
	skills_type = /datum/skills/imperial/SL
	paygrade = "Commissar"
	outfit = /datum/outfit/job/imperial/commissar

/datum/outfit/job/imperial/commissar
	name = "Imperial Commissar"
	jobtype = /datum/job/imperial/commissar

	belt = /obj/item/storage/belt/gun/mateba/full //Ideally this can be later replaced with a bolter
	w_uniform = /obj/item/clothing/under/marine/commissar
	wear_suit = /obj/item/clothing/suit/storage/marine/imperial/commissar
	gloves = /obj/item/clothing/gloves/marine/commissar
	head = /obj/item/clothing/head/commissar
	l_store = /obj/item/storage/pouch/medkit
	r_store = /obj/item/storage/pouch/magazine/pistol/large/mateba
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/commissar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)



/datum/job/imperial/astartes
	title = "Adeptus Astartes Space Marine"
	comm_title = "Space Marine"
	skills_type = /datum/skills/imperial/marine
	paygrade = "Space Marine"
	outfit = /datum/outfit/job/imperial/marine

/datum/outfit/job/imperial/astartes
	name = "Imperial Space Marine"
	jobtype = /datum/job/imperial/astartes

	belt = 
	w_uniform = 
	wear_suit = 
	gloves = 
	head = 
	l_store = /obj/item/storage/pouch/medkit
	r_store = 
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/astartes/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/m15, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)

/datum/job/imperial/astartes/captain //Space marine SL
	title = "Adeptus Astartes Space Marine Captain"
	comm_title = "Marine Captain"
	skills_type = /datum/skills/imperial/astartes/captain
	paygrade = "Space Marine"
	outfit = /datum/outfit/job/imperial/astartes/captain

/datum/outfit/job/imperial/astartes/captain
	name = "Imperial Space Marine Captain"
	jobtype = /datum/job/imperial/astartes/captain

	belt = 
	w_uniform = 
	wear_suit = 
	gloves = 
	head = 
	l_store = 
	r_store = 
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/astartes/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/m15, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)

/datum/job/imperial/astartes/captain //Space marine medic
	title = "Adeptus Astartes Space Marine Captain"
	comm_title = "Marine Apothecary"
	skills_type = /datum/skills/imperial/astartes/apothecary
	paygrade = "Space Marine"
	outfit = /datum/outfit/job/imperial/astartes/apothecary

/datum/outfit/job/imperial/astartes/apothecary
	name = "Imperial Space Marine Apothecary"
	jobtype = /datum/job/imperial/astartes/apothecary

	belt = /obj/item/storage/belt/combatLifesaver
	wear_suit = 
	head = 
	glasses = /obj/item/clothing/glasses/hud/health
	l_store = /obj/item/storage/pouch/medkit
	r_store = /obj/item/storage/pouch/autoinjector
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/astartes/apothecary/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/tricordrazine, SLOT_IN_HEAD)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/hypospray/autoinjector/oxycodone, SLOT_IN_HEAD)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag/m15, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)

/datum/job/imperial/inquisitor
	title = "Imperial Inquistor"
	comm_title = "Inquisitor"
	skills_type = /datum/skills/imperial/marine/inquisitor
	paygrade = "Inquisitor"
	outfit = /datum/outfit/job/imperial/marine/inquisitor

/datum/outfit/job/imperial/marine/inquisitor
	name = "Imperial Inquisitor"
	jobtype = /datum/job/imperial/marine/inquisitor

	belt = 
	w_uniform = 
	wear_suit = 
	gloves = 
	head = 
	l_store = 
	r_store = 
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/inquisitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)

/datum/job/imperial/inquisitor/lord //Inquisitor SL
	title = "Imperial High Inquistor"
	comm_title = "High Inquisitor"
	skills_type = /datum/skills/imperial/marine/inquisitor/lord
	paygrade = "High Inquisitor"
	outfit = /datum/outfit/job/imperial/marine/inquisitor/lord

/datum/outfit/job/imperial/marine/inquisitor/lord
	name = "Imperial High Inquisitor"
	jobtype = /datum/job/imperial/marine/inquisitor/lord

	belt = 
	w_uniform = 
	wear_suit = 
	gloves = 
	head = 
	l_store = 
	r_store = 
	back = /obj/item/storage/backpack/lightpack

/datum/outfit/job/imperial/inquisitor/lord/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, SLOT_IN_L_POUCH)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/frag, SLOT_IN_SUIT)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary, SLOT_IN_SUIT)

	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/enrg_bar, SLOT_IN_BACKPACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/claymore/mercsword/commissar_sword, SLOT_S_STORE)
