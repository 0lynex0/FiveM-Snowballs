local Core = exports['qb-core']:GetCoreObject()

RegisterNetEvent("snowballs:add-item", function()
    local src = source
    local Player = Core.Functions.GetPlayer(src)

    if Player then
        local qty = (Config and Config.Qty) or 1
        local added = Player.Functions.AddItem('weapon_snowball', qty)
        if added then
            TriggerClientEvent('inventory:client:ItemBox', src, Core.Shared.Items['weapon_snowball'], 'add')
            return
        end
    end

    -- fallback: pokud selže inventář, dáme koule lokálně
    TriggerClientEvent('snowballs:give-direct', src, (Config and Config.Qty) or 1)
end)
