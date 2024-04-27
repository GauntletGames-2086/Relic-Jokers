local market_crash_txt = { -- Market Crash
	["name"] = "Market Crash",
	["text"] = {
		"Earn {C:money}$#1#{}",
		"Cannot earn money",
		"from {C:attention}payout{}"
	}
}
local market_crash = SMODS.Joker:new(
	"Market Crash", --name
	"market_crash", --slug
	{extra = {money_gain = 100}}, --config
	{x = 0, y = 0}, --spritePos
	market_crash_txt, --loc_txt
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

function market_crash.loc_def(center)
	if center.ability.name == "Market Crash" then
		sendInfoMessage(center.ability.extra.money_gain)
		return {center.ability.extra.money_gain}
	end
end

function market_crash.tooltip(card, info_queue)
	info_queue[#info_queue+1] = {set = 'Other', key = 'black_hole_joker'}
end

local GFUNCSevaluate_round_ref = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
	if next(find_joker('Market Crash')) then
		G.E_MANAGER:add_event(Event({
			trigger = 'before',
			delay = 1.3*math.min(G.GAME.blind.dollars+2, 7)/2*0.15 + 0.5,
			func = function()
			  G.GAME.blind:defeat()
			  return true
			end
		  }))
		delay(0.2)
		G.E_MANAGER:add_event(Event({
			func = function()
				ease_background_colour_blind(G.STATES.ROUND_EVAL, '')
				return true
			end
		}))
		add_round_eval_row({name = 'bottom', dollars = 0})
	else
		GFUNCSevaluate_round_ref()
	end
end

return market_crash