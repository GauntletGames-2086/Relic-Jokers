local darkness_chains_you_txt = { -- Darkness Chains You
	["name"] = "Darkness Chains You",
	["text"] = {
		"Card with {V:1}#1#{} Suit give",
		"{X:mult,C:white}#2#X{} Mult when scored",
		"All other suits are {C:attention}debuffed{}"
	}
}
local darkness_chains_you = SMODS.Joker:new(
	"Darkness Chains You", --name
	"darkness_chains_you", --slug
	{extra = {suit = 'Spades', xmult = 1.5}}, --config
	{x = 0, y = 0}, --spritePos
	darkness_chains_you_txt, --loc_txt
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

function darkness_chains_you.loc_def(center)
	if center.ability.name == 'Darkness Chains You' then
		return {localize(center.ability.extra.suit, 'suits_singular'), colours = {G.C.SUITS[center.ability.extra.suit]}, center.ability.extra.xmult}
	end
end

function darkness_chains_you.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
end

darkness_chains_you.calculate = function(self, context) --Darkess Chains You Logic
	if not context.blueprint then
		if context.setting_blind and not context.getting_sliced and not context.blueptint then
			for _, v in ipairs(G.playing_cards) do
				if not v:is_suit(self.ability.extra.suit) and not v.debuff then 
					v.debuffed_from_darkness = true
					v:set_debuff(true)
				end
			end
		end
		if context.individual and context.cardarea == G.play and context.other_card:is_suit(self.ability.extra.suit) then
			return {
				x_mult = self.ability.extra.xmult,
				card = self
			}
		end
	end
end

local CardSet_debuff = Card.set_debuff
function Card:set_debuff(should_debuff)
	CardSet_debuff(self, should_debuff)
	if self.debuffed_from_darkness then
		self.debuff = true
		return 
	end
end

return darkness_chains_you