/datum/automation/set_scrubber_mode
	name="Scrubber: Mode"

	var/scrubber = null
	var/mode = 1

/datum/automation/set_scrubber_mode/Export()
	var/list/json = ..()
	json["scrubber"] = scrubber
	json["mode"] = mode
	return json

/datum/automation/set_scrubber_mode/Import(var/list/json)
	..(json)
	scrubber = json["scrubber"]
	mode = text2num(json["mode"])

/datum/automation/set_scrubber_mode/process()
	if(scrubber)
		parent.send_signal(list ("tag" = scrubber, "sigtype"="command", "scrubbing" = mode), RADIO_FROM_AIRALARM)
	return 0

/datum/automation/set_scrubber_mode/GetText()
	return "Set Scrubber <a href=\"?src=\ref[src];set_scrubber=1\">[fmtString(scrubber)]</a> mode to <a href=\"?src=\ref[src];set_mode=1\">[mode?"Scrubbing":"Syphoning"]</a>."

/datum/automation/set_scrubber_mode/Topic(href,href_list)
	. = ..()
	if(.)
		return

	if(href_list["set_mode"])
		mode = !mode
		parent.updateUsrDialog()
		return 1

	if(href_list["set_scrubber"])
		var/list/injector_names = list()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/S in atmos_machines)
			if(!isnull(S.id_tag) && S.frequency == parent.frequency)
				injector_names |= S.id_tag

		scrubber = input("Select a scrubber:", "Scrubbers", scrubber) as null | anything in injector_names
		parent.updateUsrDialog()
		return 1

/datum/automation/set_scrubber_power
	name = "Scrubber: Power"

	var/scrubber = null
	var/state = 0

/datum/automation/set_scrubber_power/Export()
	var/list/json = ..()
	json["scrubber"] = scrubber
	json["state"] = state
	return json

/datum/automation/set_scrubber_power/Import(var/list/json)
	..(json)
	scrubber = json["scrubber"]
	state = text2num(json["state"])

/datum/automation/set_scrubber_power/New(var/obj/machinery/computer/general_air_control/atmos_automation/aa)
	..(aa)

/datum/automation/set_scrubber_power/process()
	if(scrubber)
		parent.send_signal(list ("tag" = scrubber, "sigtype"="command", "power" = state, "type" = "scrubber"), RADIO_FROM_AIRALARM)

/datum/automation/set_scrubber_power/GetText()
	return  "Set Scrubber <a href=\"?src=\ref[src];set_scrubber=1\">[fmtString(scrubber)]</a> power to <a href=\"?src=\ref[src];set_power=1\">[state ? "on" : "off"]</a>."

/datum/automation/set_scrubber_power/Topic(href,href_list)
	if(..())
		return
	if(href_list["set_power"])
		state = !state
		parent.updateUsrDialog()
		return 1
	if(href_list["set_scrubber"])
		var/list/injector_names=list()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/S in atmos_machines)
			if(!isnull(S.id_tag) && S.frequency == parent.frequency)
				injector_names|=S.id_tag
		scrubber = input("Select a scrubber:", "Scrubbers", scrubber) as null|anything in injector_names
		parent.updateUsrDialog()
		return 1

/datum/automation/set_scrubber_gasses
	name="Scrubber: Gasses"

	var/scrubber=null
	var/list/gasses=list()

/datum/automation/set_scrubber_gasses/New()
	..()
	for(var/gas_ID in XGM.gases)
		gasses[gas_ID] = 0

/datum/automation/set_scrubber_gasses/Export()
	var/list/json = ..()
	json["scrubber"] = scrubber
	json["gasses"] = gasses
	return json

/datum/automation/set_scrubber_gasses/Import(var/list/json)
	..(json)
	scrubber = json["scrubber"]

	var/list/newgasses=json["gasses"]
	for(var/key in newgasses)
		gasses[key] = newgasses[key]

/datum/automation/set_scrubber_gasses/process()
	if(scrubber)
		var/list/data = list ("tag" = scrubber, "sigtype" = "command")
		for(var/gas in gasses)
			data[gas + "_scrub"] = gasses[gas]
		parent.send_signal(data, RADIO_FROM_AIRALARM)

/datum/automation/set_scrubber_gasses/GetText()
	var/txt = "Set Scrubber <a href=\"?src=\ref[src];set_scrubber=1\">[fmtString(scrubber)]</a> to scrub "
	for(var/gas in gasses)
		var/datum/gas/gas_datum = XGM.gases[gas]
		txt += " [gas_datum.short_name || gas_datum.name] (<a href=\"?src=\ref[src];tog_gas=[gas]\">[gasses[gas] ? "on" : "off"]</a>),"
	return txt

/datum/automation/set_scrubber_gasses/Topic(href,href_list)
	. = ..()
	if(.)
		return

	if(href_list["tog_gas"])
		var/gas = href_list["tog_gas"]
		if(!(gas in gasses))
			return
		gasses[gas] = !gasses[gas]
		parent.updateUsrDialog()
		return 1

	if(href_list["set_scrubber"])
		var/list/injector_names = list()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/S in atmos_machines)
			if(!isnull(S.id_tag) && S.frequency == parent.frequency)
				injector_names |= S.id_tag

		scrubber = input("Select a scrubber:", "Scrubbers", scrubber) as null | anything in injector_names
		parent.updateUsrDialog()
		return 1

/datum/automation/set_scrubber_pressure
	name = "Scrubber: Pressure Settings"
	var/scrubber = null
	var/intpressure = 0
	var/extpressure = 0

/datum/automation/set_scrubber_pressure/Export()
	var/list/json = ..()
	json["scrubber"] = scrubber
	json["intpressure"] = intpressure
	json["extpressure"] = extpressure
	return json

/datum/automation/set_scrubber_pressure/Import(var/list/json)
	..(json)
	scrubber = json["scrubber"]
	intpressure = json["intpressure"]
	extpressure = json["extpressure"]

/datum/automation/set_scrubber_pressure/process()
	if(scrubber)
		var/list/data = list("tag" = scrubber)
		if(intpressure)
			data.Add(list("set_internal_pressure" = intpressure))
		if(extpressure)
			data.Add(list("set_external_pressure" = extpressure))
		parent.send_signal(data, RADIO_FROM_AIRALARM)

/datum/automation/set_scrubber_pressure/GetText()
	return {"Set scrubber <a href=\"?src=\ref[src];set_scrubber=1\">[fmtString(scrubber)]</a> pressure bounds:
			internal: <a href=\"?src=\ref[src];set_intpressure=1">[fmtString(intpressure)]</a>
			external: <a href=\"?src=\ref[src];set_extpressure=1">[fmtString(extpressure)]</a>"}

/datum/automation/set_scrubber_pressure/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["set_scrubber"])
		var/list/injector_names = list()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/S in atmos_machines)
			if(!isnull(S.id_tag) && S.frequency == parent.frequency)
				injector_names |= S.id_tag

		scrubber = input("Select a scrubber:", "Scrubbers", scrubber) as null | anything in injector_names
		parent.updateUsrDialog()
		return 1

	if(href_list["set_intpressure"])
		var/response = input("Set new pressure in kPa. \[0-[50*ONE_ATMOSPHERE]\]") as num
		intpressure = text2num(response)
		intpressure = clamp(intpressure, 0, 50*ONE_ATMOSPHERE)
		parent.updateUsrDialog()
		return 1

	if(href_list["set_extpressure"])
		var/response = input(usr,"Set new pressure in kPa. \[0-[50*ONE_ATMOSPHERE]\]") as num
		extpressure = text2num(response)
		extpressure = clamp(extpressure, 0, 50*ONE_ATMOSPHERE)
		parent.updateUsrDialog()
		return 1

/datum/automation/set_scrubber_pressure_checks
	name = "Scrubber: Pressure Checks"
	var/scrubber = null
	var/checks = 1

/datum/automation/set_scrubber_pressure_checks/Export()
	var/list/json = ..()
	json["scrubber"] = scrubber
	json["checks"] = checks

/datum/automation/set_scrubber_pressure_checks/Import(var/list/json)
	..(json)
	scrubber = json["scrubber"]
	checks = json["checks"]

/datum/automation/set_scrubber_pressure_checks/process()
	if(scrubber)
		parent.send_signal(list("tag" = scrubber, "checks" = checks), RADIO_FROM_AIRALARM)

/datum/automation/set_scrubber_pressure_checks/GetText()
	return {"Set scrubber <a href=\"?src=\ref[src];set_scrubber=1\">[fmtString(scrubber)]</a> pressure checks to:
			external: <a href=\"?src=\ref[src];togglecheck=1\">[checks&1 ? "Enabled" : "Disabled"]</a>,
			internal: <a href=\"?src=\ref[src];togglecheck=2\">[checks&2 ? "Enabled" : "Disabled"]</a>"}

/datum/automation/set_scrubber_pressure_checks/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["set_scrubber"])
		var/list/injector_names = list()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/S in atmos_machines)
			if(!isnull(S.id_tag) && S.frequency == parent.frequency)
				injector_names |= S.id_tag

		scrubber = input("Select a scrubber:", "Scrubbers", scrubber) as null | anything in injector_names
		parent.updateUsrDialog()
		return 1

	if(href_list["togglecheck"])
		var/bitflagvalue = text2num(href_list["togglecheck"])
		if(!(bitflagvalue in list(1, 2)))
			return 0

		if(checks&bitflagvalue)//the bitflag is on ATM
			checks &= ~bitflagvalue
		else//can't not be off
			checks |= bitflagvalue
		parent.updateUsrDialog()
		return 1
