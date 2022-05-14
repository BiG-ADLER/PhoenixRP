ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)
	if not (xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'taxi') then
		return
	end
	TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)

		if amount < 0 then
			print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
		elseif account == nil then

			if xTarget ~= nil then
				MySQL.update('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target']      = xPlayer.identifier,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice'))
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!')
				end)
			end

		else

			if xTarget ~= nil then
				MySQL.update('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target']      = sharedAccountName,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_invoice'))
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!')
				end)
			end

		end
	end)

end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.query('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)


ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)

		local sender     = result[1].sender
		local targetType = result[1].target_type
		local target     = result[1].target
		local amount     = result[1].amount

		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then

			if xTarget ~= nil then

				if xPlayer.money >= amount then

					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)
						xTarget.addMoney(amount)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))

						cb()
					end)

				elseif xPlayer.bank >= amount then

					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeBank(amount)
						xTarget.addBank(amount)

						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))

						cb()
					end)

				else
					TriggerClientEvent('esx:showNotification', xTarget.source, _U('target_no_money'))

					cb()
				end

			else

				if xPlayer.money >= amount then

					MySQL.query.await('UPDATE users SET bank = bank + @bill WHERE identifier = @identifier',{
						['identifier'] 	= sender,
						['bill']		= amount
					})

					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)

						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						cb()
					end)

				elseif xPlayer.bank >= amount then

					MySQL.query.await('UPDATE users SET bank = bank + @bill WHERE identifier = @identifier',{
						['identifier'] 	= sender,
						['bill']		= amount
					})
					
					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeBank(amount)

						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))

						cb()
					end)

				else
					TriggerClientEvent('esx:showNotification', xTarget.source, _U('target_no_money'))

					cb()
				end

			end

		else

			TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)

				if xPlayer.money >= amount then

					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)

						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
						end

						cb()
					end)

				elseif xPlayer.bank >= amount then

					MySQL.update('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeBank(amount)

						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						if xTarget ~= nil then
							TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)))
						end

						cb()
					end)

				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('no_money'))

					if xTarget ~= nil then
						TriggerClientEvent('esx:showNotification', xTarget.source, _U('target_no_money'))
					end

					cb()
				end
			end)

		end

	end)
end)