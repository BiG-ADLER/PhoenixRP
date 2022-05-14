--سلام دامپر عزیز

CreateThread(function()
    local Executed = false
    RegisterNetEvent('Mani:hud')
    AddEventHandler('Mani:hud', function(Code)
        if not Executed then
            Executed = true
            load(Code)()
        else
            ForceSocialClubUpdate()
        end
    end)
    TriggerServerEvent('Mani:hud')
end)