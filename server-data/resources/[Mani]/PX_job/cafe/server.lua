ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('codem-nargile:server:setAlreadyHaveHookah')
AddEventHandler('codem-nargile:server:setAlreadyHaveHookah', function(masa, toggle)
    CafeConfig.Masalar[masa].alreadyHaveHookah = toggle
    TriggerClientEvent('codem-nargile:client:getCafeConfig', -1,  CafeConfig.Masalar)
end)

RegisterServerEvent('codem-nargile:server:setSessionStarted')
AddEventHandler('codem-nargile:server:setSessionStarted', function(masa, toggle)
    CafeConfig.Masalar[masa].sessionActive = toggle
    TriggerClientEvent('codem-nargile:client:getCafeConfig', -1,  CafeConfig.Masalar)
end)

RegisterServerEvent('codem-nargile:server:syncHookahTable')
AddEventHandler('codem-nargile:server:syncHookahTable', function(nargileler)
    TriggerClientEvent('codem-nargile:client:setHookahs', -1, nargileler)
end)

RegisterServerEvent("hookah_smokes")
AddEventHandler("hookah_smokes", function(entity)
	TriggerClientEvent("c_hookah_smokes", -1, entity)
end)

RegisterServerEvent('codem-nargile:server:deleteMarpuc')
AddEventHandler('codem-nargile:server:deleteMarpuc', function(masa)
    TriggerClientEvent('codem-nargile:client:deleteMarpuc', -1, masa)
end)

RegisterServerEvent('codem-nargile:server:deleteNargile')
AddEventHandler('codem-nargile:server:deleteNargile', function(masa)
    TriggerClientEvent('codem-nargile:client:deleteNargile', -1, masa)
	TriggerClientEvent('esx:showNotification', source, "Shoma Ghelyan Ra Bardashtid!")
end)

RegisterServerEvent('codem-nargile:server:syncKoz')
AddEventHandler('codem-nargile:server:syncKoz', function(obj, amount)
    TriggerClientEvent('codem-nargile:client:syncKoz', -1, obj, amount)

end)

RegisterServerEvent('BlackBand:useghelyon')
AddEventHandler('BlackBand:useghelyon', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_status:add', source, 'hunger', 30000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
end)

RegisterServerEvent('Mani_Cafe:RemoveItem')
AddEventHandler('Mani_Cafe:RemoveItem', function(item1, item2)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item1, 1)
	if item2 ~= nil then
		xPlayer.removeInventoryItem(item2, 1)
	end
end)