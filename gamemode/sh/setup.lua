	
local teams = {
   --#,		"Team Name",		Color(Team Color Value),	joinable,	"spawnpoint_entity"},
	{1,		"Red Team",			Color(255,80,80,225),		true,		"info_player_red"},
	{2,		"Blue Team",		Color(80,80,255,255),		true,		"info_player_blue"},
	{3,		"Free-for-All",		Color(200,200,120,255),		false,		"info_player_deathmatch"}	-- If team_game is false this is the team they will be on
}

for n,r in pairs(teams) do
	--          #, name,color,joinable
	team.SetUp( n, r[2], r[3], r[4] )
	team.SetSpawnPoint(n,r[5])
end