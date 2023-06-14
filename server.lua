local localSet = Locales[Config.Lang]
------------------------------------------------------------
-- Startup --
------------------------------------------------------------
local ox_inventory = exports.ox_inventory

local outcome = { -- Different outcomes, outcome 0 is Nil, 1 is Prepped
    [2] = {item = 'sudo', count = Config.CookSudo}, -- Normal Sudo
    [3] = {item = 'phos', count = Config.CookPhos}, -- Normal Phos
    [4] = {item = 'meth_pure', count = Config.CookReward}, -- Normal Batch
}
------------------------------------------------------------
-- Prep Lab --
------------------------------------------------------------
RegisterServerEvent('sharkmeth:labSet')
AddEventHandler('sharkmeth:labSet', function(type, value)
    local src = source
    if Config.labs[value].cookState >= type then -- If the lab is set to a status greater or equal to, prevents overridding
        return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifPrepFai[1], description = localSet.NotifPrepFai[2], type = localSet.NotifPrepFai[3]})
    else
        Config.labs[value].cookState = type
    end
end)
------------------------------------------------------------
-- Real Meth Lab --
------------------------------------------------------------
RegisterServerEvent('sharkmeth:cookLab')
AddEventHandler('sharkmeth:cookLab', function(value, type)
    local src = source
    local CookTime = Config.CookTime
    if Config.labs[value].cookState == 1 and Config.labs[value].activeCook == false then
        if type == 'meth' then
            local items = ox_inventory:Search(src, 'count', {'sudo', 'phos', 'iodine'})
            if (items and items.sudo >= 2 and items.phos >= 1 and items.iodine >= 5) or Config.ItemDebug then
                Config.labs[value].cookState = 0
                Config.labs[value].activeCook = true

                TriggerClientEvent("sharkmeth:cookAnim", src, value)
                ox_inventory:RemoveItem(src, 'sudo', 2)
                ox_inventory:RemoveItem(src, 'phos', 1)
                ox_inventory:RemoveItem(src, 'iodine', 5)
                Citizen.Wait(CookTime)
                TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookSuc[1], description = localSet.NotifCookSuc[2], type = localSet.NotifCookSuc[3]})

                Config.labs[value].activeCook = false
                Config.labs[value].cookState = 4
            else
                return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
            end
        elseif type == 'sudo' then
            local items = ox_inventory:Search(src, 'count', {'acetone', 'WEAPON_PETROLCAN', 'coughmeds'})
            if (items and items.acetone >= 3 and items.WEAPON_PETROLCAN >= 1 and items.coughmeds >= 10) or Config.ItemDebug then
                Config.labs[value].cookState = 0
                Config.labs[value].activeCook = true

                TriggerClientEvent("sharkmeth:cookAnim", src, value)
                ox_inventory:RemoveItem(src, 'acetone', 3)
                ox_inventory:RemoveItem(src, 'WEAPON_PETROLCAN', 1)
                ox_inventory:RemoveItem(src, 'coughmeds', 10)
                Citizen.Wait(CookTime)
                TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookSuc[1], description = localSet.NotifCookSuc[2], type = localSet.NotifCookSuc[3]})

                Config.labs[value].activeCook = false
                Config.labs[value].cookState = 2
            else
                return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
            end
        elseif type == 'phos' then 
            local items = ox_inventory:Search(src, 'count', {'fertilizer', 'antifreeze', 'sulph'})
            if (items and items.fertilizer >= 5 and items.antifreeze >= 4 and items.sulph >= 1) or Config.ItemDebug then
                Config.labs[value].cookState = 0
                Config.labs[value].activeCook = true

                TriggerClientEvent("sharkmeth:cookAnim", src, value)
                ox_inventory:RemoveItem(src, 'sulph', 1)
                ox_inventory:RemoveItem(src, 'antifreeze', 4)
                ox_inventory:RemoveItem(src, 'fertilizer', 5)
                Citizen.Wait(CookTime)
                TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookSuc[1], description = localSet.NotifCookSuc[2], type = localSet.NotifCookSuc[3]})

                ox_inventory:AddItem(src, 'empty_container', 1)
                Config.labs[value].activeCook = false
                Config.labs[value].cookState = 3
            else
                return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
            end
        end
    else
        return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
    end
end)
--collect meth
RegisterServerEvent('sharkmeth:collect')
AddEventHandler('sharkmeth:collect', function(value)
    local src = source
    local cooktype = Config.labs[value].cookState
    if Config.labs[value].cookState > 1 then
        ox_inventory:AddItem(src, outcome[cooktype].item, outcome[cooktype].count)
        if Config.labs[value].count > 2 then
            Config.labs[value].cookState = 0
            Config.labs[value].count = 0
        else
            Config.labs[value].cookState = 1
            Config.labs[value].count = Config.labs[value].count + 1
        end
    else
        return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
    end
end)

--smash meth
RegisterServerEvent('sharkmeth:smashServer')
AddEventHandler('sharkmeth:smashServer', function(value)
    local src = source
    local breakCount = 1
    local items = ox_inventory:Search(src, 'count', {'meth_pure', 'plasticwrap', 'WEAPON_HAMMER'})
    if items and items.WEAPON_HAMMER >= 1 and items.meth_pure >= 1 and items.plasticwrap >= 1 then
        if items.meth_pure >= 3 and items.plasticwrap >= 3 then
            breakCount = 3
        elseif items.meth_pure >= 2 and items.plasticwrap >= 2 then
            breakCount = 2
        end
        TriggerClientEvent('sharkmeth:smashAnim', src, value)
        ox_inventory:RemoveItem(src, 'meth_pure', breakCount)
        ox_inventory:RemoveItem(src, 'plasticwrap', breakCount)
        Citizen.Wait(14200)
        ox_inventory:AddItem(src, 'meth_brick', breakCount)
    else
        return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifSmashFai[1], description = localSet.NotifSmashFai[2], type = localSet.NotifSmashFai[3]})        
    end
end)
------------------------------------------------------------
-- Cheap Meth Lab --
------------------------------------------------------------
RegisterServerEvent('sharkmeth:cheapCook')
AddEventHandler('sharkmeth:cheapCook', function(type)
    local src = source
    local CookTime = Config.CheapCookTime
    if type == 'sudo' then
        local items = ox_inventory:Search(src, 'count', {'acetone', 'water', 'coughmeds'})
        if Config.cheapMeth.activeCook1 == false and (items and items.acetone >= 3 and items.water >= 10 and items.coughmeds >= 25) or Config.ItemDebug then
            Config.cheapMeth.activeCook1 = true

            TriggerClientEvent('sharkmeth:cheapAnim', src, 'sudo')
            ox_inventory:RemoveItem(src, 'acetone', 3)
            ox_inventory:RemoveItem(src, 'water', 10)
            ox_inventory:RemoveItem(src, 'coughmeds', 25)
            Citizen.Wait(CookTime)

            ox_inventory:AddItem(src, 'sudo', Config.CookSudo)
            Config.cheapMeth.activeCook1 = false
        else
            return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
        end
    elseif type == 'meth' then
        local items = ox_inventory:Search(src, 'count', {'sudo', 'WEAPON_FLARE', 'iodine'})
        if Config.cheapMeth.activeCook2 == false and (items and items.sudo >= 1 and items.WEAPON_FLARE >= 5 and items.iodine >= 10) or Config.ItemDebug then
            Config.cheapMeth.activeCook2 = true

            TriggerClientEvent('sharkmeth:cheapAnim', src, 'meth')
            ox_inventory:RemoveItem(src, 'sudo', 1)
            ox_inventory:RemoveItem(src, 'WEAPON_FLARE', 5)
            ox_inventory:RemoveItem(src, 'iodine', 10)
            Citizen.Wait(CookTime)

            ox_inventory:AddItem(src, 'meth_brick', Config.CheapReward)
            Config.cheapMeth.activeCook2 = false
        else
            return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifCookFai[1], description = localSet.NotifCookFai[2], type = localSet.NotifCookFai[3]})
        end
    end
end)
------------------------------------------------------------
-- Gathering --
------------------------------------------------------------
local activeSteal = false

RegisterServerEvent('sharkmeth:stealSulph')
AddEventHandler('sharkmeth:stealSulph', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'empty_container')
    if items >= 1 and activeSteal == false then
        activeSteal = true

        ox_inventory:RemoveItem(src, 'empty_container', 1)
        TriggerClientEvent('sharkmeth:stealAcid', src)
        Citizen.Wait(10000)

        ox_inventory:AddItem(src, 'sulph', 1)
        activeSteal = false
    else
        return TriggerClientEvent('ox_lib:notify', src, {title = localSet.NotifStealFai[1], description = localSet.NotifStealFai[2], type = localSet.NotifStealFai[3]})
    end
end)

local hookId = ox_inventory:registerHook('buyItem', function(payload)
    if payload.count > Config.BuyAmount then
        local src = payload.source
        local item = payload.itemName
        local ped = GetPlayerPed(src)
        local v = GetEntityCoords(ped)
        local x,y,z = table.unpack(v)
        TriggerClientEvent('sharkmeth:getStreet', src, x, y, z, item)
        return true
    end
end,
{
    itemFilter = {
        coughmeds = true,
        fertilizer = true,
        WEAPON_FLARE = true,
        iodine = true,
        antifreeze = true,
        acetone = true,
      },
})

------------------------------------------------------------
-- SonoranCAD Calls --
------------------------------------------------------------

RegisterServerEvent('sharkmeth:buyAlert')
AddEventHandler('sharkmeth:buyAlert', function(streetname, postal, item)
    local callChance = math.random(100)
    if callChance <= Config.BuyChance then
        exports.sonorancad:performApiRequest({{
            ["serverId"] = GetConvar("sonoran_serverId", 1),
            ["isEmergency"] = true,
            ["caller"] = localSet.AlertBuy[1],
            ["location"] = '['..postal..'] '..streetname,
            ["description"] = localSet.AlertBuy[2]..item..localSet.AlertBuy[3],
            ["metaData"] = {
                ["postal"] = postal
            }
        }}, "CALL_911")
    end
end)

RegisterServerEvent('sharkmeth:stealAlert')
AddEventHandler('sharkmeth:stealAlert', function()
    if Config.SonoranCAD then
        exports.sonorancad:performApiRequest({{
            ["serverId"] = GetConvar("sonoran_serverId", 1),
            ["isEmergency"] = true,
            ["caller"] = localSet.AlertSteal[1],
            ["location"] = localSet.AlertSteal[2],
            ["description"] = localSet.AlertSteal[3],
            ["metaData"] = {
                ["postal"] = 343
            }
        }}, "CALL_911")
    end
end)