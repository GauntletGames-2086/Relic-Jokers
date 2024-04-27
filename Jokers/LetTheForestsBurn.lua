local let_the_forests_burn_txt = {
	["name"] = "Let The Forests Burn",
	["text"] = {
		"{X:mult,C:white}X#1#{} Mult per",
		"{C:clubs}Club{} card in deck",
		"Played or discarded {C:clubs}Club",
		"cards are {C:attention}destroyed",
		"{C:inactive}Currently X#2# Mult)"
	}
}

local let_the_forests_burn = SMODS.Joker:new(
	"Let The Forests Burn", --name
	"let_the_forests_burn", --slug
	{extra = {xmult_per = 0.25}}, --config
	{x = 0, y = 0}, --spritePos
	let_the_forrests_burn_txt, --loc_txt
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

G.localization.misc.dictionary.k_burned = "Burned!"

function let_the_forests_burn.loc_def(center)
	if center.ability.name == "Let The Forests Burn" then
		local club_cards = 0
		if G.playing_cards then
			for _, v in ipairs(G.playing_cards) do
				if v:is_suit("Clubs", true) then club_cards = club_cards + 1 end
			end
		end
		return {center.ability.extra.xmult_per, center.ability.extra.xmult_per*club_cards}
	end
end

function let_the_forests_burn.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
end

let_the_forests_burn.calculate = function(self, context)
	if not context.blueprint then
		if context.discard then
			if context.other_card:is_suit("Clubs", true) then
				return {
					message = localize('k_burned'),
					colour = G.C.RED,
					delay = 0.45, 
					remove = true,
					card = self
				}
			end
		end
		if context.destroying_card then
			if context.destroying_card:is_suit("Clubs", true) then
				return true
			end
		end
		if SMODS.end_calculate_context(context) then
			local club_cards = 0
			for _, v in ipairs(G.playing_cards) do
				if v:is_suit("Clubs", true) then club_cards = club_cards + 1 end
			end
			return {
				message = localize{type='variable',key='a_xmult',vars={self.ability.extra.xmult_per*club_cards}},
				Xmult_mod = self.ability.extra.xmult_per*club_cards
			}
		end
	end
end

return let_the_forests_burn