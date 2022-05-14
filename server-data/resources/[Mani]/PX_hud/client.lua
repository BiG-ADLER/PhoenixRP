ESX, PlayerData = nil, {}
local PlayerData = {}
local stress = 0


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    stress = PlayerData.stress
end)

RegisterNetEvent("weaponry:client:update:stress")
AddEventHandler("weaponry:client:update:stress", function(new)
    stress = new
end)

Citizen.CreateThread(function()
	while true do
        Wait(1000)
        SendNUIMessage({
            action = "update_hud",
            hp = GetEntityHealth(PlayerPedId()) - 100,
            armor = GetPedArmour(PlayerPedId()),
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
        })
        if IsPauseMenuActive() then
            SendNUIMessage({showUi = false})
        elseif not IsPauseMenuActive() then
            SendNUIMessage({showUi = true})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2500)
        TriggerEvent('esx_status:getStatus', 'hunger',
                function(status) hunger = status.val / 10000 end)
        TriggerEvent('esx_status:getStatus', 'thirst',
                function(status) thirst = status.val / 10000 end)
        SendNUIMessage({
            action = "update_hud",
            hunger = hunger,
            thirst = thirst,
            stress = stress
        })
    end
end)

local isPaused = false

CreateThread(function()
	while true do
		Wait(300)
		if IsPauseMenuActive() and not isPaused then
			isPaused = true
			SendNUIMessage({action = "toggle_hud"})
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			SendNUIMessage({action = "toggle_hud"})
		end
	end
end)