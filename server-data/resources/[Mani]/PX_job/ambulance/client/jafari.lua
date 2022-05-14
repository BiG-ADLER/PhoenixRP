local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local PlayerData              = {}
local BlipList                = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
AmbulanceConfigjafari = {}
AmbulanceConfigjafari.Locale = 'en'

AmbulanceConfigjafari.MarkerType   = 1
AmbulanceConfigjafari.DrawDistance = 100.0
AmbulanceConfigjafari.MarkerSize   = {x = 2.0, y = 2.0, z = 1.0}
AmbulanceConfigjafari.MarkerColor  = {r = 102, g = 102, b = 204}

AmbulanceConfigjafari.BlipHospital = {
	Sprite = 403,
	Color = 2,
	Display = 2,
	Scale = 1.0
}

AmbulanceConfigjafari.Price = 20000 -- Edit this to your liking.

AmbulanceConfigjafari.EnableUnemployedOnly = false -- If true it will only show Blips to Unemployed Players | false shows it to Everyone.
AmbulanceConfigjafari.EnableBlips = false -- If true then it will show blips | false does the Opposite.
AmbulanceConfigjafari.EnablePeds = true -- If true then it will add Peds on Markers | false does the Opposite.

AmbulanceConfigjafari.Locations = {
	{ x = 328.29 , y = -1420.29, z = 31.68 ,heading = 163.07 },  --mediccccccccccccccccccc
}

AmbulanceConfigjafari.Zones = {}

for i=1, #AmbulanceConfigjafari.Locations, 1 do
	AmbulanceConfigjafari.Zones['Shop_' .. i] = {
		Pos   = AmbulanceConfigjafari.Locations[i],
		Size  = AmbulanceConfigjafari.MarkerSize,
		Color = AmbulanceConfigjafari.MarkerColor,
		Type  = AmbulanceConfigjafari.MarkerType
	}
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

-- Open Hospital Menu
function OpenHospitalMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hospital_confirm', {
		title    = _U('valid_purchase'),
		align    = 'top-left',
		elements = {
			{label = _U('no'),  value = 'no'},
			{label = _U('yes'), value = 'yes'}
		}
	}, function(data, menu)
		menu.close()
		
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_hospital:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('esx_ambulancejob:reviveavermani')
						TriggerServerEvent('esx_hospital:pay')
					else
						ESX.ShowNotification(_U('not_enough_money'), 'error')
					end
				end)
		elseif data.current.value == 'no' then
			menu.close()
		end
	end, function (data, menu)
		menu.close()
	end)
end

AddEventHandler('esx_hospital:hasEnteredMarker', function(zone)
	CurrentAction     = 'hospital_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_hospital:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		for k,v in pairs(AmbulanceConfigjafari.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < AmbulanceConfigjafari.DrawDistance) then
				canSleep = false
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
		
		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Activate Menu when in Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(AmbulanceConfigjafari.Zones) do
			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_hospital:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_hospital:hasExitedMarker', LastZone)
		end
		
		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'hospital_menu' then
					OpenHospitalMenu()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Blips
function deleteBlips()
	if BlipList[1] ~= nil then
		for i=1, #BlipList, 1 do
			RemoveBlip(BlipList[i])
			BlipList[i] = nil
		end
	end
end

function refreshBlips()
	if AmbulanceConfigjafari.EnableBlips then
		if AmbulanceConfigjafari.EnableUnemployedOnly then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unemployed' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'gang' then
				for k,v in pairs(AmbulanceConfigjafari.Locations) do
					local blip = AddBlipForCoord(v.x, v.y)

					SetBlipSprite (blip, AmbulanceConfigjafari.BlipHospital.Sprite)
					SetBlipDisplay(blip, AmbulanceConfigjafari.BlipHospital.Display)
					SetBlipScale  (blip, AmbulanceConfigjafari.BlipHospital.Scale)
					SetBlipColour (blip, AmbulanceConfigjafari.BlipHospital.Color)
					SetBlipAsShortRange(blip, true)

					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('blip_hospital'))
					EndTextCommandSetBlipName(blip)
					table.insert(BlipList, blip)
				end
			end
		else
			for k,v in pairs(AmbulanceConfigjafari.Locations) do
				local blip = AddBlipForCoord(v.x, v.y)

				SetBlipSprite (blip, AmbulanceConfigjafari.BlipHospital.Sprite)
				SetBlipDisplay(blip, AmbulanceConfigjafari.BlipHospital.Display)
				SetBlipScale  (blip, AmbulanceConfigjafari.BlipHospital.Scale)
				SetBlipColour (blip, AmbulanceConfigjafari.BlipHospital.Color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_hospital'))
				EndTextCommandSetBlipName(blip)
				table.insert(BlipList, blip)
			end
		end
	end
end

-- Create Ped
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_m_doctor_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
        Wait(1)
    end
	
	if AmbulanceConfigjafari.EnablePeds then
		for _, item in pairs(AmbulanceConfigjafari.Locations) do
			local npc = CreatePed(4, 0xd47303ac, item.x, item.y, item.z, item.heading, false, true)
			
			SetEntityHeading(npc, item.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
	end
end)
