-- Written by Kynetix @ Kil'Jaeden-US Alliance

local isOn
local intOn
local disOn
local playerName = UnitName("player");
local petName = UnitName("pet");
local self

function Purge_OnLoad(this)
	SLASH_PURGE1= "/purge";
	SlashCmdList["PURGE"] = Purge_CommandParse;
	this:RegisterEvent("PLAYER_LOGIN");
	this:RegisterEvent("PLAYER_LOGOUT");
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function Purge_OnEvent(this, event, ...)
	if (event=="PLAYER_LOGIN") then
		if (PurgeOn == nil) then
			PurgeOn = true
		end
		if (InterruptOn == nil) then
			InterruptOn = true
		end
		if (DispelOn == nil) then
			DispelOn = true
		end
		if (PurgeSelf == nil) then
			PurgeSelf = false
		end
		if (PurgeTo == nil) then
			PurgeTo = "SAY"
		end
		Purge_Hello();
	end
	
	if (event=="PLAYER_LOGOUT") then
		PurgeOn = PurgeOn;
		PurgeTo = PurgeTo;
		PurgeSelf = PurgeSelf;
		InterruptOn = InterruptOn;
		DispelOn = DispelOn;
		this:UnregisterEvent("PLAYER_LOGIN");
		this:UnregisterEvent("PLAYER_LOGOUT");
		this:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
	

	local _,type, _, _,sourceName, _, _, _,targetName,_,_,_,_,_,spellId,spellName,schoolnumber= select(1, ...)

	if (event=="COMBAT_LOG_EVENT_UNFILTERED" and PurgeOn == true) then
		if(type == "SPELL_INTERRUPT" and InterruptOn == true)  then

			local school = "";
    
			if(schoolnumber == 1)then
				school = "Physical"
			elseif(schoolnumber == 2)then
				school = "Holy"
			elseif(schoolnumber == 3)then
				school = "Holy + Physical"
			elseif(schoolnumber == 4)then
				school = "Fire"
			elseif(schoolnumber == 5)then
				school = "Fire + Physical"
			elseif(schoolnumber == 6)then
				school = "Fire + Holy"
			elseif(schoolnumber == 8)then
				school = "Nature"
			elseif(schoolnumber == 9)then
				school = "Nature + Physical"
			elseif(schoolnumber == 10)then
				school = "Nature + Holy"
			elseif(schoolnumber == 12)then
				school = "Nature + Fire"
			elseif(schoolnumber == 16)then
				school = "Frost"
			elseif(schoolnumber == 17)then
				school = "Frost + Physical"
			elseif(schoolnumber == 18)then
				school = "Frost + Holy"
			elseif(schoolnumber == 20)then
				school = "Frost + Fire"
			elseif(schoolnumber == 24)then
				school = "Frost + Nature"
			elseif(schoolnumber == 24)then
				school = "Frost + Nature + Fire"
			elseif(schoolnumber == 32)then
				school = "Shadow"
			elseif(schoolnumber == 33)then
				school = "Shadow + Physical"
			elseif(schoolnumber == 34)then
				school = "Shadow + Holy"
			elseif(schoolnumber == 36)then
				school = "Shadow + Fire"
			elseif(schoolnumber == 40)then
				school = "Shadow + Nature"
			elseif(schoolnumber == 48)then
				school = "Shadow + Frost"
			elseif(schoolnumber == 64)then
				school = "Arcane"
			elseif(schoolnumber == 65)then
				school = "Arcane + Physical"
			elseif(schoolnumber == 66)then
				school = "Arcane + Holy"
			elseif(schoolnumber == 68)then
				school = "Arcane + Fire"
			elseif(schoolnumber == 72)then
				school = "Arcane + Nature"
			elseif(schoolnumber == 80)then
				school = "Arcane + Frost"
			elseif(schoolnumber == 96)then
				school = "Arcane + Shadow"
			elseif(schoolnumber == 124)then
				school = "Arcane + Shadow + Fire + Nature + Frost"
			elseif(schoolnumber == 126)then
				school = "Arcane + Shadow + Fire + Nature + Frost + Holy"
			elseif(schoolnumber == 127)then
				school = "Arcane + Shadow + Fire + Nature + Frost + Holy + Physical"
			else
				school = "Unknown"
			end

			if (PurgeTo ~= "SELF") then
				if (PurgeSelf == false) then
					SendChatMessage(sourceName.." interrupted "..targetName.."'s "..GetSpellLink(spellId).." ("..school..").",""..PurgeTo.."")
				elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
					SendChatMessage(sourceName.." interrupted "..targetName.."'s "..GetSpellLink(spellId).." ("..school..").",""..PurgeTo.."")
				end
			else
				if (PurgeSelf == false) then
					Purge_Message(sourceName.." interrupted "..targetName.."'s "..GetSpellLink(spellId).." ("..school..").")
				elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
					Purge_Message(sourceName.." interrupted "..targetName.."'s "..GetSpellLink(spellId).." ("..school..").")
				end
			end
		end

		if(type == "SPELL_STOLEN" and DispelOn == true)  then
			if (PurgeTo ~= "SELF") then
				if (PurgeSelf == false) then
					SendChatMessage(sourceName.." stole "..targetName.."'s "..GetSpellLink(spellId)..".",""..PurgeTo.."")
				elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
					SendChatMessage(sourceName.." stole "..targetName.."'s "..GetSpellLink(spellId)..".",""..PurgeTo.."")
				end
			else
				if (PurgeSelf == false) then
					Purge_Message(sourceName.." stole "..targetName.."'s "..GetSpellLink(spellId)..".")
				elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
					Purge_Message(sourceName.." stole "..targetName.."'s "..GetSpellLink(spellId)..".")
				end
			end
		end

		if(type == "SPELL_DISPEL" and DispelOn == true)  then
			if (PurgeTo ~= "SELF") then
				if (sourceName == targetName) then
					if (PurgeSelf == false) then
						SendChatMessage(sourceName.." dispelled "..GetSpellLink(spellId)..".",""..PurgeTo.."")
					elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
						SendChatMessage(sourceName.." dispelled "..GetSpellLink(spellId)..".",""..PurgeTo.."")
					end
				else
					if (PurgeSelf == false) then
						SendChatMessage(sourceName.." dispelled "..targetName.."'s "..GetSpellLink(spellId)..".",""..PurgeTo.."")
					elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
						SendChatMessage(sourceName.." dispelled "..targetName.."'s "..GetSpellLink(spellId)..".",""..PurgeTo.."")
					end
				end
			else
				if (sourceName == targetName) then
					if (PurgeSelf == false) then
						Purge_Message(sourceName.." dispelled "..GetSpellLink(spellId)..".")
					elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
						Purge_Message(sourceName.." dispelled "..GetSpellLink(spellId)..".")
					end
				else
					if (PurgeSelf == false) then
						Purge_Message(sourceName.." dispelled "..targetName.."'s "..GetSpellLink(spellId)..".")
					elseif (PurgeSelf == true and ((sourceName == playerName) or (sourceName == petName))) then
						Purge_Message(sourceName.." dispelled "..targetName.."'s "..GetSpellLink(spellId)..".")
					end
				end
			end
		end
	end
end

function Purge_Hello()
	if (PurgeOn == true) then
		isOn = "On"
	elseif (PurgeOn == false) then
		isOn = "Off"
	end

	if (InterruptOn == true) then
		intOn = "On"
	elseif (InterruptOn == false) then
		intOn = "Off"
	end

	if (Dispel == true) then
		disOn = "On"
	elseif (DispelOn == false) then
		disOn = "Off"
	end

	if (PurgeSelf == true) then
		self = "On"
	elseif (PurgeSelf == false) then
		self = "Off"
	end

	Purge_Message('Purge by Kynetix <Refraction> of Kil\'Jaeden Alliance-US');
	Purge_Message('Type "/purge help" for... help.');
	Purge_Message('Purge is '..isOn..' and is set to '..PurgeTo);
end

function Purge_Message(message)
	DEFAULT_CHAT_FRAME:AddMessage("[Purge] " .. message, 1, 0.65, 0);
end

function Purge_CommandParse(parameterstring)
	local command = nil;

	command=string.lower(parameterstring);

	if (command == 'off') then
		PurgeOn = false
		isOn = "Off"
		Purge_Message('Purge is '..isOn);
	elseif (command == 'on') then
		PurgeOn = true
		isOn = "On"
		Purge_Message('Purge is '..isOn);
	elseif (command == 'selfon') then
		PurgeSelf = true
		self = "On"
		Purge_Message('Purge: Self Mode is '..self);
	elseif (command == 'selfoff') then
		PurgeSelf = false
		self = "Off"
		Purge_Message('Purge: Self Mode is '..self);
	elseif (command == 'interrupton') then
		InterruptOn = true
		intOn = "On"
		Purge_Message('Purge: Interrupts is '..intOn);
	elseif (command == 'dispelon') then
		DispelOn = true
		disOn = "On"
		Purge_Message('Purge: Dispels is '..disOn);
	elseif (command == 'interruptoff') then
		InterruptOn = false
		intOn = "Off"
		Purge_Message('Purge: Interrupts is '..intOn);
	elseif (command == 'dispeloff') then
		DispelOn = false
		disOn = "Off"
		Purge_Message('Purge: Dispels is '..disOn);
	elseif (command == 'self') then
		PurgeTo = "SELF"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'say') then
		PurgeTo = "SAY"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'yell') then
		PurgeTo = "YELL"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'party') then
		PurgeTo = "PARTY"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'raid') then
		PurgeTo = "INSTANCE_CHAT"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'bg') then
		PurgeTo = "INSTANCE_CHAT"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'instance') then
		PurgeTo = "INSTANCE_CHAT"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'emote') then
		PurgeTo = "EMOTE"
		Purge_Message('Purge output is now on '..PurgeTo);
	elseif (command == 'current') then
		Purge_Message('PurgeOn is '..isOn..' and PurgeTo is '..PurgeTo)
	else
		Purge_Message('Purge commands are /purge (ex: /purge on) -on -off -interrupton (Turns on the interrupt announcer) -interruptoff (And turns it off) -dispelon (Same deal here for the dispel announcer) -dispeloff -self -say -yell -party -raid -bg -instance -emote -current (this tells you your current settings) - selfon (only reports your events) - selfoff; so if you wanted to only display only your dispels, you would type /purge interruptoff and /purge selfon')
	end

end