
AddCSLuaFile()

	-- Red VS Blue if true, Free-for-All if false
	CreateConVar("scav_teamgame", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_NOT_CONNECTED, FCVAR_REPLICATED}, "If false, the game will be a free for all every player for themselves.")
	team_game 			= GetConVar("scav_teamgame"):GetBool()
	
	-- Each team gets their own scavenger hunt list if true.
	-- This var means nothing in a free-for-all game
	CreateConVar("scav_difflists", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If true, each team gets a unique list of props to find")
	use_differ_lists	= GetConVar("scav_difflists")	:GetBool()
	
	-- True: Allow friendly fire
	CreateConVar("scav_friendlyfire", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables friendly fire if true")
	friendly_fire		= GetConVar("scav_friendlyfire"):GetBool()
	
	-- Balance the teams at the beginning of each game
	-- This var means nothing in a free-for-all game
	CreateConVar("scav_teambalance", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If true, game will balance the teams if one team gets bigger than the other")
	team_balance		= GetConVar("scav_teambalance")	:GetBool()
	
	-- If the combined player score is this many points above the other, the teams will be balanced
	CreateConVar("scav_skilldiff", "25", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If the skill spread goes above this value, the teams will be changed")
	score_difference	= GetConVar("scav_skilldiff"):GetInt()
	
	-- (T) = team score increases by X points when a team member is awarded a point
	CreateConVar("scav_teamshares", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If true, the team score increases with every point a player gets.\nIf false, the team only gets points when it wins.")
	team_shares			= GetConVar("scav_teamshares"):GetBool()
	
	-- # of points to award to winning team
	CreateConVar("scav_scorewin", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded to team when a player wins")
	SCORE_TEAMWIN		= GetConVar("scav_scorewin"):GetInt()
	
	-- # of points to award when an item is collected
	CreateConVar("scav_scorecollect", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded every time a prop is found")
	SCORE_COLLECT		= GetConVar("scav_scorecollect"):GetInt()
	
	-- # of points to award to the winner
	CreateConVar("scav_scoreteam", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded to the player who wins")
	SCORE_WIN			= GetConVar("scav_scoreteam"):GetInt()
	
	-- # of points to award to losing players
	CreateConVar("scav_scorelose", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded when a player loses - Pity points")
	SCORE_LOSE			= GetConVar("scav_scorelose"):GetInt()
	
	-- # of points to award for killing a player
	CreateConVar("scav_scorekill", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded when a player kills another player")
	SCORE_KILL			= GetConVar("scav_scorekill"):GetInt()
	
	-- # of points to award for dying
	CreateConVar("scav_scoredeath", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded when a player dies other than suicide")
	SCORE_DEATH			= GetConVar("scav_scoredeath"):GetInt()
	
	-- # of points to award for committing suicide
	CreateConVar("scav_scoresuicide", "-1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Points awarded when a player kills themselves intentionally\nThis score never affects the overall team score even if Team Sharing is on")
	SCORE_SUICIDE		= GetConVar("scav_scoresuicide"):GetInt()
	
	-- Maximum number of items to find to win
	CreateConVar("scav_findcount", "12", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_NOT_CONNECTED, FCVAR_REPLICATED}, "Number of props to be found each round")	
	SCAV_MAX 			= GetConVar("scav_findcount"):GetInt()
	-- Time in seconds per round
	CreateConVar("scav_roundtime", "300", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time (in seconds) per round to find props")
	TIME_SCAV 			= GetConVar("scav_roundtime"):GetInt()
	
	-- Time to prepare before the list is given
	CreateConVar("scav_roundprep", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max time (in seconds) before a new round begins")
	TIME_PREP			= GetConVar("scav_roundprep"):GetInt()
	-- Time between rounds, in seconds
	CreateConVar("scav_roundbreak", "6", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time after a round ends before preparation begins")
	TIME_BREAK			= GetConVar("scav_roundbreak"):GetInt()
	
	-- Maximum rounds per map
	CreateConVar("scav_maxrounds", "12", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of rounds before map change")	
	MAX_ROUNDS			= GetConVar("scav_maxrounds"):GetInt()
	
	-- Maximum time per map, in minutes
	CreateConVar("scav_maxtime", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_NOT_CONNECTED, FCVAR_REPLICATED}, "Time (in minutes) that each map will last")
	MAX_TIME			= GetConVar("scav_maxtime"):GetInt()

	-- Time in seconds to award credits during an active round
	CreateConVar("scav_paytimer", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time (in seconds) to give credits for playing")		
	TIMER_PAY			= GetConVar("scav_paytimer"):GetInt()

	-- Credits to award per TIMER_PAY seconds of being alive during a round
	CreateConVar("scav_payalive", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Credits to pay everytime scav_paytimer ticks")
	PAYMENT_ALIVE 		= GetConVar("scav_payalive"):GetInt()
	
	-- Credits to award for winning (individual)
	CreateConVar("scav_paywin", "50", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Credits to give the winning player")
	PAYMENT_WIN 		= GetConVar("scav_paywin"):GetInt()
	
	-- Credits to award for being on the winning team
	CreateConVar("scav_payteam", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Credits to pay to the winning team's players")
	PAYMENT_TEAM		= GetConVar("scav_payteam"):GetInt()
	
	-- Credits to award for being a good sport
	CreateConVar("scav_paylose", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Credits to pay for losing - pity cash")
	PAYMENT_LOSE		= GetConVar("scav_paylose"):GetInt()
	
	-- Maximum amount of credits a player can stash
	CreateConVar("scav_paymax", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Maximum amount of credits a player can hold on to")	
	CREDIT_CAP			= GetConVar("scav_paymax"):GetInt()
	
	-- Called when log prints are made
	function TimeStamp()
		return os.date("%d/%m/%Y @ %H:%M.%S", os.time())
	end
	
	-- Once the gamemode loads, broadcast to clients whether the game is a team game or not
	hook.Add("PostGamemodeLoaded", "UpdateTeamGame", function()
		SetGlobalBool("teamgame", team_game)
	end)