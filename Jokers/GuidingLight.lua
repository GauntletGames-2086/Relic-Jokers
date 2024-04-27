local guiding_light_txt = { -- Darkness Chains You
	["name"] = "Guiding Light",
	["text"] = {
		"Earn {C:money}$#1#{} at",
		"end of round",
		"for each {C:attention}Joker{} card",
		"{C:inactive}Excludes Relic Jokers",
		"{C:inactive}(Currently {C:money}$#2#{C:inactive})"
	}
}

local guiding_light = SMODS.Joker:new(
	"Guiding Light", --name
	"guiding_light", --slug
	{extra = {money_gain = 2}}, --config
	{x = 0, y = 0}, --spritePos
	guiding_light_txt, --loc_txt
	"Starlight", --rarity
	10, --cost
	true, --unlocked
	true, --discovered
	false, --blueprint_compat
	false, --eternal_compat
	'', --effect
	'BlackHole_Jokers', --atlas
	nil --soul_pos
)

function guiding_light.loc_def(center)
	if center.ability.name == 'Guiding Light' then
		local x = 0
		if G.jokers and G.jokers.cards then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' and not (G.jokers.cards[i].config.center.rarity == "Starlight" or G.jokers.cards[i].config.center.rarity == "Black Hole") then x = x + 1 end
			end
		end
		return {center.ability.extra.money_gain, x*center.ability.extra.money_gain}
	end
end

function guiding_light.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'starlight_joker'}
end

local CardCalc_dollar_bonus_ref = Card.calculate_dollar_bonus
function Card:calculate_dollar_bonus()
	
	if not self.debuff and self.ability.name == 'Guiding Light' then
		local x = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.set == 'Joker' and not (G.jokers.cards[i].config.center.rarity == "Starlight" or G.jokers.cards[i].config.center.rarity == "Black Hole") then x = x + 1 end
		end
		return x*self.ability.extra.money_gain
	end
	return CardCalc_dollar_bonus_ref(self)
end

return guiding_light