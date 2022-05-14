ESX = nil
local inEvent = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj) ESX = obj end)
    end
end)

RegisterNetEvent('Mani:setEventCoords')
AddEventHandler('Mani:setEventCoords', function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    if coords ~= nil then
        TriggerServerEvent('Mani:setEventCoords', coords)
    else
        print("Bugggggggggggggggggggggg!")
    end
end)

RegisterNetEvent('Mani:endEvent')
AddEventHandler('Mani:endEvent', function()
    if inEvent then
        local ped = GetPlayerPed(-1)
        TriggerEvent("esx_ambulancejob:ReviveIfDead")
        RemoveAllPedWeapons(ped, true)
        SetEntityCoords(PlayerPedId(), 245.86, -828.0, 29.88)
        TriggerEvent('Proxtended:freezePlayer', true)
        Wait(100)
        TriggerEvent('esx:restoreLoadout')
        Wait(1000)
        TriggerEvent('Proxtended:freezePlayer', false)
        TriggerEvent("Mani:Event", false)
        inEvent = false
    end
end)

RegisterNetEvent('Mani:gotoEvent')
AddEventHandler('Mani:gotoEvent', function(coords, name, weapon)
    TriggerEvent("Mani:Event", true)
    inEvent = true
    local ped = GetPlayerPed(-1)
    RemoveAllPedWeapons(ped, true)
    if weapon ~= false then
        GiveWeaponToPed(ped, GetHashKey(weapon), 250, false, false)
    end
    if name == "warzone" then
        GiveWeaponToPed(ped, GetHashKey("gadget_parachute"), 1, false, false)
        ESX.Game.Teleport(ped, coords)
        TriggerEvent('Proxtended:freezePlayer', true)
        Wait(100)
        TriggerEvent('Proxtended:freezePlayer', false)
        local coordme = GetEntityCoords(ped)
        SetEntityCoords(ped, coordme.x, coordme.y, coordme.z + 200.0)
    else
        ESX.Game.Teleport(ped, coords)
    end
end)