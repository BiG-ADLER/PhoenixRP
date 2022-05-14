ESX = nil
local xPlayer = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    xPlayer = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    xPlayer = data
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    xPlayer.job = job
end)

local nargileObjects = {}
local nargileSingleObject = nil
local carryingNargile = false
local marpuc = nil
local sessionStarted = false
local currentHookah = nil
local carryingKoz = false
local koz = {

    obj = nil
}

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(coords - CafeConfig.nargileYap.coords) < 2.5 then
            sleep = false
            if ESX ~= nil and xPlayer.job.name == "cafe" then
                local text = '~INPUT_CONTEXT~ Ghelyoon |  ~INPUT_REPLAY_SHOWHOTKEY~ Zoghal'


                if(carryingNargile)then
                    text = '~INPUT_CONTEXT~ Gozashtan Ghelyoon | ~INPUT_REPLAY_SHOWHOTKEY~ Zoghal'
                end

                if carryingKoz then
                    text = '~INPUT_CONTEXT~ Ghelyoon | ~INPUT_REPLAY_SHOWHOTKEY~ Gozashtan Zoghal'
                end

                ESX.ShowFloatingHelpNotification(text, CafeConfig.nargileYap.coords.x, CafeConfig.nargileYap.coords.y, CafeConfig.nargileYap.coords.z)

                if IsControlJustReleased(0, 38) then
                    if  not carryingNargile then
                        if  not carryingKoz then
                            ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                                if quantity >= 1 then
                                    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(zogh)
                                        if zogh >= 1 then
                                            local obj = CreateObject(4037417364, 0,0,0, true, 0, true)
                                            local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
                                            nargileSingleObject = obj
                                            carryingNargile = true
                                            anim()
                                            AttachEntityToEntity(obj, ply, boneIndex2, -0.15, 0.2, 0.18, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                            TriggerServerEvent("Mani_Cafe:RemoveItem", "zoghal", "opium")
                                        else
                                            ESX.ShowNotification("Shoma Zoghal Nadarid!", 'error')
                                        end
                                    end, "zoghal")
                                else
                                    ESX.ShowNotification("Shoma Tanbako Nadarid!", 'error')
                                end
                            end, "opium")
                        else
                            ESX.ShowNotification("Shoma Dar Hal Hazer Yek Ghelyan/Zoghal Dar Dast Darid!", 'error')
                        end
                    else
                        DeleteEntity(nargileSingleObject)
                        nargileSingleObject = nil
                        carryingNargile = false   
                        ClearPedTasks(PlayerPedId())
                    end
                end
                if IsControlJustPressed(0, 311) then
                    if koz.obj == nil and not carryingKoz then
                        if  not carryingNargile then
                            ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                                if quantity >= 1 then
                                    carryingKoz = true
                                    attachKoz()
                                    TriggerServerEvent("Mani_Cafe:RemoveItem", "zoghal", nil)
                                else
                                    ESX.ShowNotification("Shoma Zoghal Nadarid!", 'error')
                                end
                            end, "zoghal")
                        else
                            ESX.ShowNotification("Shoma Dar Hal Hazer Yek Ghelyan/Zoghal Dar Dast Darid!", 'error')
                        end
                    else

                        DeleteEntity(koz.obj)
                        koz.obj = nil
                        carryingKoz = false   
                        ClearPedTasks(PlayerPedId())
                    end
                end
            else
                ESX.ShowFloatingHelpNotification("Be Ghelyoona Dast Nazan", CafeConfig.nargileYap.coords.x, CafeConfig.nargileYap.coords.y, CafeConfig.nargileYap.coords.z)
            end
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        for k,v in pairs(CafeConfig.Masalar) do
            sleep = false
            if carryingNargile or v.alreadyHaveHookah and ESX ~= nil  then
                 local ply = PlayerPedId()
                 local coords = GetEntityCoords(ply, true)
                  if #(coords - v.coords) < 2.5 and not v.alreadyHaveHookah and xPlayer.job.name == "cafe" then 
                    ESX.ShowFloatingHelpNotification( "~INPUT_CONTEXT~ Gozashtan Ghelyan", v.coords.x, v.coords.y, v.coords.z)
                    if IsControlJustReleased(0, 38) then
                        putNargileToTable(k)
                     end
                 elseif #(coords - v.coords) < 2.5 and v.alreadyHaveHookah and xPlayer.job.name == "cafe" then 
                   ESX.ShowFloatingHelpNotification( "~INPUT_CONTEXT~ Bardashtan Ghelyan", v.coords.x, v.coords.y, v.coords.z)
                     if IsControlJustReleased(0, 38) then
                           takeNargileFromTable(k)
                     end
                end
            end
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(100.96, 199.75, 108.37))
        if distance < 20 then
            if xPlayer.job.name == "cafe" then
                DrawMarker(20, vector3(100.96, 199.75, 108.37), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.5, 255, 255, 255, 255, false, true, nil, false)
                if distance < 2.0 then
                    TriggerEvent('esx:showHelpNotification', 'Press ~INPUT_CONTEXT~ For Open ~r~Menu~s~')
                    if IsControlJustReleased(1, 38) then
                        OpenMenuAction()
                    end
                end
            else
                Citizen.Wait(5000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

function OpenMenuAction()
    local elements = {
        {label = 'Stash', value = 'stash'},
        {label = 'Craft Table', value = 'craft'}
    }
    if xPlayer.job.grade_name == "boss" then
		table.insert(elements, {label = 'Boss Action', value = 'boss'})
	end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cafe_menu', {
        title = 'Cafe Action',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'stash' then
                Other = {maxweight = 5000000, slots = 100}
                TriggerEvent("PX_inventory:client:SetCurrentStash", xPlayer.job.name)
                TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", xPlayer.job.name, Other)
            elseif data.current.value == 'craft' then
                TriggerEvent("PX_crafting:open")
            elseif data.current.value == 'boss' then
                TriggerEvent('esx_society:openBossMenu', 'cafe', function(data, menu)
                    menu.close()
                end)
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('codem-nargile:client:deleteMarpuc')
AddEventHandler('codem-nargile:client:deleteMarpuc', function(masa)
    local masa = CafeConfig.Masalar[masa].coords
    if sessionStarted then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(masa - coords ) < 3.0 then

            currentHookah = nil
            SetEntityAsMissionEntity(marpuc, true, true)
            DeleteEntity(marpuc)
            marpuc = nil
            ClearPedTasks(ply)
        end
    end
end)


RegisterNetEvent('codem-nargile:client:deleteNargile')
AddEventHandler('codem-nargile:client:deleteNargile', function(masa)

    local ply = PlayerPedId()
    local coords = GetEntityCoords(ply, true)

    for k,v in pairs(nargileObjects) do
        if v.table == masa then
             SetEntityAsMissionEntity(NetworkGetEntityFromNetworkId(v.obj), true, true)
             DeleteEntity(NetworkGetEntityFromNetworkId(v.obj))

             table.remove(nargileObjects, k)

             return;
        end
    end
  
end)

RegisterNetEvent('codem-nargile:client:getCafeConfig')
AddEventHandler('codem-nargile:client:getCafeConfig', function(newCafeConfig)
    CafeConfig.Masalar = newCafeConfig
end)

function putNargileToTable(masa)
    DeleteEntity(nargileSingleObject)
    nargileSingleObject = nil
    carryingNargile = false
    local obj =  CreateObject(4037417364, CafeConfig.Masalar[masa].coords, false, 0, false)
    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
    NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(obj), false)
	FreezeEntityPosition(obj, true)
    table.insert(nargileObjects, {obj = NetworkGetNetworkIdFromEntity(obj), table = masa, koz = 100})
    TriggerServerEvent('codem-nargile:server:syncHookahTable', nargileObjects)

    TriggerServerEvent('codem-nargile:server:setAlreadyHaveHookah',masa, true)


    ClearPedTasks(PlayerPedId())
end

function takeNargileFromTable(masa)
    for k,v in pairs(nargileObjects) do
        if v.table == masa then
            TriggerServerEvent('codem-nargile:server:deleteMarpuc', v.table)

            TriggerServerEvent('codem-nargile:server:deleteNargile', v.table)

            TriggerServerEvent('codem-nargile:server:setAlreadyHaveHookah',masa, false)
        end
    end
end

RegisterNetEvent('codem-nargile:client:setHookahs')
AddEventHandler('codem-nargile:client:setHookahs', function(nargileler)
    nargileObjects = nargileler
end)

RegisterNetEvent('codem-nargile:client:syncHookahTable')
AddEventHandler('codem-nargile:client:syncHookahTable', function()
end)



RegisterNetEvent('codem-nargile:client:syncKoz')
AddEventHandler('codem-nargile:client:syncKoz', function(obj, amount)
    for k,v in pairs(nargileObjects) do
        if v.obj == obj then
            v.koz = v.koz + amount
            if v.koz > 100 then
                v.koz = 100
            elseif v.koz <= 0 then
                v.koz = 0
            end
        end
    end
end)



function attachKoz()
	local hash = GetHashKey('v_corp_boxpaprfd')
	local ped = PlayerPedId()
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end

	local obj = CreateObject(hash,  GetEntityCoords(PlayerPedId()),  true,  true, true)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end
    UseParticleFxAsset("core")

    StartNetworkedParticleFxLoopedOnEntity("ent_anim_cig_smoke",obj,0,0,0.1, 0,0,0, 3.0, 0,0,0)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
	local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    koz.obj = obj;


    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)


	AttachEntityToEntity(obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
end


function kozle(v)
    local ped = PlayerPedId()

    RequestAnimDict("misscarsteal3pullover")
    while not HasAnimDictLoaded("misscarsteal3pullover") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "misscarsteal3pullover", "pull_over_right", 2.0, 2.0, -1, 49, 0, false, false, false)
    Citizen.Wait(5500)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
    local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)
	AttachEntityToEntity(koz.obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
    TriggerServerEvent('codem-nargile:server:syncKoz', v.obj, 50)

end


RegisterCommand('at', function()
    if xPlayer.job.name == "cafe" then
        attachKoz()
    else
        ESX.ShowNotification("Shoma ~y~Ghahve Chi ~r~Nistid!")
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        for k,v in pairs(nargileObjects) do
            sleep = false
   
            local coords = GetEntityCoords(NetworkGetEntityFromNetworkId(v.obj), true)
            local ply = PlayerPedId()
            local coordsPly = GetEntityCoords(ply, true)
            if #(coords - coordsPly) < 3.0 then

                if IsControlJustPressed(0, 47) and v.koz < 100 and koz.obj and carryingKoz then
                    kozle(v)

                end
                if not sessionStarted then
                   DrawText3D(coords.x, coords.y,coords.z + 0.20, "K -  Keshidan | G - Avaz Kardan Zoghal | Zoghal : %".. v.koz)
                    if IsControlJustReleased(0, 311) then

                        currentHookah = v.obj
                        nargileIc(v.table)
                
                    end  
                else
                    if IsControlJustPressed(0, 74) and v.koz >  0 then -- Normal: k
                        TriggerServerEvent("hookah_smokes", PedToNet(ply))                            
                        TriggerServerEvent('codem-nargile:server:syncKoz', v.obj,  -5)
                        TriggerEvent('InteractSound_CL:PlayOnOne', 'ghelyon', 0.3)
                        Citizen.Wait(5000)
                        TriggerServerEvent('weaponry:server:remove:stress', 1)
                    end

                    if v.koz > 0 then
                       DrawText3D(coords.x, coords.y,coords.z + 0.7, "H - Kam Gereftan |  G - Avaz Kardan Zoghal | F - NakeShidan | Zoghal : %".. v.koz)
                    else
                       DrawText3D(coords.x, coords.y,coords.z + 0.7, "F -  NakeShidan | Zoghal : %".. v.koz)
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(1000) 
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if sessionStarted then
			local dist = #(GetEntityCoords(PlayerPedId(), true) - vector3(96.04, 198.79, 108.37))
			if dist > 10.0 or IsPedInAnyVehicle(PlayerPedId(), false) then
				sessionStarted = false
				SetEntityAsMissionEntity(marpuc, false, true)
				DeleteObject(marpuc)
				ClearPedTasks(PlayerPedId())
				ESX.ShowNotification("Shoma Nemitavanid Biron Az Cafe Az Ghelyan Estefade Konid!", 'error')
			end
		end
	end
end)

function anim()
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

end

function nargileIc(masa)
   TriggerServerEvent('codem-nargile:server:setSessionStarted', masa, true)
    smoke()
    anim()
    local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	local model = GetHashKey('v_corp_lngestoolfd')
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(100)
	end								
	local obj = CreateObject(model,  coords.x+0.5, coords.y+0.1, coords.z+0.4, true, false, true)
	marpuc = obj
	AttachEntityToEntity(obj, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
    sessionStarted = true	
end

function smoke()
    Citizen.CreateThread(function()
        while true do
        local ped = PlayerPedId()
            Citizen.Wait(0)

            
            if IsControlJustReleased(0, 23) and sessionStarted then -- Normal: F
                sessionStarted = false
                SetEntityAsMissionEntity(marpuc, false, true)
                DeleteObject(marpuc)
                currentHookah = nil


                ClearPedTasks(PlayerPedId())
    
            end
        end
    end)
end


p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("c_hookah_smokes")
AddEventHandler("c_hookah_smokes", function(c_ped)
	local p_smoke_location = {
		20279,
	}
	local p_smoke_particle = "exp_grd_bzgas_smoke"
	local p_smoke_particle_asset = "core" 


	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
            TriggerServerEvent("BlackBand:useghelyon")
            Wait(5000)
            createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 1.0, 0.0, 0.0, 0.0)
            Wait(2000)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 0.5, 0.0, 0.0, 0.0)
            Wait(2000)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 0.3, 0.0, 0.0, 0.0)
            --Wait(250)
            StopParticleFxLooped(createdSmoke, 1)
            -- Wait(1000*2)
            RemoveParticleFxFromEntity(NetToPed(c_ped))
            TriggerEvent("PX_Cafe:used")
            break
		end
	end
end)

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	--DrawText(_x,_y)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	--DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	ClearDrawOrigin()
end

-- Create blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(99.5, 203.46, 108.37)
    SetBlipSprite(blip, 176)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 7)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cafe")
    EndTextCommandSetBlipName(blip)
end)