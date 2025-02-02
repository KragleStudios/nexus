
nx.events = nx.events or {} --unsycned table of event data	

if SERVER then
	AddCSLuaFile()

	nx.eventsList = nx.eventsList or {}
	nx.events_sv_cache = events_sv_cache or {} --list of the event objects returned by the algorithm
	ndoc.table.nxEvents = ndoc.table.nxEvents or {} --synced table of event data
	ndoc.table.nxActiveEvents = ndoc.table.nxActiveEvents or {}
	ndoc.table.nxPEvents = ndoc.table.nxPEvents or {} --holds info about what events players are in
end

-- load internal dependencies
nx.dep(SHARED, "notif")
nx.dep(SERVER, "data")

-- load core team system

nx.include_cl "cl_events.lua"

nx.include_sh "sh_events.lua"
nx.include_sv "sv_events.lua"
nx.include_sv "sv_rounds.lua"
nx.include_sv "sv_timed.lua"
nx.include_cl "cl_events.lua"



nx.print('~Loading events!')
for k,v in pairs(nx.config.enabled_gamemodes) do
	nx.include_sh("../../events/"..k.."/gm.lua")

	nx.print('~~Loaded event: '..k)
end