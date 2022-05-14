AddEventHandler("playerDropped", function(reason)
    local source = source
    local crds = GetEntityCoords(GetPlayerPed(source))
    local identifier = GetPlayerIdentifier(source, 0)    
    TriggerClientEvent("Mani:AntiCL", -1, source, crds, identifier, reason)
end)