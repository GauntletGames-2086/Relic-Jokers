local rigged_dice_txt = {
	["name"] = "Rigged Dice",
	["text"] = {
		"At the start of a blind",
		"roll two {C:attention}6-sided{} dice",
		"Effect for this joker are determined",
		"by the dice roll",
		"{C:inactive}Currently roll: {C:attention}#1#{C:inactive})"
	}
}

local rigged_dice = SMODS.Joker:new(
	"Rigged Dice", --name
	"rigged_dice", --slug
	{extra = {roll_outcome = 12, xmult = 1.5, dice_pity = true}}, --config
	{x = 0, y = 0}, --spritePos
	rigged_dice_txt, --loc_txt
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

G.localization.misc.v_dictionary.dice_roll = "Rolled a #1#"
G.localization.misc.dictionary.k_jackpot = "Jackpot!"
G.localization.misc.dictionary.k_snake_eyes = "Snake Eyes!"
G.localization.misc.dictionary.k_ignored = "Ignored!"
G.localization.descriptions.Other.jackpot = {
	name = 'Jackpot!',
	text = {
		'Required Roll: {C:attention}12',
		'All jokers give {X:mult,C:white}1.5X{} Mult',
	}
}
G.localization.descriptions.Other.snake_eyes = {
	name = 'Snake Eyes',
	text = {
		'Required Roll: {C:attention}2',
		'{C:green}1 in 2{} for',
		'a joker to not score'
	}
}
G.localization.descriptions.Other.high_roll = {
	name = 'High Roll',
	text = {
		'Required Roll: {C:attention}8-11',
		'Add {C:red}Mult{} based on',
		'{C:attention}roll * 2'
	}
}
G.localization.descriptions.Other.low_roll = {
	name = 'Low Roll',
	text = {
		'Required Roll: {C:attention}3-7',
		'Lose {C:red}Mult{} based on',
		'{C:attention}(12 - roll) * 2'
	}
}

function rigged_dice.loc_def(center)
	if center.ability.name == 'Rigged Dice' then
		return {center.ability.extra.roll_outcome}
	end
end

function rigged_dice.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
	info_queue[#info_queue+1] = {set = 'Other', key = 'jackpot'}
	info_queue[#info_queue+1] = {set = 'Other', key = 'high_roll'}
	info_queue[#info_queue+1] = {set = 'Other', key = 'low_roll'}
	info_queue[#info_queue+1] = {set = 'Other', key = 'snake_eyes'}
end

local Cardcalculate_joker = Card.calculate_joker
function Card:calculate_joker(context)
	if next(find_joker('Rigged Dice')) then
		for k, v in pairs(G.jokers.cards) do
			if v.ability.name == 'Rigged Dice' and v.ability.extra.roll_outcome == 2 and (SMODS.end_calculate_context(context) or (context.individual and (context.cardarea == G.play or context.cardarea == G.hand)) or context.other_joker) and context.first_pass ~= false then
				context.first_pass = false
				local joker_calc = self:calculate_joker(context)
				if joker_calc then
					snake_eyes_chance = pseudoseed('rigged_dice_snake_eyes')
					if snake_eyes_chance > 0.5 then
						if context.individual and context.cardarea == G.play and not joker_calc.extra.message == localized('k_upgrade') then
							return {
								extra = {message = localize('k_ignored'), colour = G.C.RED},
								colour = G.C.RED,
								card = self
							}
						elseif (context.individual and context.cardarea == G.hand) then
							return {
								message = localize('k_ignored'),
								colour = G.C.RED,
								card = self,
							}
						else
							return {
								message = localize('k_ignored')
							}
						end
					end
				end
			end
		end
	end
	return Cardcalculate_joker(self, context)
end

local mod_mult_ref = mod_mult
function mod_mult(_mult)
	if _mult < 0 then _mult = 1 end
	return mod_mult_ref(_mult)
end

rigged_dice.calculate = function(self, context)
	if not context.blueprint then
		if context.setting_blind and not self.getting_sliced then
			local dice_roll_1 = pseudorandom_element({1, 2, 3, 4, 5, 6}, pseudoseed('rigged_dice_roll_1'))
			local dice_roll_2 = pseudorandom_element({1, 2, 3, 4, 5, 6}, pseudoseed('rigged_dice_roll_2'))
			self.ability.extra.roll_outcome = dice_roll_1 + dice_roll_2
			if self.ability.extra.roll_outcome == 12 then
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_jackpot')})
			elseif self.ability.extra.roll_outcome == 2 then
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_snake_eyes')})
			else
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'dice_roll', vars = {self.ability.extra.roll_outcome}}})
			end
		elseif context.other_joker and self.ability.extra.roll_outcome == 12 and self ~= context.other_joker then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				message = localize{type='variable',key='a_xmult',vars={self.ability.extra.xmult}},
				Xmult_mod = self.ability.extra.xmult
			}
		elseif SMODS.end_calculate_context(context) then
			if self.ability.extra.roll_outcome ~= 12 and self.ability.extra.roll_outcome >= 8 then
				local add_mult = self.ability.extra.roll_outcome*2
				return {
					message = localize{type='variable',key='a_mult',vars={add_mult}},
					mult_mod = add_mult
				}
			elseif self.ability.extra.roll_outcome ~= 2 and self.ability.extra.roll_outcome <= 7 then
				local minus_mult = (12-self.ability.extra.roll_outcome)*2
				return {
					message = localize{type='variable',key='a_mult_minus',vars={minus_mult}},
					mult_mod = -minus_mult
				}
			end
		end
	end
end

return rigged_dice