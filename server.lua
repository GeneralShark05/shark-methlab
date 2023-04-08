------------------------------------------------------------
-- Startup --
------------------------------------------------------------
local ox_inventory = exports.ox_inventory

local outcome = {
    [2] = {item = 'sudo', count = 5}, -- Normal Sudo
    [3] = {item = 'phos', count = 4}, -- Normal Phos
    [4] = {item = 'meth_pure', count = 10}, -- Normal Batch
}

------------------------------------------------------------
-- Prep Lab --
------------------------------------------------------------

RegisterServerEvent('sharkmeth:localSet')
AddEventHandler('sharkmeth:localSet', function(type, value)
    local src = source
    if Config.labs[value].cookState >= type then
        return TriggerClientEvent('sharkmeth:notify', src, 'prepfail')
    else
        Config.labs[value].cookState = type
    end
end)

------------------------------------------------------------
-- Real Meth Lab --
------------------------------------------------------------

-- cough meds, acetone, leadedgas to sudo --
RegisterServerEvent('sharkmeth:extractSudo')
AddEventHandler('sharkmeth:extractSudo', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'fueldrugs', 'coughmeds'})
    if (items and items.acetone > 2 and items.fueldrugs > 4 and items.coughmeds > 9) or Config.ItemDebug and Config.labs[value].cookState == 1 then
        Config.labs[value].cookState = 0
        TriggerClientEvent("sharkmeth:cookAnim", src, value)
        ox_inventory:RemoveItem(src, 'acetone', 3)
        ox_inventory:RemoveItem(src, 'fueldrugs', 5)
        ox_inventory:RemoveItem(src, 'coughmeds', 10)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        Config.labs[value].cookState = 2
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end)
-- fertilizer, sulph, antifreeze to phos --
RegisterServerEvent('sharkmeth:extractPhos')
AddEventHandler('sharkmeth:extractPhos', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'fertilizer', 'antifreeze', 'sulph'})
    if (items and items.fertilizer > 4 and items.antifreeze > 3 and items.sulph >= 1) or Config.ItemDebug and Config.labs[value].cookState == 1 then
        Config.labs[value].cookState = 0
        TriggerClientEvent("sharkmeth:cookAnim", src, value)
        ox_inventory:RemoveItem(src, 'sulph', 1)
        ox_inventory:RemoveItem(src, 'antifreeze', 4)
        ox_inventory:RemoveItem(src, 'fertilizer', 5)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        ox_inventory:AddItem(src, 'empty_container', 1)
        Config.labs[value].cookState = 3
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end)

--sudo, phos, iodine to meth --
RegisterServerEvent('sharkmeth:cookMeth')
AddEventHandler('sharkmeth:cookMeth', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'sudo', 'phos', 'iodine'})
    if (items and items.sudo > 1 and items.phos >= 1 and items.iodine > 4) or Config.ItemDebug and Config.labs[value].cookState == 1 then
        Config.labs[value].cookState = 0
        TriggerClientEvent("sharkmeth:cookAnim", src, value)
        ox_inventory:RemoveItem(src, 'sudo', 2)
        ox_inventory:RemoveItem(src, 'phos', 1)
        ox_inventory:RemoveItem(src, 'iodine', 5)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        Config.labs[value].cookState = 4
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
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
        return TriggerClientEvent('sharkmeth:notify', src, 'collecterror')
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
        TriggerClientEvent('sharkmeth:notify', src, 'smashfail')
    end
end)
------------------------------------------------------------
-- Cheap Meth Lab --
------------------------------------------------------------


-- Cheap Sudo - Cough Meds, Water, acetone
RegisterServerEvent('sharkmeth:cheapSudo')
AddEventHandler('sharkmeth:cheapSudo', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'water', 'coughmeds'})
    if (items and items.acetone > 2 and items.water > 9 and items.coughmeds > 24) or Config.ItemDebug then
        TriggerClientEvent('sharkmeth:cheapAnim', src, 'sudo')
        ox_inventory:RemoveItem(src, 'acetone', 3)
        ox_inventory:RemoveItem(src, 'water', 10)
        ox_inventory:RemoveItem(src, 'coughmeds', 25)
        Citizen.Wait(20000)
        ox_inventory:AddItem(src, 'sudo', 3)
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)

-- Cheap Meth - Flare, Sudo, Iodine
RegisterServerEvent('sharkmeth:cheapCook')
AddEventHandler('sharkmeth:cheapCook', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'sudo', 'WEAPON_FLARE', 'iodine'})
    if (items and items.sudo > 1 and items.WEAPON_FLARE > 4 and items.iodine > 9) or Config.ItemDebug then
        TriggerClientEvent('sharkmeth:cheapAnim', src, 'meth')
        ox_inventory:RemoveItem(src, 'sudo', 1)
        ox_inventory:RemoveItem(src, 'weapon_flare', 5)
        ox_inventory:RemoveItem(src, 'iodine', 10)
        Citizen.Wait(20000)
        ox_inventory:AddItem(src, 'meth_brick', 1)
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)

------------------------------------------------------------
-- Gathering --
------------------------------------------------------------

RegisterServerEvent('sharkmeth:stealSulph')
AddEventHandler('sharkmeth:stealSulph', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'empty_container')
    if items >= 1 then
        TriggerClientEvent('sharkmeth:stealAcid', src)
        Citizen.Wait(10000)
        ox_inventory:RemoveItem(src, 'empty_container', 1)
        ox_inventory:AddItem(src, 'sulph', 1)
    else
        TriggerClientEvent('sharkmeth:notify', src, 'stealfail')
    end
end)

local hookId = ox_inventory:registerHook('buyItem', function(payload)
    if payload.count > 4 then
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
        weapon_flare = true,
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
    local callChance = 100
    callChance = math.random(100)
    if callChance <= 50 then
        exports.sonorancad:performApiRequest({{
            ["serverId"] = GetConvar("sonoran_serverId", 1),
            ["isEmergency"] = true,
            ["caller"] = 'Store Manager',
            ["location"] = '['..postal..'] '..streetname,
            ["description"] = 'Hi there, we have an individual here who has purchased a suspicious amount of '..item..'. We believe they may be involved with criminal activity.',
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
            ["caller"] = 'Bobcat Security',
            ["location"] = '[343] Palmer-Taylor Power Station',
            ["description"] = 'This is security from the Palmer-Taylor Power Station, we heard someone yelling and believe there may be a trespasser on the property.',
            ["metaData"] = {
                ["postal"] = 343
            }
        }}, "CALL_911")
    end
end)