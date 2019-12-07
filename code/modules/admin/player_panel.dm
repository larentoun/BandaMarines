
/datum/admins/proc/player_panel_new()//The new one
	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return
	var/dat = "<html><head><title>Admin Player Panel</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,job,name,real_name,image,key,ip,antagonist,ref){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+job+" "+name+"</b><br><b>Real name "+real_name+"</b><br><b>Played by "+key+" ("+ip+")</b></font>"

					body += "</td><td align='center'>";

					body += "<a href='?src=\ref[src];ahelp=adminplayeropts;extra="+ref+"'>PP</a> - "
					body += "<a href='?src=\ref[src];playerpanelextended="+ref+"'>PPE</a> - "
					body += "<a href='?src=\ref[src];notes=show;mob="+ref+"'>N</a> - "
					body += "<a href='?_src_=vars;Vars="+ref+"'>VV</a> - "
					body += "<a href='?src=\ref[src];traitor="+ref+"'>TP</a> - "
					body += "<a href='?src=\ref[usr];priv_msg=\ref"+ref+"'>PM</a> - "
					body += "<a href='?src=\ref[src];subtlemessage="+ref+"'>SM</a> - "
					body += "<a href='?src=\ref[src];adminplayerobservejump="+ref+"'>JMP</a><br>"
					if(antagonist > 0)
						body += "<font size='2'><a href='?src=\ref[src];check_antagonist=1'><font color='red'><b>Antagonist</b></font></a></font>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Player panel</b></font><br>
					Hover over a line to see more information - <a href='?src=\ref[src];check_antagonist=1'>Check antagonists</a>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/list/mobs = sortmobs()
	var/i = 1
	for(var/mob/M in mobs)
		if(M.ckey)

			var/color = "#e6e6e6"
			if(i%2 == 0)
				color = "#f2f2f2"
			var/is_antagonist = is_special_character(M)

			var/M_job = ""

			if(isliving(M))

				if(iscarbon(M)) //Carbon stuff
					if(ishuman(M))
						M_job = M.job
					else if(ismonkey(M))
						M_job = "Monkey"
					else if(isXeno(M))
						M_job = "Alien"
					else
						M_job = "Carbon-based"

				else if(issilicon(M)) //silicon
					if(isAI(M))
						M_job = "AI"
					else if(isrobot(M))
						M_job = "Cyborg"
					else
						M_job = "Silicon-based"

				else if(isanimal(M)) //simple animals
					if(iscorgi(M))
						M_job = "Corgi"
					else
						M_job = "Animal"

				else
					M_job = "Living"

			else if(istype(M,/mob/new_player))
				M_job = "New player"

			else if(isobserver(M))
				M_job = "Ghost"

			M_job = replacetext(M_job, "'", "")
			M_job = replacetext(M_job, "\"", "")
			M_job = replacetext(M_job, "\\", "")

			var/M_name = M.name
			M_name = replacetext(M_name, "'", "")
			M_name = replacetext(M_name, "\"", "")
			M_name = replacetext(M_name, "\\", "")
			var/M_rname = M.real_name
			M_rname = replacetext(M_rname, "'", "")
			M_rname = replacetext(M_rname, "\"", "")
			M_rname = replacetext(M_rname, "\\", "")

			var/M_key = M.key
			M_key = replacetext(M_key, "'", "")
			M_key = replacetext(M_key, "\"", "")
			M_key = replacetext(M_key, "\\", "")

			//output for each mob
			dat += {"

				<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
					<td align='center' bgcolor='[color]'>
						<span id='notice_span[i]'></span>
						<a id='link[i]'
						onmouseover='expand("item[i]","[M_job]","[M_name]","[M_rname]","--unused--","[M_key]","[M.lastKnownIP]",[is_antagonist],"\ref[M]")'
						>
						<b id='search[i]'>[M_name] - [M_rname] - [M_key] ([M_job])</b>
						</a>
						<br><span id='item[i]'></span>
					</td>
				</tr>

			"}

			i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	usr << browse(dat, "window=players;size=600x480")

//Extended panel with ban related things
/datum/admins/proc/player_panel_extended()
	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return

	var/dat = "<html><head><title>Player Menu</title></head>"
	dat += "<body><table border=1 cellspacing=5><B><tr><th>Key</th><th>Name</th><th>Real Name</th><th>PP</th><th>CID</th><th>IP</th><th>JMP</th><th>Notes</th></tr></B>"
	//add <th>IP:</th> to this if wanting to add back in IP checking
	//add <td>(IP: [M.lastKnownIP])</td> if you want to know their ip to the lists below
	var/list/mobs = sortmobs()

	for(var/mob/M in mobs)
		if(!M.ckey) continue

		dat += "<tr><td>[(M.client ? "[M.client]" : "No client")]</td>"
		dat += "<td><a href='?src=\ref[usr];priv_msg=\ref[M]'>[M.name]</a></td>"
		if(isAI(M))
			dat += "<td>AI</td>"
		else if(isrobot(M))
			dat += "<td>Cyborg</td>"
		else if(ishuman(M))
			dat += "<td>[M.real_name]</td>"
		else if(istype(M, /mob/new_player))
			dat += "<td>New Player</td>"
		else if(isobserver(M))
			dat += "<td>Ghost</td>"
		else if(ismonkey(M))
			dat += "<td>Monkey</td>"
		else if(isXeno(M))
			dat += "<td>Alien</td>"
		else
			dat += "<td>Unknown</td>"


		dat += {"<td align=center><a HREF='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>X</a></td>
		<td>[M.computer_id]</td>
		<td>[M.lastKnownIP]</td>
		<td><a href='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a></td>
		<td><a href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</a></td>
		"}


	dat += "</table></body></html>"

	usr << browse(dat, "window=players;size=640x480")


/datum/admins/proc/check_antagonists()
	if (ticker && ticker.current_state >= GAME_STATE_PLAYING)
		var/dat = "<html><head><title>Round Status</title></head><body><h1><B>Round Status</B></h1>"
		dat += "Current Game Mode: <B>[ticker.mode.name]</B><BR>"
		dat += "Round Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B><BR>"

		if(check_rights(R_DEBUG, 0))
			dat += "<br><A HREF='?_src_=vars;Vars=\ref[EvacuationAuthority]'>VV Evacuation Controller</A><br>"
			dat += "<A HREF='?_src_=vars;Vars=\ref[shuttle_controller]'>VV Shuttle Controller</A><br><br>"

		if(check_rights(R_MOD, 0))
			dat += "<b>Evacuation:</b> "
			switch(EvacuationAuthority.evac_status)
				if(EVACUATION_STATUS_STANDING_BY) dat += 	"STANDING BY"
				if(EVACUATION_STATUS_INITIATING) dat += 	"IN PROGRESS: [EvacuationAuthority.get_status_panel_eta()]"
				if(EVACUATION_STATUS_COMPLETE) dat += 		"COMPLETE"
			dat += "<br>"

			dat += "<a href='?src=\ref[src];evac_authority=init_evac'>Initiate Evacuation</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=cancel_evac'>Cancel Evacuation</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=toggle_evac'>Toggle Evacuation Permission (does not affect evac in progress)</a><br>"
			if(check_rights(R_ADMIN, 0)) dat += "<a href='?src=\ref[src];evac_authority=force_evac'>Force Evacuation Now</a><br>"

		if(check_rights(R_ADMIN, 0))
			dat += "<b>Self Destruct:</b> "
			switch(EvacuationAuthority.dest_status)
				if(NUKE_EXPLOSION_INACTIVE) dat += 		"INACTIVE"
				if(NUKE_EXPLOSION_ACTIVE) dat += 		"ACTIVE"
				if(NUKE_EXPLOSION_IN_PROGRESS) dat += 	"IN PROGRESS"
				if(NUKE_EXPLOSION_FINISHED || NUKE_EXPLOSION_GROUND_FINISHED) dat += 		"FINISHED"
			dat += "<br>"

			dat += "<a href='?src=\ref[src];evac_authority=init_dest'>Unlock Self Destruct control panel for humans</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=cancel_dest'>Lock Self Destruct control panel for humans</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=use_dest'>Destruct the [MAIN_SHIP_NAME] NOW</a><br>"
			dat += "<a href='?src=\ref[src];evac_authority=toggle_dest'>Toggle Self Destruct Permission (does not affect evac in progress)</a><br>"

		dat += "<br><a href='?src=\ref[src];delay_round_end=1'>[ticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"

		if(ticker.mode.xenomorphs.len)
			dat += "<br><table cellspacing=5><tr><td><B>Aliens</B></td><td></td><td></td></tr>"
			for(var/datum/mind/L in ticker.mode.xenomorphs)
				var/mob/M = L.current
				var/location = get_area(M.loc)
				if(M)
					dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
					dat += "<td>[location]</td>"
					dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
					dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
			dat += "</table>"

		if(ticker.liaison)
			dat += "<br><table cellspacing=5><tr><td><B>Corporate Liaison</B></td><td></td><td></td></tr>"
			var/mob/M = ticker.liaison.current
			var/location = get_area(M.loc)
			if(M)
				dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
				dat += "<td>[location]</td>"
				dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
				dat += "<td><A href='?src=\ref[src];traitor=\ref[M]'>TP</A></td>"
				dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
			dat += "</table>"

		if(ticker.mode.survivors.len)
			dat += "<br><table cellspacing=5><tr><td><B>Survivors</B></td><td></td><td></td></tr>"
			for(var/datum/mind/L in ticker.mode.survivors)
				var/mob/M = L.current
				var/location = get_area(M.loc)
				if(M)
					dat += "<tr><td><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
					dat += "<td>[location]</td>"
					dat += "<td><a href='?src=\ref[usr];track=\ref[M]'>F</a></td>"
					dat += "<td><A href='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A></td></TR>"
			dat += "</table>"

		if(ticker.mode.traitors.len)
			dat += check_role_table("Traitors", ticker.mode.traitors, src)

		dat += "</body></html>"
		usr << browse(dat, "window=roundstatus;size=600x500")
	else
		alert("The game hasn't started yet!")

/proc/check_role_table(name, list/members, admins, show_objectives=1)
	var/txt = "<br><table cellspacing=5><tr><td><b>[name]</b></td><td></td></tr>"
	for(var/datum/mind/M in members)
		txt += check_role_table_row(M.current, admins, show_objectives)
	txt += "</table>"
	return txt

/proc/check_role_table_row(mob/M, admins=src, show_objectives)
	if (!istype(M))
		return "<tr><td><i>Not found!</i></td></tr>"

	var/txt = {"
		<tr>
			<td>
				<a href='?src=\ref[admins];ahelp=adminplayeropts;extra=\ref[M]'>[M.real_name]</a>
				[M.client ? "" : " <i>(logged out)</i>"]
				[M.is_dead() ? " <b><font color='red'>(DEAD)</font></b>" : ""]
			</td>
			<td>
				<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>
			</td>
	"}

	if (show_objectives)
		txt += {"
			<td>
				<a href='?src=\ref[admins];traitor=\ref[M]'>Show Objective</a>
			</td>
		"}

	txt += "</tr>"
	return txt

/datum/admins/proc/show_player_panel(var/mob/M in mob_list)
	set name = "Show Player Panel"
	set desc = "Edit player (respawn, ban, heal, etc)"
	set category = null

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key] played by [M.client]</title></head>"
	body += "<body>Name: <b>[M]</b>"
	if(M.client)
		body += " - Ckey: <b>[M.client]</b> "
		body += "\[<A href='?src=\ref[src];editrights=show'>[M.client.admin_holder ? M.client.admin_holder.rank : "Player"]</A>\]"

	if(istype(M, /mob/new_player))
		body += "| <B>Hasn't Entered Game</B> "
	else
		body += {" \[<A href='?src=\ref[src];revive=\ref[M]'>Heal</A>\]
		<br><b>Mob type</b> = [M.type]<br>
		"}

	body += {"
		\[
		<a href='?_src_=vars;Vars=\ref[M]'>VV</a> -
		<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='?src=\ref[src];subtlemessage=\ref[M]'>SM</a> -
		<a href='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</a> -
		<a href='?src=\ref[src];adminplayerfollow=\ref[M]'>FLW</a> ]<br>
		<br><b>Admin Tools:</b><br>
		\[ Ban:
		<A href='?src=\ref[src];newban=\ref[M]'>Ban</A> |
		<A href='?src=\ref[src];eorgban=\ref[M]'>EORG Ban</A> |
		<A href='?src=\ref[src];jobban2=\ref[M]'>Jobban</A> |
		<A href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A> ]
	"}

	if(M.client)
		body += "\ <br>"
		var/muted = M.client.prefs.muted
		body += {"\[ Mute: <A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>Pray</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>Ahelp</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>Dchat</font></a> |
			 <A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>Toggle All</font></a> ]
		"}

	body += {"<br>\[ Misc:
		<A href='?_src_=admin_holder;sendbacktolobby=\ref[M]'>Back to Lobby</A> | <A href='?src=\ref[src];getmob=\ref[M]'>Get</A> | <A href='?src=\ref[src];narrateto=\ref[M]'>Narrate</A> | <A href='?src=\ref[src];sendmob=\ref[M]'>Send</A> ]
	"}

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += {"<br><br>
				<b>Transformation:</b>
				<br>\[ Humanoid: <A href='?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A> | <a href='?src=\ref[src];makeyautja=\ref[M]'>Yautja</a> |
				<A href='?src=\ref[src];simplemake=farwa;mob=\ref[M]'>Farwa</A> |
				<A href='?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='?src=\ref[src];simplemake=neaera;mob=\ref[M]'>Neaera</A> |
				<A href='?src=\ref[src];simplemake=yiren;mob=\ref[M]'>Yiren</A> \]
				<br>\[ Alien Tier 0: <A href='?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A> \]
				<br>\[ Alien Tier 1: <A href='?src=\ref[src];simplemake=runner;mob=\ref[M]'>Runner</A> |
				<A href='?src=\ref[src];simplemake=drone;mob=\ref[M]'>Drone</A> |
				<A href='?src=\ref[src];simplemake=sentinel;mob=\ref[M]'>Sentinel</A> |
				<A href='?src=\ref[src];simplemake=defender;mob=\ref[M]'>Defender</A> \]
				<br>\[ Alien Tier 2: <A href='?src=\ref[src];simplemake=lurker;mob=\ref[M]'>Lurker</A> |
				<A href='?src=\ref[src];simplemake=warrior;mob=\ref[M]'>Warrior</A> |
				<A href='?src=\ref[src];simplemake=spitter;mob=\ref[M]'>Spitter</A> |
				<A href='?src=\ref[src];simplemake=burrower;mob=\ref[M]'>Burrower</A> |
				<A href='?src=\ref[src];simplemake=hivelord;mob=\ref[M]'>Hivelord</A> |
				<A href='?src=\ref[src];simplemake=carrier;mob=\ref[M]'>Carrier</A> \]
				<br>\[ Alien Tier 3: <A href='?src=\ref[src];simplemake=ravager;mob=\ref[M]'>Ravager</A> |
				<A href='?src=\ref[src];simplemake=praetorian;mob=\ref[M]'>Praetorian</A> |
				<A href='?src=\ref[src];simplemake=boiler;mob=\ref[M]'>Boiler</A> |
				<A href='?src=\ref[src];simplemake=crusher;mob=\ref[M]'>Crusher</A> \]
				<br>\[ Alien Tier 4: <A href='?src=\ref[src];simplemake=queen;mob=\ref[M]'>Queen</A> \]
				<br>\[ Alien Specials: <A href='?src=\ref[src];simplemake=ravenger;mob=\ref[M]'>Ravenger</A> |
				<A href='?src=\ref[src];simplemake=predalien;mob=\ref[M]'>Predalien</A> \]
				<br>\[ Misc: <A href='?src=\ref[src];makeai=\ref[M]'>AI</A> | <A href='?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> | <A href='?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> | <A href='?src=\ref[src];simplemake=robot;mob=\ref[M]'>Robot</A> \]
			"}

	body += {"<br><br><b>Other actions:</b>
		<br>
		\[ Force: <A href='?src=\ref[src];forcespeech=\ref[M]'>Force Say</A> | <A href='?src=\ref[src];forceemote=\ref[M]'>Force Emote</A> ]<br>
		\[ Thunderdome: <A href='?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> | <A href='?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> ]
	"}

	if(ishuman(M))
		body += {"<br>\[ Infection: <A href='?src=\ref[src];larvainfect=\ref[M]'>Xeno Larva</A> | <A href='?src=\ref[src];zombieinfect=\ref[M]'>Zombie Virus</A> ]
	"}

	if(isXeno(M))
		body += "<br>\[ Upgrade: <A href='?src=\ref[src];xenoupgrade=\ref[M]'>Upgrade Xeno</A> ]"

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")
