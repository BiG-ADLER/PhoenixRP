Citizen.CreateThread(function()
  while true do
    local total = #GetPlayers()
    TriggerClientEvent("Mani_Discord:antiUsage", -1, total)
    Citizen.Wait(120000)
  end
end)