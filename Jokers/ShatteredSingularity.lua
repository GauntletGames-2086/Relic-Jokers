local shattered_singularity_txt = { -- Shattered Singularity
	["name"] = "Shattered Singularity",
	["text"] = {
		"{C:planet}Planet{} cards level up hands",
		"{C:attention}3{} times instead of one",
		"Each time a hand is played",
		"decrease level of every {C:legendary,E:1}poker hand",
		"by 1 except {C:attention}played hand"
	}
}

local shattered_singularity = SMODS.Joker:new(
	"Shattered Singularity", --name
	"shattered_singularity", --slug
	{}, --config
	{x = 0, y = 0}, --spritePos
	shattered_singularity_txt, --loc_txt
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

function shattered_singularity.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
end

shattered_singularity.calculate = function(self, context)
	if not context.blueprint then
		if context.cardarea == G.jokers and context.before then
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				self:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = true
				return true end }))
			update_hand_text({delay = 0}, {mult = '-', StatusText = true})
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				self:juice_up(0.8, 0.5)
				return true end }))
			update_hand_text({delay = 0}, {chips = '-', StatusText = true})
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				self:juice_up(0.8, 0.5)
				G.TAROT_INTERRUPT_PULSE = nil
				return true end }))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='-1'})
			delay(1.3)
			for k, v in pairs(G.GAME.hands) do
				if k ~= context.scoring_name then level_up_hand(self, k, true, -1) end
			end
			local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips, handname = context.scoring_name, level = G.GAME.hands[text].level})
		end
	end
end

local Card_use_consumeable_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
	if self.ability.consumeable.hand_type and next(find_joker('Shattered Singularity')) then
		stop_use()
		if not copier then set_consumeable_usage(self) end
		if self.debuff then return nil end
		local used_tarot = copier or self
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(self.ability.consumeable.hand_type, 'poker_hands'),chips = G.GAME.hands[self.ability.consumeable.hand_type].chips, mult = G.GAME.hands[self.ability.consumeable.hand_type].mult, level=G.GAME.hands[self.ability.consumeable.hand_type].level})
        level_up_hand(used_tarot, self.ability.consumeable.hand_type, nil, 3)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
	else
		Card_use_consumeable_ref(self, area, copier)
	end
end

return shattered_singularity