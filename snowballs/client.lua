local function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterNetEvent('snowballs:give-direct', function(qty)
    qty = qty or (Config and Config.Qty) or 1
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end
    local hash = GetHashKey('WEAPON_SNOWBALL')
    GiveWeaponToPed(ped, hash, qty, false, true)
    notify("Dostal(a) jsi " .. qty .. " snowball(s).")
end)

Citizen.CreateThread(function()
    local showHelp = true
    local loaded = false

    while true do
        if Config and Config.Weather then
            SetWeatherTypeNowPersist('XMAS')
        end
        Citizen.Wait(0)

        if IsNextWeatherType('XMAS') then
            if not loaded then
                RequestNamedPtfxAsset("core_snow")
                while not HasNamedPtfxAssetLoaded("core_snow") do Citizen.Wait(0) end
                loaded = true
            end

            RequestAnimDict('anim@mp_snowball')

            if IsControlJustReleased(0, 46) and not IsPedInAnyVehicle(PlayerPedId(), true) then
                notify("Zvedáš " .. (Config and Config.Qty or 1) .. " snowball(s)...")

                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
                Citizen.Wait(1950)

                TriggerServerEvent('snowballs:add-item')
            end

            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if showHelp then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Stiskni E když jsi pěšky, pro zvednutí " .. (Config and Config.Qty or 1) .. " snowball(s)!")
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                end
                showHelp = false
            else
                showHelp = true
            end
        else
            if loaded then
                RemoveNamedPtfxAsset("core_snow")
                loaded = false
            end
        end
    end
end)
