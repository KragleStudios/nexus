local EV = {}
EV.name = 'Player vs Player'
EV.locations = {
	['Grass 1'] = {
		{Vector(-880.835632, 565.363037, -84.074921), Angle(8.9, 26, 0)},
		{Vector(-320, 829, -83.9), Angle(5, -170, 0)},
		{Vector(-1007, 1034, -83), Angle(7, 176, 0)},
		{Vector(-660, 474, -86), Angle(4, -60, 0)}
	},
	['Grass 2'] = {
		{Vector(-880.835632, 565.363037, -84.074921), Angle(8.9, 26, 0)},
		{Vector(-320, 829, -83.9), Angle(5, -170, 0)},
		{Vector(-1007, 1034, -83), Angle(7, 176, 0)},
		{Vector(-660, 474, -86), Angle(4, -60, 0)}
	}
}

EV.round_based = false -- is this round based?
EV.rounds = 0 --how many rounds if so?
EV.time_limit = 120 -- how long should an event last?

EV.restrictions = {
	maxPlayers = 10, --what's the max allowed to join?
	minPlayers = 2
}

EV.kills = 10

EV.hooks = {

	--Handles player death for our stuff. Note: this auto checks to make sure the players are in this event.
	['DoPlayerDeath'] = function(ply, attacker, dmgInfo, event)
		event.cache[ ply ] = event.cache[ ply ] or {}
		event.cache[ attacker ] = event.cache[ attacker ] or {}

		event.cache[ ply ].deaths = event.cache[ ply ].deaths and event.cache[ ply ].deaths + 1 or 0
		event.cache[ attacker ].kills = event.cache[ attacker ].kills and event.cache[ attacker ].kills + 1 or 0
	
		if (event.cache[ attacker ].kills == EV.kills) then
			event.max_kills = event.cache[ attacker ].kills
		end
	end, 
}

--return whether or not the max kills has been reached
function EV.shouldEnd(event)
	return event.max_kills == EV.kills
end

--what we do when we decide we need to end
function EV.doPause(event)
	for k,v in pairs(event.players) do
		v:Freeze(true)
	end
end

--should the game be put into the paused state?
--NOTE: The server automatically checks players against the minimum required
function EV.shouldPause(event)
	return false
end

--what we do when we decide the game is over
function EV.doGameOver(event)
	for k,v in pairs(event.players) do
		v:Freeze(false)
	end
end

--who won the game!!
function EV.getWinner(event)
	return event.max_kills
end

--if this is a timed event, only called once, if it's round based, it will get called each ending
function EV.rewardWinner(player)
	player:addNexi(1000)
end

--can our player join the event????
function EV.canJoinEvent(event, player)
	return true
end

--we joined so what
function EV.playerJoinEvent(event, player)
	player:Give("weapon_ar2")
end

--lets create a table of stuff to display to the client at the end of the game
--options: ['headers'] = {H1, H2, H3}
--		   ['rows']    = {Title1, Title2, Title3}
--		   **For instance, H1 could be "Player" while Title1 could be the playername
function EV.getScoreboardPop(event)
	local tab = {}

	tab['headers'] = {'Player', 'Kills', 'Deaths'}
	tab['rows'] = {
		--{PlayerName, PlayerKills, PlayerDeaths},
	}

	for k,v in pairs(event.players) do
		local cacheData = event.cache[ v ]

		table.insert(tab['rows'], { v:Nick(), cacheData.kills or 0, cacheData.deaths or 0 })
	end

	return tab
end

--we left cuz we are a bitch
--NOTE: This gets called on all active players when an event is destroyed too!
function EV.playerLeftEvent(event, player)
	player:StripWeapon("weapon_ar2")
end



--THE FOLLOWING COMMANDS ARE FOR ROUND BASED GAMEMODES ONLY!
--Called everytime a new round is in the setup state
--Don't do positioning in here, it's handled by the server and is set randomly
function EV.doRoundSetup(event)

end

--Called everytime a round is in the ending phase
function EV.doRoundEnd(event)

end

--Called everytime a new round StartSchedule
function EV.doRoundStart(event)

end

if (SERVER) then
	nx.events:register(EV)
end