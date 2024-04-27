local forbidden_fruit_txt = {
	["name"] = "Forbidden Fruit",
	["text"] = {
		"Create a {C:spectral}Spectral{} card",
		"when {C:attention}Blind{} is selected",
		"Blind size increased by {C:attention}#1#X",
		"Increases by {C:attention}#2#X per",
		"{C:spectral}Spectral{} card used",
		"{C:inactive}(Must have room)"
	}
}

local forbidden_fruit = SMODS.Joker:new(
	"Forbidden Fruit", --name
	"forbidden_fruit", --slug
	{extra = {curr_blind_size = 1, blind_size_buff = 0.5}}, --config
	{x = 0, y = 0}, --spritePos
	forbidden_fruit_txt, --loc_txt
	"Black Hole", --rarity
	10, --cost
	true, --unlocked
	true, --discovered
	false, --blueprint_compat
	false, --eternal_compat
	'', --effect
	'BlackHole_Jokers', --atlas
	nil --soul_pos
)

G.localization.misc.v_dictionary.add_blind_size = "#1#X Blind Size"

function forbidden_fruit.loc_def(center)
	if center.ability.name == 'Forbidden Fruit' then
		return {center.ability.extra.curr_blind_size, center.ability.extra.blind_size_buff}
	end
end

function forbidden_fruit.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
end

forbidden_fruit.calculate = function(self, context)
	if not context.blueprint then
		if context.setting_blind and not self.getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.blind.chips = G.GAME.blind.chips*self.ability.extra.curr_blind_size
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = (function()
					G.E_MANAGER:add_event(Event({
						func = function() 
							local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'forbidden_fruit')
							card:add_to_deck()
							G.consumeables:emplace(card)
							G.GAME.consumeable_buffer = 0
							return true
						end}))
						card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
					return true
				end
			)}))
		end
		if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Spectral' then
			self.ability.extra.curr_blind_size = self.ability.extra.curr_blind_size + self.ability.extra.blind_size_buff
			G.E_MANAGER:add_event(Event({
				func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='add_blind_size',vars={self.ability.extra.curr_blind_size}}, colour = G.C.SECONDARY_SET.Spectral}); return true
				end}))
			return
		end
	end
end

return forbidden_fruit
