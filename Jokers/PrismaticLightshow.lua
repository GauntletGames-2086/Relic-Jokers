local prismatic_lightshow_txt = {
	["name"] = "Prismatic Lightshow",
	["text"] = {
		"All {C:attention}Consumables",
		"spawn with an {C:dark_edition}Edition"
	}
}

local prismatic_lightshow = SMODS.Joker:new(
	"Prismatic Lightshow", --name
	"prismatic_lightshow", --slug
	{extra = {chips_mult_buff = 1.5}}, --config
	{x = 0, y = 0}, --spritePos
	prismatic_lightshow_txt, --loc_txt
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

return prismatic_lightshow