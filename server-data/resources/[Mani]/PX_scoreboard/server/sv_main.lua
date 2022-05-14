ESX = nil
local OnlinePlayersJob = {police = 0,dadgostari = 0,ambulance = 0,weazel = 0,taxi = 0,realstate = 0}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_scoreboard:getInfo', function(source, cb)
	cb(OnlinePlayersJob)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		AddPlayerToScoreboard()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayerToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard()
	OnlinePlayersJob = {total = 0,police = 0,dadgostari = 0,ambulance = 0,weazel = 0,taxi = 0,realstate = 0}
	local adamha = GetPlayers()
	OnlinePlayersJob.total = #adamha
	for _,v in pairs(adamha) do
		xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer then
			if xPlayer.job.name == "police" then
				OnlinePlayersJob.police = OnlinePlayersJob.police + 1
				if OnlinePlayersJob.police > 5 then
					OnlinePlayersJob.police = "+5"
				end
			elseif xPlayer.job.name == "dadgostari" then
				OnlinePlayersJob.dadgostari = OnlinePlayersJob.dadgostari + 1
				if OnlinePlayersJob.dadgostari > 5 then
					OnlinePlayersJob.dadgostari = "+5"
				end
			elseif xPlayer.job.name == "ambulance" then
				OnlinePlayersJob.ambulance = OnlinePlayersJob.ambulance + 1
				if OnlinePlayersJob.ambulance > 5 then
					OnlinePlayersJob.ambulance = "+5"
				end
			elseif xPlayer.job.name == "weazel" then
				OnlinePlayersJob.weazel = OnlinePlayersJob.weazel + 1
				if OnlinePlayersJob.weazel > 5 then
					OnlinePlayersJob.weazel = "+5"
				end
			elseif xPlayer.job.name == "taxi" then
				OnlinePlayersJob.taxi = OnlinePlayersJob.taxi + 1
				if OnlinePlayersJob.taxi > 5 then
					OnlinePlayersJob.taxi = "+5"
				end
			elseif xPlayer.job.name == "realstate" then
				OnlinePlayersJob.realstate = OnlinePlayersJob.realstate + 1
				if OnlinePlayersJob.realstate > 5 then
					OnlinePlayersJob.realstate = "+5"
				end
			end
		end
	end
end