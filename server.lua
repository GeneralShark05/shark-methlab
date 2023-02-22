--prep
PrepCook = false
local Cooked = false
local ox_inventory = exports.ox_inventory

--prepare lab
RegisterServerEvent('sharkmeth:prepcook')
AddEventHandler('sharkmeth:prepcook', function()
    local src = source
    if PrepCook == false then
        TriggerClientEvent('ultra-voltlab', 45, function(outcome ,reason)
                if outcome == 1 then
                    TriggerClientEvent('sharkmeth:notify', 'prepsucess')
                    PrepCook = true
                else
                TriggerClientEvent('sharkmeth:notify', 'prepfail2')
                end
            end)
    else
        return TriggerClientEvent('sharkmeth:notify', src, 'prepfail')
    end
end
)

--cook meth
RegisterServerEvent('sharkmeth:startcook')
AddEventHandler('sharkmeth:startcook', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'acetone', 'antifreeze', 'sudo'})
    if items and items.acetone > 2 and items.antifreeze > 4 and items.sudo > 9 and PrepCook == true and Cooked == false then
        TriggerClientEvent("sharkmeth:cook")
        ox_inventory:RemoveItem(src, 'acetone', 3)
        ox_inventory:RemoveItem(src, 'antifreeze', 5)
        ox_inventory:RemoveItem(src, 'sudo', 10)

        PrepCook = false
        Cooked = true
        return TriggerClientEvent('sharkmeth:notify', src, 'cooksuccess')
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
    ox_inventory:AddItem(src, 'methpure', 5)
end
)

--smash meth
RegisterServerEvent('sharkmeth:smash')
AddEventHandler('sharkmeth:smash', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', {'methpure', 'plasticwrap', 'hammer'})
    if items and items.hammer >= 1 and items.methpure >= 1 and items.plasticwrap >= 1 then
        TriggerClientEvent('sharkmeth:smashy', src)
        ox_inventory:RemoveItem(src, 'methpure', 1)
        ox_inventory:RemoveItem(src, 'plasticwrap', 1)
        ox_inventory:AddItem(src, 'methbrick', 1)
    elseif items.methpure >= 1 and items.plasticwrap >= 1 then
        TriggerClientEvent('sharkmeth:notify', src, 'smashfail1')
    elseif items and items.hammer <= 0 then
        TriggerClientEvent("sharkmeth:notify", src, 'smashfail2')
    end
end)