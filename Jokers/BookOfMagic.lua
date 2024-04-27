local book_of_magic_txt = {
	["name"] = "Book Of Magic",
	["text"] = {
		"uhh idk x2"
	}
}

local book_of_magic = SMODS.Joker:new(
	"Book Of Magic", --name
	"book_of_magic", --slug
	{extra = {chips_mult_buff = 1.5}}, --config
	{x = 0, y = 0}, --spritePos
	book_of_magic_txt, --loc_txt
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

return book_of_magic