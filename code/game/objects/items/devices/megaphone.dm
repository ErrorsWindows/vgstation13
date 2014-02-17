/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = 1.0
	flags = FPRINT | TABLEPASS | CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
	if(!ishuman(user))
		user << "\red You don't know how to use this!"
		return
	if(user:miming || user.silent)
		user << "\red You find yourself unable to speak at all."
		return
	if(spamcheck)
		user << "\red \The [src] needs to recharge!"
		return

	var/message = copytext(sanitize(input(user, "Shout a message?", "Megaphone", null)  as text),1,MAX_MESSAGE_LEN)
	if(!message)
		return
	message = capitalize(message)
	if ((src.loc == user && usr.stat == 0))
		if(emagged)
			if(insults)
				for(var/mob/O in (viewers(user)))
					O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
				insults--
			else
				user << "\red *BZZZZzzzzzt*"
		else
			for(var/mob/O in (viewers(user)))
				O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2) // 2 stands for hearable message

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user << "\red You overload \the [src]'s voice synthesizer."
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return
	return
	
	
	
	
/*
	SOUND SYNTH BELOW THIS LINE
----------------------------------------------
*/
	
	

/obj/item/device/soundsynth
	name = "sound synthesizer"
	desc = "A device that is able to create sounds."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = 1.0
	flags = FPRINT | TABLEPASS | CONDUCT

	var/spam_flag = 0 //To prevent mashing the button to cause annoyance like a huge idiot.
	var/sound_flag = 1

/*
This is to cycle sounds forward
*/
/obj/item/device/soundsynth/verb/CycleForward()
	set category = "Object"
	set name = "Cycle Sound Forward"

	if(sound_flag <= 12)
		sound_flag += 1
	else
		return

/*
And backwards
*/
/obj/item/device/soundsynth/verb/CycleBackward()
	set category = "Object"
	set name = "Cycle Sound Backward"

	if(sound_flag >= 0)
		sound_flag -= 1
	else
		return

/*
This long ass as fuck shit plays the sounds. Im a huge fucking faggot.
If you can make this smaller, please do.
*/


/obj/item/device/soundsynth/attack_self(mob/user as mob)
	if(sound_flag == 0)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/items/bikehorn.ogg', 50, 1)
			usr << "Honk!"
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 1)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/effects/adminhelp.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 2)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 3)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/mecha/nominal.ogg', 50, 1)
			spawn(20)
				spam_flag = 0


	if(sound_flag == 4)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/effects/alert.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return


	if(sound_flag == 5)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/items/AirHorn.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 6)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/misc/sadtrombone.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return


	if(sound_flag == 7)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 8)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/items/Welder.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	if(sound_flag == 9)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/hallucinations/turn_around1.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return


	if(sound_flag == 10)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/machines/ding.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return


	if(sound_flag == 11)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/machines/disposalflush.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return


	if(sound_flag == 12)
		if (spam_flag == 0)
			spam_flag = 1
			playsound(get_turf(src), 'sound/machines/twobeep.ogg', 50, 1)
			spawn(20)
				spam_flag = 0
		return

	else
		return
