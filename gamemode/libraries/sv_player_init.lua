hook.Add("PlayerDeath", "PlayerDeath:NexusInitialization", function(vic, inf, att)
	vic.deaths = 0 or vic.deaths + 1
	att.kills  = 0 or att.kills  + 1
end)

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn:NexusInitialization", function(ply)
	local mdl = ply:GetModel()
	local nexi, events, pac, xp = 0, 0, 0, 0
	local rank = "user" //TODO: Rank system

	NX.MySQL.Query("SELECT * FROM playerdata WHERE steamid ="..ply:SteamID(), function(query)
		if (not query) then
			NX.MySQL.Query([[INSERT INTO playerdata 
				(events_created, events_joined, events_won, events_abandoned, kills, deaths, nexi, model, pac_parts, rank, xp, steamid) VALUES
				(]].."0, 0, 0, 0, 0, 0, 0, "..mdl..", '', 'user', 0, "..ply:SteamID())
				
		else

			local q = query
			ply.events_created = q["events_created"]
			ply.events_joined = q["events_joined"]
			ply.events_won = q["events_won"]
			ply.events_abandoned = q["events_abandoned"]
			ply.kills = q["kills"]
			ply.deaths = q["deaths"]
			ply.Nexi = q["nexi"]
			ply:SetModel(q["model"])
			ply.pac_parts = q["pac_parts"]
			ply.rank = q["rank"]
			ply.xp = q["xp"]
			ply:SetPos(util.StringToType(q["lastknownposition"], "Vector") or ply:GetPos())
		end
	end)
end)

hook.Add("PlayerDisconnected", "PlayerDisconnected:NexusInitialization", function(ply)
	local ev1 = ply.events_created or 0
	local ev2 = ply.events_joined or 0
	local ev3 = ply.events_won or 0
	local ev4 = ply.events_abandoned or 0
	local kills = ply.kills or 0
	local deaths = ply.deaths or 0
	local nexi = ply.Nexi or 0
	local model = ply:GetModel()
	local pac_parts = ""
	local rank = ""
	local xp = ply.exp or 0
	local lkp = ply:GetPos() 
	lkp = util.TypeToString(lkp)

	NX.MySQL.Query("UPDATE playerdata SET (
		events_created = "..ev1..",
		events_joined = "..ev2..",
		events_won = "..ev3..",
		events_abandoned = "..ev4..",
		kills = "..kills..",
		deaths = "..deaths..",
		nexi = "..nexi..",
		model = "..model..",
		pac_parts = "..pac_parts..",
		rank = "..rank..",
		xp = "..xp..",
		lastknownposition = "..lkp.."
	) WHERE steamid = "..ply:SteamID())
end)