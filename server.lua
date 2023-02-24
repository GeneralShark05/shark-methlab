--prep
local PrepCook = false
local Cooked = false
local ox_inventory = exports.ox_inventory

    --prepare lab
RegisterServerEvent('sharkmeth:prepcook')
AddEventHandler('sharkmeth:prepcook', function()
    PrepCook = true
end
)

--cook meth
RegisterServerEvent('sharkmeth:startcook')
AddEventHandler('sharkmeth:startcook', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'fertilizer', 'fueldrugs', 'coughmeds'})
    if items and items.fertilizer > 2 and items.fueldrugs > 4 and items.coughmeds > 9 and PrepCook == true and Cooked == false then
        TriggerClientEvent("sharkmeth:cook", src)
        ox_inventory:RemoveItem(src, 'fertilizer', 3)
        ox_inventory:RemoveItem(src, 'fueldrugs', 5)
        ox_inventory:RemoveItem(src, 'coughmeds', 10)

        PrepCook = false
        Cooked = true
        TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'cookfail')
    end
end
)

--collect meth
RegisterServerEvent('sharkmeth:collect')
AddEventHandler('sharkmeth:collect', function()
    local src = source
    Cooked = false
    return ox_inventory:AddItem(src, 'meth_pure', 5)
end
)

--smash meth
RegisterServerEvent('sharkmeth:smash')
AddEventHandler('sharkmeth:smash', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'meth_pure', 'plasticwrap', 'WEAPON_HAMMER'})
    if items and items.WEAPON_HAMMER >= 1 and items.meth_pure >= 1 and items.plasticwrap >= 1 then
        TriggerClientEvent('sharkmeth:smashy', src)
        ox_inventory:RemoveItem(src, 'meth_pure', 1)
        ox_inventory:RemoveItem(src, 'plasticwrap', 1)
        Citizen.Wait(10000)
        ox_inventory:AddItem(src, 'meth_brick', 1)
    else
        TriggerClientEvent('sharkmeth:notify', src, 'smashfail')
    end
end)


--costas a fucktard