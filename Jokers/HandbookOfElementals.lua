local handbook_of_elementals_txt = { 
	["name"] = "Handbook of Elementals",
	["text"] = {
		"When a {C:attention}Boss Blind{} is",
		"selected, create an {C:alchemical_backup}Alchemical",
		"card for each empty",
		"{C:attention}consumable slot{}"
	}
}

local handbook_of_elementals = SMODS.Joker:new(
	"Handbook of Elementals", --name
	"handbook_of_elementals", --slug
	{extra = {xmult = 1.5}}, --config
	{x = 0, y = 0}, --spritePos
	handbook_of_elementals_txt, --loc_txt
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

G.localization.misc.v_dictionary.add_alchemical = "+#1# Alchemical"
G.C.SECONDARY_SET.AlchemyBackup = HEX("C09D75")
loc_colour("mult", nil)
G.ARGS.LOC_COLOURS["alchemical_backup"] = G.C.SECONDARY_SET.AlchemyBackup

handbook_of_elementals.mod_required = "CodexArcanum"
G.localization.descriptions.Other.codexarcanum_required = {
	name = 'Requires Codex Arcanum',
	text = {
		'This joker requires',
		'{C:attention} Codex Arcanum',
		'to be installed'
	}
}

function handbook_of_elementals.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'starlight_joker'}
	info_queue[#info_queue+1] = {set = 'Other', key = 'codexarcanum_required'}
end

handbook_of_elementals.calculate = function(self,context)
	if not context.blueprint then
		if context.setting_blind and not self.getting_sliced and (G.GAME.blind:get_type() == 'Boss') then
			local empty_card_count = G.consumeables.config.card_limit - #G.consumeables.cards
			for i = 1, empty_card_count do
				add_random_alchemical(self)
			end
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'add_alchemical', vars = {empty_card_count}}, colour = G.C.SECONDARY_SET.AlchemyBackup})
		end
	end
end

return handbook_of_elementals