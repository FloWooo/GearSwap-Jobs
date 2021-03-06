-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
function get_sets()
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Called when this job file is unloaded (eg: job change)
function file_unload()
	if binds_on_unload then
		binds_on_unload()
	end

	send_command('unbind ^`')
	send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	-- Default macro set/book
	set_macro_page(2, 5)
	
	-- Additional local binds
	send_command('bind ^` input /ja "Flee" <me>')
	send_command('bind ^= gs c cycle treasuremode')
	send_command('bind !- gs c cycle targetmode')


	-- Options: Override default values
	options.OffenseModes = {'Normal', 'Acc'}
	options.DefenseModes = {'Normal', 'Evasion', 'PDT'}
	options.RangedModes = {'Normal', 'TH', 'Acc'}
	options.WeaponskillModes = {'Normal', 'Acc', 'Att', 'Mod'}
	options.IdleModes = {'Normal'}
	options.RestingModes = {'Normal'}
	options.PhysicalDefenseModes = {'Evasion', 'PDT'}
	options.MagicalDefenseModes = {'MDT'}

	state.RangedMode = 'TH'
	state.Defense.PhysicalMode = 'Evasion'
	
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false
	
	-- TH mode handling
	options.TreasureModes = {'None','Tag','SATA','Fulltime'}
	state.TreasureMode = 'Tag'

	tag_with_th = false	
	tp_on_engage = 0
	
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	sets.TreasureHunter = {hands="Assassin's Armlets +2", feet="Raider's Poulaines +2"}
	
	-- Precast Sets
	
	-- Precast sets to enhance JAs
	sets.precast.JA['Collaborator'] = {head="Raider's Bonnet +2"}
	sets.precast.JA['Accomplice'] = {head="Raider's Bonnet +2"}
	sets.precast.JA['Flee'] = {feet="Pillager's Poulaines"}
	sets.precast.JA['Hide'] = {body="Pillager's Vest +1"}
	sets.precast.JA['Conspirator'] = {} -- {body="Raider's Vest +2"}
	sets.precast.JA['Steal'] = {head="Assassin's Bonnet +2",hands="Pillager's Armlets +1",legs="Pillager's Culottes",feet="Pillager's Poulaines"}
	sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Raider's Poulaines +2"}
	sets.precast.JA['Perfect Dodge'] = {hands="Assassin's Armlets +2"}
	sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}
	

	sets.precast.JA['Sneak Attack'] = {ammo="Qirmiz Tathlum",
		head="Whirlpool Mask",neck="Moepapa Medal",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Pillager's Vest +1",hands="Raider's Armlets +2",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Atheling Mantle",waist="Twilight Belt",legs="Manibozho Brais",feet="Iuitl Gaiters"}

	sets.precast.JA['Trick Attack'] = {ammo="Qirmiz Tathlum",
		head="Whirlpool Mask",neck="Moepapa Medal",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Pillager's Vest +1",hands="Pillager's Armlets +1",ring1="Stormsoul Ring",ring2="Epona's Ring",
		back="Atheling Mantle",waist="Patentia Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters"}


	-- Waltz set (chr and vit)
	sets.precast.Waltz = {ammo="Sonia's Plectrum",
		head="Whirlpool Mask",
		body="Iuitl Vest",hands="Buremte Gloves",
		back="Iximulew Cape",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
	
	-- Fast cast sets for spells
	
	sets.precast.FC = {head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves",ring1="Prolix Ring",legs="Enif Cosciales"}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


	-- Ranged snapshot gear
	sets.precast.RangedAttack = {head="Aurore Beret",hands="Iuitl Wristbands",legs="Nahtirah Trousers",feet="Wurrukatte Boots"}

       
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	gear.default.weaponskill_neck = "Asperity Necklace"
	gear.default.weaponskill_waist = "Caudata Belt"
	sets.precast.WS = {ammo="Thew Bomblet",
		head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Pillager's Vest +1",hands="Pillager's Armlets +1",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Atheling Mantle",waist="Caudata Belt",legs="Manibozho Brais",feet="Iuitl Gaiters"}
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum", back="Letalis Mantle"})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {neck="Moepapa Medal",ring1="Stormsoul Ring",
		legs="Nahtirah Trousers"})
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'], {waist=gear.ElementalBelt})
	sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget})
	sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget})
	sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget})

	sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {neck="Soil Gorget"})
	sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {waist=gear.ElementalBelt})
	sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum",neck="Moepapa Medal"})
	sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum",neck="Moepapa Medal"})
	sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum",neck="Moepapa Medal"})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Qirmiz Tathlum",neck="Rancor Collar",
		ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'], {waist=gear.ElementalBelt})
	sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {neck="Moepapa Medal"})
	sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {neck="Moepapa Medal"})
	sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {neck="Moepapa Medal"})

	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {neck="Moepapa Medal",
		ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"], {waist=gear.ElementalBelt})
	sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})
	sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})
	sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})

	sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,
		ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {waist=gear.ElementalBelt})
	sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget})
	sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})
	sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})

	sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {neck=gear.ElementalGorget,
		ear1="Brutal Earring",ear2="Moonshade Earring"})
	sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Honed Tathlum", back="Letalis Mantle"})
	sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {waist=gear.ElementalBelt})
	sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget})
	sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})
	sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Qirmiz Tathlum",neck=gear.ElementalGorget,
		body="Pillager's Vest"})

	sets.precast.WS['Aeolian Edge'] = {ammo="Jukukik Feather",
		head="Thaumas Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Manibozho Jerkin",hands="Pillager's Armlets +1",ring1="Rajas Ring",ring2="Demon's Ring",
		back="Toro Cape",waist="Thunder Belt",legs="Iuitl Tights",feet="Iuitl Gaiters"}
	
	
	-- Midcast Sets
	
	sets.midcast.FastRecast = {
		head="Whirlpool Mask",ear2="Loquacious Earring",
		body="Iuitl Vest",hands="Pillager's Armlets +1",
		back="Ik Cape",waist="Twilight Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}
		
	-- Specific spells
	sets.midcast.Utsusemi = {
		head="Whirlpool Mask",neck="Torero Torque",ear2="Loquacious Earring",
		body="Iuitl Vest",hands="Pillager's Armlets +1",ring1="Beeline Ring",
		back="Ik Cape",waist="Twilight Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}

	-- Ranged gear -- acc + TH
	sets.midcast.RangedAttack = {
		head="Whirlpool Mask",neck="Peacock Charm",
		body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Hajduk Ring",
		back="Libeccio Mantle",waist="Aquiline Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}

	sets.midcast.RangedAttack.TH = {
		head="Pillager's Bonnet",neck="Peacock Charm",
		body="Iuitl Vest",hands="Assassin's Armlets +2",ring1="Beeline Ring",ring2="Hajduk Ring",
		back="Libeccio Mantle",waist="Aquiline Belt",legs="Nahtirah Trousers",feet="Raider's Poulaines +2"}

	sets.midcast.RangedAttack.Acc = {
		head="Pillager's Bonnet",neck="Peacock Charm",
		body="Iuitl Vest",hands="Buremte Gloves",ring1="Beeline Ring",ring2="Hajduk Ring",
		back="Libeccio Mantle",waist="Aquiline Belt",legs="Thurandaut Tights +1",feet="Pillager's Poulaines"}
	
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
		ring1="Sheltered Ring",ring2="Paguroidea Ring"}
	

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle.Town = {main="Izhiikoh", sub="Atoyac",ammo="Thew Bomblet",
		head="Whirlpool Mask",neck="Wiglen Gorget",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Iuitl Vest",hands="Pillager's Armlets +1",ring1="Sheltered Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Patentia Sash",legs="Nahtirah Trousers",feet="Skadi's Jambeaux +1"}
	
	sets.idle.Field = {ammo="Thew Bomblet",
		head="Whirlpool Mask",neck="Wiglen Gorget",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Iuitl Vest",hands="Pillager's Armlets +1",ring1="Sheltered Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Nahtirah Trousers",feet="Skadi's Jambeaux +1"}

	sets.idle.Weak = {ammo="Thew Bomblet",
		head="Whirlpool Mask",neck="Wiglen Gorget",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Manibozho Jerkin",hands="Buremte Gloves",ring1="Sheltered Ring",ring2="Paguroidea Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Nahtirah Trousers",feet="Skadi's Jambeaux +1"}
	
	sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}

	-- Defense sets

	sets.defense.Evasion = {
		head="Whirlpool Mask",neck="Torero Torque",
		body="Iuitl Vest",hands="Pillager's Armlets +1",ring1="Beeline Ring",ring2="Dark Ring",
		back="Ik Cape",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}

	sets.defense.PDT = {ammo="Iron Gobbet",
		head="Whirlpool Mask",neck="Twilight Torque",
		body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Dark Ring",
		back="Iximulew Cape",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}

	sets.defense.MDT = {ammo="Demonry Stone",
		head="Whirlpool Mask",neck="Twilight Torque",
		body="Pillager's Vest +1",hands="Pillager's Armlets +1",ring1="Dark Ring",ring2="Shadow Ring",
		back="Engulfer Cape",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters"}

	sets.Kiting = {feet="Skadi's Jambeaux +1"}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {ammo="Thew Bomblet",
		head="Felistris Mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Thaumas Coat",hands="Pillager's Armlets +1",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Atheling Mantle",waist="Patentia Sash",legs="Manibozho Brais",feet="Manibozho Boots"}
	sets.engaged.Acc = {ammo="Honed Tathlum",
		head="Whirlpool Mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Thaumas Coat",hands="Pillager's Armlets +1",ring1="Rajas Ring",ring2="Epona's Ring",
		back="Letalis Mantle",waist="Hurch'lan Sash",legs="Manibozho Brais",feet="Manibozho Boots"}
	sets.engaged.Evasion = {ammo="Thew Bomblet",
		head="Felistris Mask",neck="Torero Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Iuitl Vest",hands="Pillager's Armlets +1",ring1="Beeline Ring",ring2="Epona's Ring",
		back="Ik Cape",waist="Patentia Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters"}
	sets.engaged.Acc.Evasion = {ammo="Honed Tathlum",
		head="Whirlpool Mask",neck="Torero Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Manibozho Jerkin",hands="Pillager's Armlets +1",ring1="Beeline Ring",ring2="Epona's Ring",
		back="Letalis Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters"}
	sets.engaged.PDT = {ammo="Thew Bomblet",
		head="Felistris Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Dark Ring",ring2="Epona's Ring",
		back="Iximulew Cape",waist="Patentia Sash",legs="Iuitl Tights",feet="Iuitl Gaiters"}
	sets.engaged.Acc.PDT = {ammo="Honed Tathlum",
		head="Whirlpool Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
		body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Dark Ring",ring2="Epona's Ring",
		back="Letalis Mantle",waist="Hurch'lan Sash",legs="Iuitl Tights",feet="Iuitl Gaiters"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'Step' or spell.type == 'Flourish1' then
		if state.TreasureMode ~= 'None' then
			equip(sets.TreasureHunter)
		end
	elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
		if state.TreasureMode == 'SATA' or state.TreasureMode == 'Fulltime' or tag_with_th then
			equip(sets.TreasureHunter)
		end
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	-- Update the state of certain buff JAs if the action wasn't interrupted.
	if not spell.interrupted then
		if state.Buff[spell.name] ~= nil then
			state.Buff[spell.name] = true
		end
		
		-- Don't let aftercast revert gear set for SA/TA/Feint
		if S{'Sneak Attack', 'Trick Attack', 'Feint'}:contains(spell.english) then
			eventArgs.handled = true
		end
		
		-- If this wasn't an action that would have used up SATA/Feint, make sure to put gear back on.
		if spell.type:lower() ~= 'weaponskill' and spell.type:lower() ~= 'step' then
			-- If SA/TA/Feint are active, put appropriate gear back on (including TH gear).
			if state.Buff['Sneak Attack'] then
				equip(sets.precast.JA['Sneak Attack'])
				if state.TreasureMode == 'SATA' or state.TreasureMode == 'Fulltime' or tag_with_th then
					equip(sets.TreasureHunter)
				end
				eventArgs.handled = true
			elseif state.Buff['Trick Attack'] then
				equip(sets.precast.JA['Trick Attack'])
				if state.TreasureMode == 'SATA' or state.TreasureMode == 'Fulltime' or tag_with_th then
					equip(sets.TreasureHunter)
				end
				eventArgs.handled = true
			elseif state.Buff['Feint'] then
				equip(sets.precast.JA['Feint'])
				if state.TreasureMode == 'SATA' or state.TreasureMode == 'Fulltime' or tag_with_th then
					equip(sets.TreasureHunter)
				end
				eventArgs.handled = true
			end
		end
		
		if spell.target and spell.target.type == 'Enemy' then
			tag_with_th = false
			tp_on_engage = 0
		elseif (spell.type == 'Waltz' or spell.type == 'Samba') and tag_with_th then
			-- Update current TP if we spend TP before we actually hit the mob
			tp_on_engage = player.tp
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets construction.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, action, spellMap)
	local wsmode = ''
	if state.Buff['Sneak Attack'] then
		wsmode = 'SA'
	end
	if state.Buff['Trick Attack'] then
		wsmode = wsmode .. 'TA'
	end
	
	if wsmode ~= '' then
		return wsmode
	end
end

function customize_idle_set(idleSet)
	if player.hpp < 80 then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end
	
	return idleSet
end

function customize_melee_set(meleeSet)
	if state.TreasureMode == 'Fulltime' or tag_with_th then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
	check_range_lock()
	
	-- If engaging, put on TH gear.
	-- If disengaging, turn off TH tagging.
	if newStatus == 'Engaged' and state.TreasureMode ~= 'None' then
		equip(sets.TreasureHunter)
		tag_with_th = true
		tp_on_engage = player.tp
		send_command('wait 3;gs c update th')
	elseif oldStatus == 'Engaged' then
		tag_with_th = false
		tp_on_engage = 0
	end

	-- If SA/TA/Feint are active, don't change gear sets
	if satafeint_active() then
		eventArgs.handled = true
	end
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
		state.Buff[buff] = gain

		if not satafeint_active() then
			handle_equipping_gear(player.status)
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
-- Hooks for TH mode handling.
-------------------------------------------------------------------------------------------------------------------

-- Request job-specific mode tables.
-- Return true on the third returned value to indicate an error: that we didn't recognize the requested field.
function job_get_mode_list(field)
	if field == 'Treasure' then
		return options.TreasureModes, state.TreasureMode
	end
end

-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_mode(field, val)
	if field == 'Treasure' then
		state.TreasureMode = val
		return true
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	check_range_lock()

	if state.TreasureMode == 'None' then
		tag_with_th = false
		tp_on_engage = 0
	elseif tag_with_th and player.tp ~= tp_on_engage then
		tag_with_th = false
		tp_on_engage = 0
	elseif cmdParams[1] == 'th' and player.status == 'Engaged' then
		send_command('wait 3;gs c update th')
	end
	
	-- Update the current state of state.Buff, in case buff_change failed
	-- to update the value.
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false

	-- Don't allow normal gear equips if SA/TA/Feint is active.
	if satafeint_active() then
		eventArgs.handled = true
	end
end


-- Handle notifications of general user state change.
function job_state_change(stateField, newValue)
	if stateField == 'TreasureMode' then
		local prevRangedMode = state.RangedMode
		
		if newValue == 'Tag' or newValue == 'SATA' then
			state.RangedMode = 'TH'
		elseif state.OffenseMode == 'Acc' then
			state.RangedMode = 'Acc'
		else
			state.RangedMode = 'Normal'
		end
		
		if state.RangedMode ~= prevRangedMode then
			add_to_chat(121,'Ranged mode is now '..state.RangedMode)
		end
	elseif stateField == 'OffenseMode' then
		if state.TreasureMode == 'None' or state.TreasureMode == 'Fulltime' then
			local prevRangedMode = state.RangedMode

			if newValue == 'Acc' then
				state.RangedMode = 'Acc'
			else
				state.RangedMode = 'Normal'
			end
			
			if state.RangedMode ~= prevRangedMode then
				add_to_chat(121,'Ranged mode is now '..state.RangedMode)
			end
		end
	elseif stateField == 'Reset' then
		state.RangedMode = 'TH'
	end
end


-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local defenseString = ''
	if state.Defense.Active then
		local defMode = state.Defense.PhysicalMode
		if state.Defense.Type == 'Magical' then
			defMode = state.Defense.MagicalMode
		end

		defenseString = 'Defense: '..state.Defense.Type..' '..defMode..'  '
	end
	
	add_to_chat(122,'Melee: '..state.OffenseMode..'/'..state.DefenseMode..'  WS: '..state.WeaponskillMode..'  '..
		defenseString..'Kiting: '..on_off_names[state.Kiting]..'  TH: '..state.TreasureMode)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
	if player.equipment.range ~= 'empty' then
		disable('range', 'ammo')
	else
		enable('range', 'ammo')
	end
end

-- Function to indicate if any buffs have been activated that we don't want to equip gear over.
function satafeint_active()
	return state.Buff['Sneak Attack'] or state.Buff['Trick Attack'] or state.Buff['Feint']
end

