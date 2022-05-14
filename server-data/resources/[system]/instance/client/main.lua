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

local Instance                = {}
local InstanceInvite          = nil
local InstancedPlayers        = {}
local RegisteredInstanceTypes = {}
local InsideInstance          = false
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

function GetInstance()
	return Instance
end

function CreateInstance(type, data)
	TriggerServerEvent('instance:create', type, data)
end

function CloseInstance()
	Instance = {}
	TriggerServerEvent('instance:close')
end

function EnterInstance(instance)
	InsideInstance = true
	TriggerServerEvent('instance:enter', instance.host)

	if RegisteredInstanceTypes[instance.type].enter ~= nil then
		RegisteredInstanceTypes[instance.type].enter(instance)
	end
end

function LeaveInstance()
	if Instance.host ~= nil then

		if #Instance.players > 1 then
			ESX.ShowNotification(_U('left_instance'))
		end

		if RegisteredInstanceTypes[Instance.type].exit ~= nil then
			RegisteredInstanceTypes[Instance.type].exit(Instance)
		end

		TriggerServerEvent('instance:leave', Instance.host)
	end

	InsideInstance = false
end

function InviteToInstance(type, player, data)
	TriggerServerEvent('instance:invite', Instance.host, type, player, data)
end

function RegisterInstanceType(type, enter, exit)
	RegisteredInstanceTypes[type] = {
		enter = enter,
		exit  = exit
	}
end

AddEventHandler('instance:get', function(cb)
	cb(GetInstance())
end)

AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, data)
end)

AddEventHandler('instance:close', function()
	CloseInstance()
end)

AddEventHandler('instance:enter', function(instance)
	EnterInstance(instance)
end)

AddEventHandler('instance:leave', function()
	LeaveInstance()
end)

AddEventHandler('instance:invite', function(type, player, data)
	InviteToInstance(type, player, data)
end)

AddEventHandler('instance:registerType', function(name, enter, exit)
	RegisterInstanceType(name, enter, exit)
end)

RegisterNetEvent('instance:onInstancedPlayersData')
AddEventHandler('instance:onInstancedPlayersData', function(instancedPlayers)
	InstancedPlayers = instancedPlayers
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	Instance = instance
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onClose', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onClose')
AddEventHandler('instance:onClose', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onPlayerEntered')
AddEventHandler('instance:onPlayerEntered', function(instance, player)
	Instance = instance
	ESX.ShowNotification(GetPlayerName(GetPlayerFromServerId(player)) .. _('entered_into'))
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	Instance = instance
	ESX.ShowNotification(GetPlayerName(GetPlayerFromServerId(player)) .. _('left_out'))
end)

RegisterNetEvent('instance:onInvite')
AddEventHandler('instance:onInvite', function(instance, type, data)
	InstanceInvite = {
		type = type,
		host = instance,
		data = data
	}

	Citizen.CreateThread(function()
		Citizen.Wait(10000)

		if InstanceInvite ~= nil then
			ESX.ShowNotification(_U('invite_expired'))
			InstanceInvite = nil
		end
	end)
end)

RegisterInstanceType('default')

-- Input invites
CreateThread(function()
	while true do
	  Wait(1)
	  if InstanceInvite ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(_U('press_to_enter'))
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		if IsControlPressed(0, Keys['E']) then
		  EnterInstance(InstanceInvite)
		  ESX.ShowNotification(_U('entered_instance'))
		  InstanceInvite = nil
		end
	  end
	end
  end)

CreateThread(function()
	TriggerEvent('instance:loaded')
  end)