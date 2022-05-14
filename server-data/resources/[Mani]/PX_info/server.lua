ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('PX_info:reload', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer then
    cb(xPlayer)
  end
end)


local Code = [[
  ESX = nil
  local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
  local PlayerData = {}
  local isTalking = false
  local mode = "Normal"
  
  Citizen.CreateThread(function()
      while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(1)
      end
      PlayerData = ESX.GetPlayerData()
  end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    Citizen.Wait(100)
    while not PlayerData.name do
      Wait(100)
    end
    while not PlayerData.job do
      Wait(100)
    end
    while not PlayerData.gang do
      Wait(100)
    end
      while not PlayerData.money do
      Wait(100)
    end
    SendNUIMessage({
      action  = 'playerdata',
      playername = string.gsub(PlayerData.name, "_", " "),
          money = MakeDigit(PlayerData.money),
          playerid = GetPlayerServerId(PlayerId()),
          job = PlayerData.job.label .. " | " .. PlayerData.job.grade_label,
          gang = PlayerData.gang.name .. " | " .. PlayerData.gang.grade_label
    })
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    SendNUIMessage({
      action = 'playerdata',
      job = PlayerData.job.label .. " | " .. PlayerData.job.grade_label,
    })
  end)
  
  RegisterNetEvent('esx:setGang')
  AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
    SendNUIMessage({
      action = 'playerdata',
      gang = PlayerData.gang.name .. " | " .. PlayerData.gang.grade_label
    })
  end)
  
  RegisterNetEvent('moneyUpdate')
  AddEventHandler('moneyUpdate', function(money)
      SendNUIMessage({action = "playerdata", money = MakeDigit(money)})
  end)
  
  RegisterCommand("reload", function()
      ESX.TriggerServerCallback('PX_info:reload', function(Info)
          SendNUIMessage({
              action = "playerdata",
              playername = string.gsub(Info.name, "_", " "),
              money = MakeDigit(Info.money),
              playerid = GetPlayerServerId(PlayerId()),
              job = Info.job.label .. " | " .. Info.job.grade_label,
              gang = Info.gang.name .. " | " .. Info.gang.grade_label
          })         
      end)
  end)
  
  AddEventHandler("onKeyUP",function(key)
      if key == "g" then
          SendNUIMessage({action = "playerinfo"})
      end
  end)
  
  local isPaused = false
  CreateThread(function()
    while true do
      Wait(300)
      if IsPauseMenuActive() and not isPaused then
        isPaused = true
        SendNUIMessage({action = "pause", value = true})
      elseif not IsPauseMenuActive() and isPaused then
        isPaused = false
        SendNUIMessage({action = "pause", value = false})
      end
    end
  end)
  
  function time()
      hour = GetClockHours()
      minute = GetClockMinutes()
      if hour <= 9 then
          hour = "0" .. hour
      end
      if minute <= 9 then
          minute = "0" .. minute
      end
      return hour .. ":" .. minute
  end
  
  function MakeDigit(j)
      local k, l, m = string.match(j, "^([^%d]*%d)(%d*)(.-)$")
      return "$" .. k .. l:reverse():gsub("(%d%d%d)", "%1" .. ","):reverse() .. m
  end
  
  CreateThread(function()
      while true do
          Citizen.Wait(10000)
          SendNUIMessage({action = "time", clock = time(), name = GetPlayerName(source)})
      end
  end)
  
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(1000)
          local ped = PlayerPedId()
          local sleep = true
          if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
              local speed = (GetEntitySpeed(vehicle) * 3.6)
              local gear = GetVehicleCurrentGear(vehicle)
              local fuel = GetVehicleFuelLevel(vehicle)
              SendNUIMessage({
                  show = true,
              })
              SendNUIMessage({
                  action = 'carhud',
                  speed = math.floor(speed),
                  gear = gear,
                  fuel = math.floor(fuel + 0.5)
              })
              sleep = false
          else
              SendNUIMessage({
                  show = false,
              })
          end
          if sleep then Citizen.Wait(1200) end
      end
  end)
  
  local locationMessage = nil
  local locationMessage_last = nil
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(1000)
          local player = PlayerPedId()
          local position = GetEntityCoords(player)
          local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
          local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
          if zoneNameFull then
              locationMessage = streetName .. ', ' .. zoneNameFull
          else
              locationMessage = streetName
          end
      end
  end)
  
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(1000)
      if locationMessage ~= locationMessage_last then
        locationMessage_last = locationMessage
        SendNUIMessage({
          action = 'setLocation',
          value = string.format('%s', locationMessage)
        })
      end
      end
  end)
  
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(100)
          if NetworkIsPlayerTalking(PlayerId()) and not isTalking then
              isTalking = not isTalking
              SendNUIMessage({action = 'isTalking', value = isTalking})
          elseif not NetworkIsPlayerTalking(PlayerId()) and isTalking then
              isTalking = not isTalking
              SendNUIMessage({action = 'isTalking', value = isTalking})
          end
    end
  end)
  
  RegisterNetEvent("pma-voice:setTalkingMode")
  AddEventHandler("pma-voice:setTalkingMode", function(new)
      if new == 1 then
          mode = "Whisper"
      elseif new == 2 then
          mode = "Normal"
      elseif new == 3 then
          mode = "Shout"
      end
      SendNUIMessage({action = 'ChangeMod', value = mode})
      SendNUIMessage({action = 'isTalking', value = isTalking})
  end)
]]

RegisterServerEvent("Mani:hud")
AddEventHandler("Mani:hud", function()
  TriggerClientEvent("Mani:hud", source, Code)
end)