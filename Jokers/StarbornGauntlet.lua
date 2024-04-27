local starborn_gauntlet_txt = {
	["name"] = "Starborn Gauntlet",
	["text"] = {
		"Increases played poker",
		"hand {C:chips}Chips{} and {C:mult}Mult{}",
		"by {C:attention}#1#X when",
		"hand is played"
	}
}

local starborn_gauntlet = SMODS.Joker:new(
	"Starborn Gauntlet", --name
	"starborn_gauntlet", --slug
	{extra = {chips_mult_buff = 1.5}}, --config
	{x = 0, y = 0}, --spritePos
	starborn_gauntlet_txt, --loc_txt
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

G.localization.misc.dictionary.k_poker_hand_buff = "Hand Buffed"

function starborn_gauntlet.loc_def(center)
	if center.ability.name == 'Starborn Gauntlet' then
		return {center.ability.extra.chips_mult_buff}
	end
end

function starborn_gauntlet.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'starlight_joker'}
end

starborn_gauntlet.calculate = function(self, context)
	if not context.blueprint then
		if context.cardarea == G.jokers and context.before then
			update_hand_text({sound = 'multhit2'}, {chips = G.GAME.hands[context.scoring_name].chips*self.ability.extra.chips_mult_buff, mult = G.GAME.hands[context.scoring_name].mult*self.ability.extra.chips_mult_buff})
			return {
				message = localize('k_poker_hand_buff'),
				colour = G.C.RED,
				card = self
			}
		end
	end
end

return starborn_gauntlet