/obj/machinery/computer/blackjack_machine
	name = "blackjack machine"
	desc = "21 or bust."
	icon = 'icons/obj/economy.dmi'
	icon_state = "slots1"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	circuit = /obj/item/circuitboard/computer/blackjack_machine
	var/money = 3000
	var/bet = 50
	var/list/deck = list("A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2, "A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2, "A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2, "A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2)
	var/balance = 0
	var/dealertotal = 0
	var/playertotal = 0
	var/working = 0
	var/standing = 0
	var/gameinprogress = 0
	var/list/playerhand = new/list()
	var/list/dealerhand = new/list()

/obj/machinery/computer/blackjack_machine/Initialize()
	. = ..()
	shuffle(deck)

/obj/machinery/computer/blackjack_machine/process()
	. = ..() //Sanity checks.
	if(!.)
		return .

	money++ //SPESSH MAJICKS


/obj/machinery/computer/blackjack_machine/update_icon()
	if(stat & NOPOWER)
		icon_state = "slots0"

	else if(stat & BROKEN)
		icon_state = "slotsb"

	else if(working)
		icon_state = "slots2"

	else
		icon_state = "slots1"

/obj/machinery/computer/blackjack_machine/power_change()
	..()
	update_icon()

/obj/machinery/computer/blackjack_machine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/coin))
		to_chat(user, "<span class='warning'>This machine is only accepting holochips!</span>")
	else if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		if(!user.temporarilyRemoveItemFromInventory(H))
			return
		to_chat(user, "<span class='notice'>You insert [H.credits] holocredits into [src]'s!</span>")
		balance += H.credits
		qdel(H)
		updateDialog()
	else
		return ..()


/obj/machinery/computer/blackjack_machine/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(4, 0, src.loc)
	spark_system.start()
	playsound(src, "sparks", 50, 1)



/obj/machinery/computer/blackjack_machine/ui_interact(mob/living/user)
	. = ..()
	var/dat

	if(gameinprogress == 0)
		dat = {"<center>[bet] credits to play!<BR>
		<font size='1'>50 Credit Minimum, 500 Credit Maximum</center><BR>
		<B>Credit Remaining:</B> [balance]<BR>
		<HR>
		<font size='1'><A href='?src=[REF(src)];betminus=1'>Bet-</A><font size='3'><A href='?src=[REF(src)];deal=1'>Deal!</A><font size='1'><A href='?src=[REF(src)];betplus=1'>Bet+</A><BR>
		<BR>
		</center><font size='1'><A href='?src=[REF(src)];refund=1'>Refund balance</A><BR>"}

	else
		dat = {"<center><font size='1'><A href='?src=[REF(src)];hit=1'>Hit</A><font size='3'><A href='?src=[REF(src)];stand=1'>Stand</A><BR>
		<BR><font size='4'>
		[list2params(playerhand)]
		<BR>
		You have: [get_value(playerhand)]<BR>
		The Dealer has [dealerhand[1]] showing.
		<BR></center>"}

	var/datum/browser/popup = new(user, "blackjackmachine", "BlackJack Machine")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()


/obj/machinery/computer/blackjack_machine/Topic(href, href_list)
	. = ..() //Sanity checks.
	if(.)
		return .

	if(href_list["deal"])
		if(balance >= bet)
			deal()
			deal()
			gameinprogress = 1
			updateDialog()
		else
			visible_message("<b>[src]</b> says, 'Not Enough Balance to make your Bet!'")

	else if(href_list["betplus"])
		if(bet < 500)
			bet += 25
			updateDialog()

	else if(href_list["betminus"])
		if(bet >= 75)
			bet -= 25
			updateDialog()

	else if(href_list["refund"])
		if(balance > 0)
			give_payout(balance)
			balance = 0

	else if(href_list["hit"])
		hit()
		updateDialog()

	else if(href_list["stand"])
		dealer_turn()
		updateDialog()

/obj/machinery/computer/blackjack_machine/proc/deal()
	var/cardone = pick(deck)
	var/cardtwo = pick(deck)
	playerhand += cardone
	dealerhand += cardtwo
	return 1

/obj/machinery/computer/blackjack_machine/proc/hit()
	var/cardone = pick(deck)
	playerhand += cardone
	if(get_value(playerhand) > 21)
		visible_message("<b>[src]</b> says, 'You Bust!'")
		dealer_turn()
		return 0
	return 1


/obj/machinery/computer/blackjack_machine/proc/get_value(hand)
	var/aced = 0
	var/total = 0
	for(var/i in hand)
		if(i=="A")
			aced += 1

	for(var/i in hand)
		if(i=="A")
			total += 11
		else if(i=="K")
			total += 10
		else if(i=="Q")
			total += 10
		else if(i=="J")
			total += 10
		else
			total += i

	while(aced >= 1 && total > 21)
		total = total - 10
		aced -= 1

	return total



/obj/machinery/computer/blackjack_machine/proc/dealer_turn()
	while(get_value(dealerhand) < 16)
		dealerhand += pick(deck)
		visible_message("<b>[src]</b> says, 'Dealer Hits! Dealer has: [get_value(dealerhand)]'")

	visible_message("<b>[src]</b> says, 'Dealer Stands.'")

	if(get_value(dealerhand) > 21 && get_value(playerhand) <= 21)
		balance += (bet*2)
		visible_message("<b>[src]</b> says, 'Dealer Busts! You Win!'")
	else if(get_value(dealerhand) < get_value(playerhand) && get_value(playerhand) <= 21)
		visible_message("<b>[src]</b> says, 'You Win!'")
		balance += (bet*2)
	else if(get_value(dealerhand) == get_value(playerhand))
		balance += bet
		visible_message("<b>[src]</b> says, 'You Push!'")

	gameinprogress = 0

	return 1


/obj/machinery/computer/blackjack_machine/proc/give_payout(amount)
	if(!(obj_flags & EMAGGED))
		amount = dispense(amount, /obj/item/holochip, null, 0)

	else
		var/mob/living/target = locate() in range(2, src)

		amount = dispense(amount, /obj/item/holochip, target, 1)

	return amount



/obj/machinery/computer/blackjack_machine/proc/dispense(amount = 0, /obj/item/holochip, mob/living/target, throwit = 0)
	var/obj/item/holochip/H = new /obj/item/holochip(loc,amount)
	if(throwit && target)
		H.throw_at(target, 3, 10)

	return amount
