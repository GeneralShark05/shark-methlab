--prep
local ox_inventory = exports.ox_inventory

local labs = {
    [1] = {CookState = 0},
    [2] = {CookState = 0},
    [3] = {CookState = 0},
}

local drugs = {
    [2] = {item = 'sudo', count = 5},
    [3] = {item ='phos', count = 4},
    [4] = {item = 'meth_pure', count = 10}
}
-- Status 0 = Not prepped, Status 1 = Prepped, Status 2 = Cooked Sudo, 3 = Cooked Phos, 4 = Cooked Meth
--prepare lab
RegisterServerEvent('sharkmeth:localset')
AddEventHandler('sharkmeth:localset', function(type, value)
    local src = source
    if labs[value].CookState >= type then
        return TriggerClientEvent('sharkmeth:notify', src, 'prepfail')
    else
    labs[value].CookState = type
    end
end
)

-- cough meds, acetone, leadedgas to sudo --
RegisterServerEvent('sharkmeth:extractsudo')
AddEventHandler('sharkmeth:extractsudo', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'fueldrugs', 'coughmeds'})
    if items and items.acetone > 2 and items.fueldrugs > 4 and items.coughmeds > 9 and labs[value].CookState == 1 then
        labs[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'acetone', 3)
        ox_inventory:RemoveItem(src, 'fueldrugs', 5)
        ox_inventory:RemoveItem(src, 'coughmeds', 10)
        Citizen.Wait(40000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        labs[value].CookState = 2
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)
-- fertilizer, sulph, antifreeze to phos --
RegisterServerEvent('sharkmeth:extractphos')
AddEventHandler('sharkmeth:extractphos', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'fertilizer', 'antifreeze', 'sulph'})
    if items and items.fertilizer > 9 and items.antifreeze > 7 and items.sulph > 1 and labs[value].CookState == 1 then
        labs[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'sulph', 2)
        ox_inventory:RemoveItem(src, 'antifreeze', 8)
        ox_inventory:RemoveItem(src, 'fertilizer', 10)
        Citizen.Wait(40000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        labs[value].CookState = 3
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)

--sudo, phos, iodine to meth --
RegisterServerEvent('sharkmeth:cookmeth')
AddEventHandler('sharkmeth:cookmeth', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'sudo', 'phos', 'iodine'})
    if items and items.sudo > 3 and items.phos > 0 and items.iodine > 9 and labs[value].CookState == 1 then
        labs[value].CookState = 0
        TriggerClientEvent("sharkmeth:cook", src, value)
        ox_inventory:RemoveItem(src, 'sudo', 4)
        ox_inventory:RemoveItem(src, 'phos', 1)
        ox_inventory:RemoveItem(src, 'iodine', 10)
        Citizen.Wait(40000)
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
        labs[value].CookState = 4
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)

--collect meth
RegisterServerEvent('sharkmeth:collect')
AddEventHandler('sharkmeth:collect', function(value)
    local src = source
    local cooktype = labs[value].CookState
    if labs[value].CookState > 1 then
        ox_inventory:AddItem(src, drugs[cooktype].item, drugs[cooktype].count)
        labs[value].CookState = 0
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'collecterror')
    end
end
)

--smash meth
RegisterServerEvent('sharkmeth:smash')
AddEventHandler('sharkmeth:smash', function(value)
    local src = source
    local items = ox_inventory:Search(src, 'count', {'meth_pure', 'plasticwrap', 'WEAPON_HAMMER'})
    if items and items.WEAPON_HAMMER > 0 and items.meth_pure > 0 and items.plasticwrap > 0 then
        TriggerClientEvent('sharkmeth:smashy', src, value)
        ox_inventory:RemoveItem(src, 'meth_pure', 1)
        ox_inventory:RemoveItem(src, 'plasticwrap', 1)
        Citizen.Wait(10000)
        ox_inventory:AddItem(src, 'meth_brick', 1)
    else
        TriggerClientEvent('sharkmeth:notify', src, 'smashfail')
    end
end)

--smash meth
RegisterServerEvent('sharkmeth:stealsulph')
AddEventHandler('sharkmeth:stealsulph', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'empty_container')
    if items > 0 then
        TriggerClientEvent('sharkmeth:stealy', src)
        Citizen.Wait(10000)
        ox_inventory:RemoveItem(src, 'empty_container', 1)
        ox_inventory:AddItem(src, 'sulph', 1)
    else
        TriggerClientEvent('sharkmeth:notify', src, 'stealfail')
    end
end)

--costas a fucktard