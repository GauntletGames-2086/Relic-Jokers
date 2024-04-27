--- STEAMODDED HEADER
--- MOD_NAME: Relic Jokers
--- MOD_ID: BlackHoleJokers
--- MOD_AUTHOR: [ItsFlowwey]
--- MOD_DESCRIPTION: Adds Relic Jokers ("Starlight" and "Black Hole")
--- PRIORITY: -1000

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.BlackHoleJokers()
	SMODS.Sprite:new("BlackHole_Jokers", SMODS.findModByID("BlackHoleJokers").path, "BlackHole_Jokers.png", 71, 95, "asset_atli"):register()
	local obj_branches = {
		'Jokers/DarknessChainsYou.lua',
		'Jokers/MarketCrash.lua',
		'Jokers/RiggedDice.lua',
		'Jokers/ForbiddenFruit.lua',
		'Jokers/ShatteredSingularity.lua',
		'Jokers/LetTheForestsBurn.lua',
		'Jokers/StarbornGauntlet.lua',
		'Jokers/GuidingLight.lua',
		'Jokers/PrismaticLightshow.lua',
		'Jokers/HandbookOfElementals.lua',
	}
	G.localization.descriptions.Other.black_hole_joker = {
		name = 'Black Hole Joker',
		text = {
			'+1 Joker slot',
			'Cannot be sold',
			'or destroyed'
		}
	}
	G.localization.descriptions.Other.starlight_joker = {
		name = 'Starlight Joker',
		text = {
			'+1 Joker slot',
			'Cannot be sold',
			'or destroyed'
		}
	}

	local function init_objs()
		for i, v in ipairs(obj_branches) do
			local curr_obj = NFS.load(SMODS.findModByID("BlackHoleJokers").path .. obj_branches[i])()
			curr_obj:register()
		end
	end

	--Custom Joker Rarity Setup
	G.localization.misc.dictionary.k_black_hole = "Black Hole"
	G.localization.misc.dictionary.k_starlight = "Starlight"
	Game:set_globals()
	G.C.RARITY["Starlight"] = HEX('252785')
	G.C.RARITY["Black Hole"] = HEX('0e072e')

	local SMODS_inject_jokers_ref = SMODS.injectJokers
	function SMODS.injectJokers()
		G.P_JOKER_RARITY_POOLS["Black Hole"] = {}
		G.P_JOKER_RARITY_POOLS["Starlight"] = {}
		SMODS_inject_jokers_ref()
	end

	local get_badge_colourref = get_badge_colour
	function get_badge_colour(key)
		local fromRef = get_badge_colourref(key)
	
		if key == 'k_black_hole' then return G.C.RARITY["Black Hole"]
		elseif key == 'k_starlight' then return G.C.RARITY["Starlight"]
		else return fromRef end
	end

	local GUIDEFcard_h_popup_ref = G.UIDEF.card_h_popup
	function G.UIDEF.card_h_popup(card)
		if card.config.center and card.config.center.set == 'Joker' and (card.config.center.rarity == "Black Hole" or card.config.center.rarity == "Starlight") then
			if card.ability_UIBox_table then
				local AUT = card.ability_UIBox_table
				local debuffed = card.debuff
				local card_type_colour = get_type_colour(card.config.center or card.config, card)
				local card_type_background = 
					(AUT.card_type == 'Locked' and G.C.BLACK) or 
					((AUT.card_type == 'Undiscovered') and darken(G.C.JOKER_GREY, 0.3)) or 
					(AUT.card_type == 'Enhanced' or AUT.card_type == 'Default') and darken(G.C.BLACK, 0.1) or
					(debuffed and darken(G.C.BLACK, 0.1)) or 
					(card_type_colour and darken(G.C.BLACK, 0.1)) or
					G.C.SET[AUT.card_type] or
					{0, 1, 1, 1}
		  
				local outer_padding = 0.05
				local card_type = localize('k_'..string.lower(AUT.card_type))
		  
				if AUT.card_type == 'Joker' or (AUT.badges and AUT.badges.force_rarity) then 
					if card.config.center.rarity == "Starlight" then card_type = localize('k_starlight')
					elseif card.config.center.rarity == "Black Hole" then card_type = localize('k_black_hole')
					end
				end
				card_type = (debuffed and AUT.card_type ~= 'Enhanced') and localize('k_debuffed') or card_type
		  
				local disp_type, is_playing_card = 
						  (AUT.card_type ~= 'Locked' and AUT.card_type ~= 'Undiscovered' and AUT.card_type ~= 'Default') or debuffed,
						  AUT.card_type == 'Enhanced' or AUT.card_type == 'Default'
		  
				local info_boxes = {}
				local badges = {}
		  
				if AUT.badges.card_type or AUT.badges.force_rarity then
				  badges[#badges + 1] = create_badge(((card.ability.name == 'Pluto' or card.ability.name == 'Ceres' or card.ability.name == 'Eris') and localize('k_dwarf_planet')) or (card.ability.name == 'Planet X' and localize('k_planet_q') or card_type),card_type_colour, nil, 1.2)
				end
				if AUT.badges then
				  for k, v in ipairs(AUT.badges) do
					if v == 'negative_consumable' then v = 'negative' end
					badges[#badges + 1] = create_badge(localize(v, "labels"), get_badge_colour(v))
				  end
				end
		  
				if AUT.info then
				  for k, v in ipairs(AUT.info) do
					info_boxes[#info_boxes+1] =
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
					  info_tip_from_rows(v, v.name),
					}}
				  }}
				  end
				end
		  
				return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
				  {n=G.UIT.C, config={align = "cm", func = 'show_infotip',object = Moveable(),ref_table = next(info_boxes) and info_boxes or nil}, nodes={
					{n=G.UIT.R, config={padding = outer_padding, r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.5), emboss = 0.07}, nodes={
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = adjust_alpha(card_type_background, 0.8)}, nodes={
						name_from_rows(AUT.name, is_playing_card and G.C.WHITE or nil),
						desc_from_rows(AUT.main),
						badges[1] and {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=badges} or nil,
					  }}
					}}
				  }},
				}}
			end
		else
			return GUIDEFcard_h_popup_ref(card)
		end
	end

	local get_current_pool_ref = get_current_pool
	function get_current_pool(_type, _rarity, _legendary, _append)
		if _type == 'Joker' and (_rarity == "Black Hole" or _rarity == "Starlight") then
			--create the pool
			G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
			local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, nil, '', 0
		
			if _type == 'Joker' then 
				local rarity = _rarity or pseudorandom('rarity'..G.GAME.round_resets.ante..(_append or ''))
				rarity = _rarity
				_starting_pool, _pool_key = G.P_JOKER_RARITY_POOLS[rarity], 'Joker'..rarity..((not _legendary and _append) or '')
			else _starting_pool, _pool_key = G.P_CENTER_POOLS[_type], _type..(_append or '')
			end
		
			--cull the pool
			for k, v in ipairs(_starting_pool) do
				local add = nil
				if _type == 'Enhanced' then
					add = true
				elseif _type == 'Demo' then
					if v.pos and v.config then add = true end
				elseif _type == 'Tag' then
					if (not v.requires or (G.P_CENTERS[v.requires] and G.P_CENTERS[v.requires].discovered)) and 
					(not v.min_ante or v.min_ante <= G.GAME.round_resets.ante) then
						add = true
					end
				elseif not (G.GAME.used_jokers[v.key] and not next(find_joker("Showman"))) and
					(v.unlocked ~= false or v.rarity == 4) then
					if v.set == 'Voucher' then
						if not G.GAME.used_vouchers[v.key] then 
							local include = true
							if v.requires then 
								for kk, vv in pairs(v.requires) do
									if not G.GAME.used_vouchers[vv] then 
										include = false
									end
								end
							end
							if G.shop_vouchers and G.shop_vouchers.cards then
								for kk, vv in ipairs(G.shop_vouchers.cards) do
									if vv.config.center.key == v.key then include = false end
								end
							end
							if include then
								add = true
							end
						end
					elseif v.set == 'Planet' then
						if (not v.config.softlock or G.GAME.hands[v.config.hand_type].played > 0) then
							add = true
						end
					elseif v.enhancement_gate then
						add = nil
						for kk, vv in pairs(G.playing_cards) do
							if vv.config.center.key == v.enhancement_gate then
								add = true
							end
						end
					else
						add = true
					end
					if v.name == 'Black Hole' or v.name == 'The Soul' then
						add = false
					end
				end

				if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = nil end
				if v.yes_pool_flag and not G.GAME.pool_flags[v.yes_pool_flag] then add = nil end
				
				if add and not G.GAME.banned_keys[v.key] then 
					_pool[#_pool + 1] = v.key
					_pool_size = _pool_size + 1
				else
					_pool[#_pool + 1] = 'UNAVAILABLE'
				end
			end

			--if pool is empty
			if _pool_size == 0 then
				_pool = EMPTY(G.ARGS.TEMP_POOL)
				if _type == 'Tarot' or _type == 'Tarot_Planet' then _pool[#_pool + 1] = "c_strength"
				elseif _type == 'Planet' then _pool[#_pool + 1] = "c_pluto"
				elseif _type == 'Spectral' then _pool[#_pool + 1] = "c_incantation"
				elseif _type == 'Joker' then _pool[#_pool + 1] = "j_joker"
				elseif _type == 'Demo' then _pool[#_pool + 1] = "j_joker"
				elseif _type == 'Voucher' then _pool[#_pool + 1] = "v_blank"
				elseif _type == 'Tag' then _pool[#_pool + 1] = "tag_handy"
				else _pool[#_pool + 1] = "j_joker"
				end
			end

			return _pool, _pool_key..(not _legendary and G.GAME.round_resets.ante or '')
		end
		return get_current_pool_ref(_type, _rarity, _legendary, _append)
	end

	local Cardadd_to_deck_ref = Card.add_to_deck
	function Card:add_to_deck(from_debuff)
		if not self.added_to_deck then
			if self.ability.set == 'Joker' then 
				if (self.config.center.rarity == "Black Hole" or self.config.center.rarity == "Starlight") and not from_debuff then
					G.jokers.config.card_limit = G.jokers.config.card_limit + 1
					G.GAME.black_hole_jokers.spawned = false
					G.GAME.black_hole_jokers.applied = false
				end
				if self.ability.name == 'Market Crash' then
					ease_dollars(self.ability.extra.money_gain)
				end
			end
		end
		Cardadd_to_deck_ref(self, from_debuff)
	end

	local Cardremove_from_deck_ref = Card.remove_from_deck
	function Card:remove_from_deck(from_debuff)
		if self.added_to_deck then
			if self.ability.set == 'Joker' and (self.config.center.rarity == "Black Hole" or self.config.center.rarity == "Starlight") and not from_debuff then
				G.jokers.config.card_limit = G.jokers.config.card_limit - 1
			end
		end
		Cardremove_from_deck_ref(self, from_debuff)
	end

	local Cardset_eternal_ref = Card.set_eternal
	function Card:set_eternal(_eternal)
		if (self.config.center.rarity == "Black Hole" or self.config.center.rarity == "Starlight") then 
			self.ability.eternal = nil
			return 
		end
		Cardset_eternal_ref(self, _eternal)
	end

	local Cardset_perishable_ref = Card.set_perishable
	function Card:set_perishable(_perishable)
		if (self.config.center.rarity == "Black Hole" or self.config.center.rarity == "Starlight") then 
			self.ability.perishable = nil
			return
		end
		Cardset_perishable_ref(self, _perishable)
	end

	local Cardset_rental_ref = Card.set_rental
	function Card:set_rental(_rental)
		if (self.config.center.rarity == "Black Hole" or self.config.center.rarity == "Starlight") then 
			self.ability.rental = nil
			return
		end
		Cardset_rental_ref(self, _rental)
	end

	--Booster Pack Spawn Setup
	local Backapply_to_run_ref = Back.apply_to_run
	function Back:apply_to_run()
		Backapply_to_run_ref(self)
		G.GAME.black_hole_jokers = {
			spawned = true,
			applied = true,
			black_hole_gen = 4,
			starlight_gen = 0
		}
		G.GAME.pool_flags['mod_not_installed'] = true

		for k, v in pairs(SMODS.Jokers) do
			if v.mod_required and not SMODS._INIT_KEYS[v.mod_required] then 
				G.P_CENTERS[v.slug].no_pool_flag = 'mod_not_installed'
			end
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function()
				add_tag(Tag('tag_buffoon'))
				return true
			end)
		  }))
	end

	local Cardopen_ref = Card.open
	function Card:open()
		if G.GAME.black_hole_jokers.spawned == true and self.ability.name:find('Buffoon') and self.cost == 0 then
			self.config.center.config.choose = 1
			G.GAME.black_hole_jokers.applied = true
		end
		Cardopen_ref(self)
		G.P_CENTERS.p_buffoon_mega_1.config.choose = 2
	end

	local Tagapply_to_run_ref = Tag.apply_to_run
	function Tag:apply_to_run(_context)
		if not self.triggered and self.config.type == _context.type then
			if _context.type == 'new_blind_choice' then
				if self.name == 'Buffoon Tag' and G.GAME.black_hole_jokers.spawned == true then
					G.GAME.black_hole_jokers.applied = true
				end
			end
		end
		return Tagapply_to_run_ref(self, _context)
	end

	local create_card_ref = create_card
	function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
		if _type == 'Joker' and key_append == 'buf' and G.GAME.black_hole_jokers.applied == true then
			if G.GAME.black_hole_jokers.starlight_gen > 0 then
				_rarity = "Starlight"
				G.GAME.black_hole_jokers.starlight_gen = G.GAME.black_hole_jokers.starlight_gen - 1
			elseif G.GAME.black_hole_jokers.black_hole_gen > 0 then
				_rarity = "Black Hole"
				G.GAME.black_hole_jokers.black_hole_gen = G.GAME.black_hole_jokers.black_hole_gen - 1
			end
		end
		local _card =  create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
		if _card.ability.consumeable and next(find_joker('Prismatic Lightshow')) then
			local edition = poll_edition('lightshow', nil, true, true)
			_card:set_edition(edition)
			check_for_unlock({type = 'have_edition'})
		end
		return _card
	end

	local create_UIBox_buffoon_pack_ref = create_UIBox_buffoon_pack
	function create_UIBox_buffoon_pack()
		local orig_create_UIBox_buffoon_pack = create_UIBox_buffoon_pack_ref()
		if G.GAME.black_hole_jokers.applied == true then
			local _size = G.GAME.pack_size
			G.pack_cards = CardArea(
			  G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
			  _size*G.CARD_W*1.1,
			  1.05*G.CARD_H, 
			  {card_limit = _size, type = 'consumeable', highlight_limit = 1})
		  
			  local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
				  {n=G.UIT.R, config={align = "cm"}, nodes={
				  {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
					{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
					  {n=G.UIT.O, config={object = G.pack_cards}},
					}}
				  }}
				}},
				{n=G.UIT.R, config={align = "cm"}, nodes={
				}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
				  {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
				  {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
				  UIBox_dyn_container({
					{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
					  {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
						{n=G.UIT.O, config={object = DynaText({string = localize('k_buffoon_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
					  }},
					  {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
						{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
						{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
					  }},
					}}
				  }),
				}},
				  {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
					{n=G.UIT.R,config={minh =0.2}, nodes={}}
				  }}
				}}
			  }}
			}}
			return t
		end
		return orig_create_UIBox_buffoon_pack
	end

	local GUIDEFuse_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
	function G.UIDEF.use_and_sell_buttons(card)
		local orig_use_and_sell_buttons = GUIDEFuse_and_sell_buttons_ref(card)
		if card.config.center.rarity == "Black Hole" or card.config.center.rarity == "Starlight" then
			if card.area and card.area == G.pack_cards then
				return {
				n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
					{n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_card'}, nodes={
					{n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
					}},
				}}
			end
			local t = {
				n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
				  {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
					{n=G.UIT.R, config={align = 'cl'}, },
					{n=G.UIT.R, config={align = 'cl'}, nodes={
					  use
					}},
				  }},
			  }}
			return t
		end
		return orig_use_and_sell_buttons
	end

	local Cardstart_dissolve_ref = Card.start_dissolve
	function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
		if (self.config.center.rarity ~= "Starlight" or self.config.center.rarity ~= "Black Hole") then Cardstart_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice) end
	end

	local Blinddefeat_ref = Blind.defeat
	function Blind:defeat(silent)
		if self:get_type() == "Boss" and (G.GAME.round_resets.ante == 5 or G.GAME.round_resets.ante == G.GAME.win_ante+1) then
			G.GAME.black_hole_jokers = {
				spawned = true,
				applied = false,
				black_hole_gen = 2,
				starlight_gen = 2
			}
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = (function()
					add_tag(Tag('tag_buffoon'))
					return true
				end)
			  }))
		end
		Blinddefeat_ref(self, silent)
	end

	local GFUNCScan_select_card_ref = G.FUNCS.can_select_card
	G.FUNCS.can_select_card = function(e)
		if e.config.ref_table.ability.set == 'Joker' and (e.config.ref_table.config.center.rarity == "Starlight" or e.config.ref_table.config.center.rarity == "Black Hole") then 
			e.config.colour = G.C.GREEN
			e.config.button = 'use_card'
		else
			GFUNCScan_select_card_ref(e)
		end
	end

	init_objs()
	init_localization()
end

----------------------------------------------
------------MOD CODE END----------------------