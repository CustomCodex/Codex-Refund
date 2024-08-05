Config = {}

-- ASCII Art for Custom Code
Config.CustomCodeArt = [[
   ___              _                        ___             _             
  / __\ _   _  ___ | |_   ___   _ __ ___    / __\  ___    __| |  ___ __  __
 / /   | | | |/ __|| __| / _ \ | '_ ` _ \  / /    / _ \  / _` | / _ \\ \/ /
/ /___ | |_| |\__ \| |_ | (_) || | | | | |/ /___ | (_) || (_| ||  __/ >  < 
\____/  \__,_||___/ \__| \___/ |_| |_| |_|\____/  \___/  \__,_| \___|/_/\_\
]]

-- Function to Print the Custom Code Art
function printCustomCodeArt()
    print(Config.CustomCodeArt)
end

-- Call the function to display the ASCII art
printCustomCodeArt()

-- Display GitHub Link
print("Visit us at: https://github.com/CustomCodex")


Config.NotifySystem = "esx"

Config.SaveInventory = true         -- Save inventory items?(ATTENTION: Do only set it to true if you clear the inventory on death. Otherwise you will dupe the items!)
Config.SaveMoney = true             -- Save money? (ATTENTION: Do only set it to true if you delete money on death. Otherwise you will dupe the money!)
Config.SaveWeapons = true           -- Save Weapons? (ATTENTION: Do only set it to true if you delete the weapons on death. Otherwise you will dupe the weapons!)

Config.DeleteCodeAfterUse = true    -- Should the code be deleted after usage? I recommend =true)
Config.CodeFormat = "xxx-xxx-xxx"   -- The Code Format e.g xx-xx-xxxx, xxxxxx-xx-x-xxxxx

Config.RefundCommand = "refund"     -- The admin command to refund an inventory e.g /refund xxxx-xxxx-xxxx
Config.AllowedGroups = {            -- Which group should be able to use the command?
    'admin',
    'superadmin'
}


Config.PlayerDeathsWebhook = "YOUR_WEBHOOK_HERE"      -- Webhook sends Name of the dead player and the generated refund code
Config.RefundsWebhook = "YOUR_WEBHOOK_HERE"             -- Webhook sends the name of the Admin who refunded the inventory aswell as the refunded items


Config.DefaultLocale = 'en'

Config.Translations = {
    ['en'] = {
        ['error'] = 'Error',
        ['no_permission'] = 'No permission',
        ['inventory_refunded'] = 'Inventory refunded',
        ['your_inventory_refunded'] = 'Your inventory has been refunded.',
        ['inventory_successfully_refunded'] = 'Inventory successfully refunded.',
        ['player_not_online'] = 'Player not online',
        ['invalid_code'] = 'Invalid code',
        ['no_code_provided'] = 'No code provided',
        ['inventory_saved'] = 'Inventory saved',
        ['your_inventory_saved'] = 'Your inventory has been saved. Code: %s',
        ['death_webhook_title'] = 'Player Death',
        ['refund_webhook_title'] = 'Inventory Refund'
    },
    ['de'] = {
        ['error'] = 'Fehler',
        ['no_permission'] = 'Keine Berechtigung',
        ['inventory_refunded'] = 'Inventar zurückerstattet',
        ['your_inventory_refunded'] = 'Dein Inventar wurde zurückerstattet.',
        ['inventory_successfully_refunded'] = 'Inventar erfolgreich zurückerstattet.',
        ['player_not_online'] = 'Spieler nicht online',
        ['invalid_code'] = 'Ungültiger Code',
        ['no_code_provided'] = 'Kein Code angegeben',
        ['inventory_saved'] = 'Inventar gespeichert',
        ['your_inventory_saved'] = 'Dein Inventar wurde gespeichert. Code: %s',
        ['death_webhook_title'] = 'Spieler Tod',
        ['refund_webhook_title'] = 'Inventar Rückerstattung'
    },
    ['fr'] = {
        ['error'] = 'Erreur',
        ['no_permission'] = 'Pas de permission',
        ['inventory_refunded'] = 'Inventaire remboursé',
        ['your_inventory_refunded'] = 'Votre inventaire a été remboursé.',
        ['inventory_successfully_refunded'] = 'Inventaire remboursé avec succès.',
        ['player_not_online'] = 'Joueur non en ligne',
        ['invalid_code'] = 'Code invalide',
        ['no_code_provided'] = 'Aucun code fourni',
        ['inventory_saved'] = 'Inventaire sauvegardé',
        ['your_inventory_saved'] = 'Votre inventaire a été sauvegardé. Code : %s',
        ['death_webhook_title'] = 'Décès du joueur',
        ['refund_webhook_title'] = 'Remboursement d\'inventaire'
    },
    ['es'] = {
        ['error'] = 'Error',
        ['no_permission'] = 'Sin permiso',
        ['inventory_refunded'] = 'Inventario reembolsado',
        ['your_inventory_refunded'] = 'Tu inventario ha sido reembolsado.',
        ['inventory_successfully_refunded'] = 'Inventario reembolsado con éxito.',
        ['player_not_online'] = 'Jugador no en línea',
        ['invalid_code'] = 'Código inválido',
        ['no_code_provided'] = 'No se proporcionó ningún código',
        ['inventory_saved'] = 'Inventario guardado',
        ['your_inventory_saved'] = 'Tu inventario ha sido guardado. Código: %s',
        ['death_webhook_title'] = 'Muerte del jugador',
        ['refund_webhook_title'] = 'Reembolso de Inventario'
    },
    ['nl'] = {
        ['error'] = 'Fout',
        ['no_permission'] = 'Geen toestemming',
        ['inventory_refunded'] = 'Voorraad terugbetaald',
        ['your_inventory_refunded'] = 'Je voorraad is terugbetaald.',
        ['inventory_successfully_refunded'] = 'Voorraad succesvol terugbetaald.',
        ['player_not_online'] = 'Speler niet online',
        ['invalid_code'] = 'Ongeldige code',
        ['no_code_provided'] = 'Geen code opgegeven',
        ['inventory_saved'] = 'Voorraad opgeslagen',
        ['your_inventory_saved'] = 'Je voorraad is opgeslagen. Code: %s',
        ['death_webhook_title'] = 'Speler Dood',
        ['refund_webhook_title'] = 'Voorraad Terugbetaling'
    }
}

