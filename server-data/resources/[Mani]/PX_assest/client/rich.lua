local players = 1

RegisterNetEvent("Mani_Discord:antiUsage")
AddEventHandler("Mani_Discord:antiUsage", function(tedad)
    players = tedad
end)

Citizen.CreateThread(function()
    while true do
        local playerName = GetPlayerName(PlayerId())
        SetDiscordAppId(947859152296902666)
        SetDiscordRichPresenceAsset('logo')
        SetDiscordRichPresenceAssetText(playerName..' Is Eating Chicken')
        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/phoenixir")
        SetRichPresence(string.format("%s | Online Players: %s", playerName, players))
        Citizen.Wait(60000)
    end
end)