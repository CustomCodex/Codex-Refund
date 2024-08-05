local ESX = exports["es_extended"]:getSharedObject()
local notificationLibrary = nil

-- Initialize notificationLibrary based on the configured notification system
if Config.NotifySystem == "esx" then
    notificationLibrary = function(target, type, text)
        TriggerClientEvent('esx:showNotification', target, text)
    end
elseif Config.NotifySystem == "okokNotify" then
    notificationLibrary = function(source, type, Label, message, duration)
        TriggerClientEvent('codem-notification:alert', source, type, Label, message, duration)
    end
elseif Config.NotifySystem == "mythicNotify" then
    notificationLibrary = function(source, type, text)
        exports['mythic_notify']:SendAlert(type, text)
    end
else
    print("Error: Notification system not configured properly.")
end

local function notifyPlayer(source, type, message, label, duration)
    if Config.NotifySystem == "esx" then
        notificationLibrary(source, type, message)
    elseif Config.NotifySystem == "okokNotify" then
        notificationLibrary(source, type, label, message, duration)
    elseif Config.NotifySystem == "mythicNotify" then
        notificationLibrary(source, type, message)
    end
end

local function fetchDeathRecord(code, callback)
    exports.oxmysql:execute('SELECT * FROM death WHERE code = ?', {code}, function(result)
        if not result or #result == 0 then
            callback(nil, "Invalid code or no record found.")
        else
            callback(result[1], nil)
        end
    end)
end

local function refundPlayer(targetPlayer, record)
    if Config.SaveInventory then
        local inventory = json.decode(record.inventory)
        for i = 1, #inventory do
            local item = inventory[i]
            targetPlayer.addInventoryItem(item.name, item.count)
        end
    end
    if Config.SaveMoney then
        local money = record.money
        targetPlayer.addMoney(money)
    end
    if Config.SaveWeapons then
        local weapons = json.decode(record.weapons)
        for i = 1, #weapons do
            local weapon = weapons[i]
            targetPlayer.addWeapon(weapon.name, weapon.ammo)
        end
    end
end

local function logRefund(source, targetPlayer, record)
    local playerName = GetPlayerName(targetPlayer.source)
    local adminName = GetPlayerName(source)
    local refundedItems = {}

    if Config.SaveInventory then
        local inventory = json.decode(record.inventory)
        for i = 1, #inventory do
            local item = inventory[i]
            if item.count > 0 then
                table.insert(refundedItems, {label = item.name, count = item.count})
            end
        end
    end

    local refundInfo = {
        title = "Refund Notification",
        color = 3066993,  -- Green color
        fields = {
            { name = "Admin", value = adminName, inline = true },
            { name = "Player", value = playerName, inline = true },
            { name = "Description", value = "The player's inventory, money, and weapons have been successfully refunded using the provided code.", inline = false },
            { name = "Refunded Items", value = tableToString(refundedItems), inline = false },
            { name = "Refunded Money", value = "$" .. (record.money or "0"), inline = true },
            { name = "Refunded Weapons", value = tableToString(json.decode(record.weapons) or {}), inline = false }
        }
    }

    if Config.RefundsWebhook then
        PerformHttpRequest(Config.RefundsWebhook, function(err, text, headers) 
            if err then
                print("Error sending refund webhook: " .. err)
            end
        end, 'POST', json.encode({embeds = {refundInfo}}), { ['Content-Type'] = 'application/json' })
    end
end

local function logDeath(source, record)
    local playerName = GetPlayerName(source)
    local deathInfo = {
        title = "Player Death Notification",
        color = 15158332,  -- Red
        fields = {
            { name = "Player", value = playerName, inline = true },
            { name = "Code", value = record.code or "None", inline = true },
            { name = "Description", value = "The player's inventory and other assets have been saved for refund purposes. The code above can be used to restore the player's complete inventory.", inline = false },
            { name = "Instructions", value = "You can easily copy or type this code in-game using the /refund code command to restore your items, money, and weapons.", inline = false }
        }
    }

    if Config.PlayerDeathsWebhook then
        PerformHttpRequest(Config.PlayerDeathsWebhook, function(err, text, headers) 
            if err then
                print("Error sending death webhook: " .. err)
            end
        end, 'POST', json.encode({embeds = {deathInfo}}), { ['Content-Type'] = 'application/json' })
    end
end



RegisterCommand(Config.RefundCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local locale = xPlayer.get('locale') or Config.DefaultLocale or 'en'
    local _L = Config.Translations[locale] or {}

    if Config.AllowedGroups and #Config.AllowedGroups > 0 then
        local allowed = false
        for i = 1, #Config.AllowedGroups do
            if xPlayer.getGroup() == Config.AllowedGroups[i] then
                allowed = true
                break
            end
        end
        if not allowed then
            notifyPlayer(source, 'error', _L['no_permission'], _L['error'], 5000)
            return
        end
    end

    local code = args[1]
    if code then
        fetchDeathRecord(code, function(record, errMsg)
            if record then
                local targetPlayer = ESX.GetPlayerFromIdentifier(record.identifier)
                if targetPlayer then
                    refundPlayer(targetPlayer, record)
                    notifyPlayer(targetPlayer.source, 'success', _L['inventory_refunded'], string.format(_L['your_inventory_refunded_popup'], code), 5000)
                    notifyPlayer(source, 'success', _L['inventory_refunded'], _L['inventory_successfully_refunded'], 5000)

                    if Config.DeleteCodeAfterUse then
                        exports.oxmysql:execute('DELETE FROM death WHERE code = ?', {code})
                    end

                    logRefund(source, targetPlayer, record)
                else
                    notifyPlayer(source, 'error', _L['player_not_online'], _L['error'], 5000)
                end
            else
                notifyPlayer(source, 'error', errMsg, _L['error'], 5000)
            end
        end)
    else
        notifyPlayer(source, 'error', _L['no_code_provided'], _L['error'], 5000)
    end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local locale = xPlayer.get('locale') or Config.DefaultLocale or 'en'
    local _L = Config.Translations[locale] or {}
    local inventoryCode = generateCode()
    deathCode = inventoryCode 
    if Config.SaveInventory or Config.SaveMoney or Config.SaveWeapons then
        local playerInventory = Config.SaveInventory and xPlayer.getInventory() or {}
        local playerMoney = Config.SaveMoney and xPlayer.getMoney() or 0
        local playerWeapons = Config.SaveWeapons and xPlayer.getLoadout() or {}
        exports.oxmysql:execute('INSERT INTO death (identifier, inventory, money, weapons, code) VALUES (?, ?, ?, ?, ?)', {
            xPlayer.identifier,
            json.encode(playerInventory),
            playerMoney,
            json.encode(playerWeapons),
            inventoryCode
        }, function()
            notifyPlayer(_source, 'success', (_L['your_inventory_saved']):format(inventoryCode), _L['inventory_saved'], 5000)
            logDeath(_source, { code = deathCode })
        end)
    end
end)

function generateCode()
    local codeFormat = Config.CodeFormat or "xxxx-xxxx-xxxx"
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local code = ''
    for i = 1, #codeFormat do
        local char = codeFormat:sub(i, i)
        if char == "x" then
            local charIndex = math.random(#chars)
            code = code .. chars:sub(charIndex, charIndex)
        elseif char == "-" then
            code = code .. "-"
        else
            code = code .. char
        end
    end
    return code
end

function tableToString(table)
    local str = ''
    for i, v in ipairs(table) do
        str = str .. v.label .. ': ' .. v.count .. '\n'
    end
    return str
end
