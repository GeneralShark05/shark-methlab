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

RegisterServerEvent('sharkmeth:localset')
AddEventHandler('sharkmeth:localset', function(type, value)
    local src = source
    if Config.labs.meth[value].CookState >= type then
        return TriggerClientEvent('sharkmeth:notify', src, 'prepfail')
    else
    Config.labs.meth[value].CookState = type
    end
end
)

------------------------------------------------------------
-- Real Meth Lab --
------------------------------------------------------------

-- cough meds, acetone, leadedgas to sudo --
RegisterServerEvent('sharkmeth:extractsudo')
AddEventHandler('sharkmeth:extractsudo', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'fueldrugs', 'coughmeds'})
    if items and items.acetone > 2 and items.fueldrugs > 4 and items.coughmeds > 9 and Config.labs.meth[value].CookState == 1 then
        Config.labs.meth[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'acetone', 3)
        ox_inventory:RemoveItem(src, 'fueldrugs', 5)
        ox_inventory:RemoveItem(src, 'coughmeds', 10)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        Config.labs.meth[value].CookState = 2
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end)
-- fertilizer, sulph, antifreeze to phos --
RegisterServerEvent('sharkmeth:extractphos')
AddEventHandler('sharkmeth:extractphos', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'fertilizer', 'antifreeze', 'sulph'})
    if items and items.fertilizer > 4 and items.antifreeze > 3 and items.sulph >= 1 and Config.labs.meth[value].CookState == 1 then
        Config.labs.meth[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'sulph', 1)
        ox_inventory:RemoveItem(src, 'antifreeze', 4)
        ox_inventory:RemoveItem(src, 'fertilizer', 5)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        ox_inventory:AddItem(src, 'empty_container', 1)
        Config.labs.meth[value].CookState = 3
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end)

--sudo, phos, iodine to meth --
RegisterServerEvent('sharkmeth:cookmeth')
AddEventHandler('sharkmeth:cookmeth', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'sudo', 'phos', 'iodine'})
    if items and items.sudo > 1 and items.phos >= 1 and items.iodine > 4 and Config.labs.meth[value].CookState == 1 then
        Config.labs.meth[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'sudo', 2)
        ox_inventory:RemoveItem(src, 'phos', 1)
        ox_inventory:RemoveItem(src, 'iodine', 5)
        Citizen.Wait(80000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        Config.labs.meth[value].CookState = 4
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end)

--collect meth
RegisterServerEvent('sharkmeth:collect')
AddEventHandler('sharkmeth:collect', function(value)
    local src = source
    local cooktype = Config.labs.meth[value].CookState
    if Config.labs.meth[value].CookState > 1 then
        ox_inventory:AddItem(src, outcome[cooktype].item, outcome[cooktype].count)
        if Config.labs.meth[value].Count > 2 then
            Config.labs.meth[value].CookState = 0
            Config.labs.meth[value].Count = 0
        else
            Config.labs.meth[value].CookState = 1
            Config.labs.meth[value].Count = Config.labs.meth[value].Count + 1
        end
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'collecterror')
    end
end)

--smash meth
RegisterServerEvent('sharkmeth:smash')
AddEventHandler('sharkmeth:smash', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'meth_pure', 'plasticwrap', 'WEAPON_HAMMER'})
    if items and items.WEAPON_HAMMER > 0 and items.meth_pure > 0 and items.plasticwrap > 0 then
        TriggerClientEvent('sharkmeth:smashy', src, value)
        ox_inventory:RemoveItem(src, 'meth_pure', 1)
        ox_inventory:RemoveItem(src, 'plasticwrap', 1)
        Citizen.Wait(5000)
        ox_inventory:AddItem(src, 'meth_brick', 1)
    else
        TriggerClientEvent('sharkmeth:notify', src, 'smashfail')
    end
end)
------------------------------------------------------------
-- Cheap Meth Lab --
------------------------------------------------------------


-- Cheap Sudo - Cough Meds, Water, acetone
RegisterServerEvent('sharkmeth:cheapsudo')
AddEventHandler('sharkmeth:cheapsudo', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'water', 'coughmeds'})
    if items and items.acetone > 2 and items.water > 9 and items.coughmeds > 24 then
        TriggerClientEvent('sharkmeth:cookcheap', src, 'sudo')
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
RegisterServerEvent('sharkmeth:cheapcook')
AddEventHandler('sharkmeth:cheapcook', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'sudo', 'WEAPON_FLARE', 'iodine'})
    if items and items.sudo > 1 and items.WEAPON_FLARE > 4 and items.iodine > 9 then
        TriggerClientEvent('sharkmeth:cookcheap', src, 'meth')
        ox_inventory:RemoveItem(src, 'sudo', 1)
        ox_inventory:RemoveItem(src, 'weapon_flare', 5)
        ox_inventory:RemoveItem(src, 'iodine', 10)
        Citizen.Wait(20000)
        ox_inventory:AddItem(src, 'meth_brick', 3)
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

local hookId = exports.ox_inventory:registerHook('buyItem', function(payload)
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

RegisterServerEvent('sharkmeth:picked')
AddEventHandler('sharkmeth:picked', function(type, success)
    if success then
        local quantity = math.random(4)
        ox_inventory:AddItem(source, type, quantity)
        TriggerClientEvent('ox_lib:skillCheck', source, {type = 'success', description = 'You picked the crop.'})
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'You damaged the crop!'})
    end
end)

------------------------------------------------------------
-- SonoranCAD Calls --
------------------------------------------------------------

RegisterServerEvent('sharkmeth:buyalert')
AddEventHandler('sharkmeth:buyalert', function(streetname, postal, item)
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
RegisterServerEvent('sharkmeth:powerplant')
AddEventHandler('sharkmeth:powerplant', function()
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