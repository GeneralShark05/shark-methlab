local ox_target = exports.ox_target
local localSet = Locales[Config.Lang]
local isBusy = false
-------------------------------------------------------
-- Targetting  --
------------------------------------------------------------
for k,v in ipairs(Config.labs) do
    ----- Prep Collect ----- 
    ox_target:addBoxZone({
        coords = vector3(Config.labs[k].prepTarget),
        size = vector3(0.7, 1, 1.1),
        rotation = Config.labs[k].prepRotate,
        debug = Config.Debug,
        options = {
            {
                name = 'prepcook',
                onSelect = function() TriggerEvent('sharkmeth:prepAnim', k) end,
                icon = 'fa-solid fa-clipboard',
                label = localSet.TargetPrep,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            },
            {
                name = 'ox:option1',
                onSelect = function() TriggerServerEvent('sharkmeth:collect', k) end,
                icon = 'fa-solid fa-hard-drive',
                label = localSet.TargetGrab,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            }
        }
    })

    ----- Cooking ----- 
    ox_target:addSphereZone({
        coords = vector3(Config.labs[k].cookTarget),
        radius = 0.4,
        debug = Config.Debug,
        options = {
            {
                name = 'ox:option1',
                onSelect = function() TriggerServerEvent('sharkmeth:cookLab', k, 'sudo') end,
                icon = 'fa-solid fa-vial',
                label = localSet.TargetSudo,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            },
            {
                name = 'ox:option2',
                onSelect = function() TriggerServerEvent('sharkmeth:cookLab', k, 'phos') end,
                icon = 'fa-solid fa-flask',
                label = localSet.TargetPhos,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            },
            {
                name = 'ox:option3',
                onSelect = function() TriggerServerEvent('sharkmeth:cookLab', k, 'meth')end,
                icon = 'fa-solid fa-flask-vial',
                label = localSet.TargetCook,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            }
        }
    })

    ----- Break Table ----- 
    ox_target:addBoxZone({
        coords = vector3(Config.labs[k].hammerTarget),
        size = vector3(2, 1, 0.5),
        rotation = Config.labs[k].hammerRotate,
        debug = Config.Debug,
        options = {
            {
                name = 'ox:option1',
                onSelect = function() TriggerServerEvent('sharkmeth:smashServer', k)end,
                icon = 'fa-solid fa-hammer',
                label = localSet.TargetSmash,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isBusy
                end
            }
        }
    })
end

-- Cheap Lab --
ox_target:addBoxZone({
    coords = vector3(Config.cheapMeth.targetCoords1),
    size = vector3(0.8, 0.8, 0.8),
    rotation = 20,
    debug = Config.Debug,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:cheapCook', 'meth') end,
            icon = 'fa-solid fa-vial',
            label = localSet.TargetCook,
            canInteract = function(entity, distance, coords, name, bone)
                return not isBusy
            end
        }
    }
})

ox_target:addBoxZone({
    coords = vector3(Config.cheapMeth.targetCoords2),
    size = vector3(1, 1.5, 0.5),
    rotation = 20,
    debug = Config.Debug,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:cheapCook', 'sudo') end,
            icon = 'fa-solid fa-flask-vial',
            label = localSet.TargetSudo,
            canInteract = function(entity, distance, coords, name, bone)
                return not isBusy
            end
        }
    }
})

-- Gather Acid  --
ox_target:addSphereZone({
    coords = vector3(2662.9579, 1623.7253, 24.7603),
    radius = 0.3,
    debug = Config.Debug,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:stealSulph')end,
            icon = 'fa-solid fa-faucet-drip',
            label = localSet.TargetSulph,
            canInteract = function(entity, distance, coords, name, bone)
                return not isBusy
            end
        }
    }
})

------------------------------------------------------------
-- Debug --
------------------------------------------------------------
if Config.Debug then
    RegisterCommand('preptest', function() 
        TriggerEvent('sharkmeth:prepAnim', 1)
    end, false)

    RegisterCommand('breaktest', function() 
        TriggerEvent('sharkmeth:smashAnim', 1)
    end, false)

    RegisterCommand('busytest', function()
        if isBusy then
            isBusy = false
            return print('busy no more')
        else
            isBusy = true
            return print('busy now')
        end
    end, false)
end
------------------------------------------------------------
-- Prep Main --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:prepAnim")
AddEventHandler("sharkmeth:prepAnim", function(value)
    isBusy = true
    local animDict = 'anim@heists@humane_labs@emp@hack_door'
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped, animDict, 'hack_intro', 8.0, 8.0, -1, 0, 0)
    Wait(2000)
    ClearPedTasks(ped)
    TaskPlayAnim(ped, animDict, 'hack_loop', 8.0, 8.0, -1, 1, 0)
    TriggerEvent('ultra-voltlab', 45, function(result)
        Wait(2000)
        if result == 1 then
            lib.notify({title = localSet.NotifPrepSuc[1], description = localSet.NotifPrepSuc[2], type = localSet.NotifPrepSuc[3]})
            TriggerServerEvent('sharkmeth:labSet', 1, value)
        else
            lib.notify({title = localSet.NotifPrepFai[1], description = localSet.NotifPrepFai[2], type = localSet.NotifPrepFai[3]})
        end
        ClearPedTasks(ped)
        TaskPlayAnim(ped, animDict, 'hack_outro', 8.0, 8.0, -1, 0, 0)
        RemoveAnimDict(animDict)
        FreezeEntityPosition(ped, false)
        isBusy = false
    end)
end)
------------------------------------------------------------
-- Cooking Main --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:cookAnim")
AddEventHandler("sharkmeth:cookAnim", function(value)
    isBusy = true
    local animDict, animName = "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_long_cooker"
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(Config.labs[value].cookAnim))
    SetEntityHeading(ped, Config.labs[value].cookH)
    Citizen.Wait(1)

    local targetPosition = GetEntityCoords(ped)
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3((Config.labs[value].cookAnim[1] +4.883), (Config.labs[value].cookAnim[2]+1.957), (Config.labs[value].cookAnim[3]-0.401)), GetEntityRotation(ped) -- 353200l 
    local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)

    local sacid = CreateObjectNoOffset("bkr_prop_meth_sacid", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(sacid, netScene, animDict, "chemical_pour_long_sacid", 4.0, -8.0, 1)
    local ammonia = CreateObjectNoOffset("bkr_prop_meth_ammonia", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(ammonia, netScene, animDict, "chemical_pour_long_ammonia", 4.0, -8.0, 1)
    local clipboard = CreateObjectNoOffset("bkr_prop_fakeid_clipboard_01a", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(clipboard, netScene, animDict, "chemical_pour_long_clipboard", 4.0, -8.0, 1)
    local pencil = CreateObjectNoOffset("prop_pencil_01", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(pencil, netScene, animDict, "chemical_pour_long_pencil", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(netScene)
    lib.progressBar({duration = Config.CookTime, label = localSet.ProgCook, disable = {combat = true, move =  true}})
    NetworkStopSynchronisedScene(netScene)
    DeleteObject(sacid)
    DeleteObject(ammonia)
    DeleteObject(clipboard)
    DeleteObject(pencil)
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
    isBusy = false
end)
------------------------------------------------------------
-- Smashing Lab --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:smashAnim")
AddEventHandler("sharkmeth:smashAnim", function(value)
    isBusy = true
    local animDict, animName = 'anim@amb@business@meth@meth_smash_weight_check@', 'break_weigh_char02'
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(Config.labs[value].hammerAnim))
    SetEntityHeading(ped, Config.labs[value].hammerH)
    Citizen.Wait(1)
    local targetPosition = GetEntityCoords(ped)
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3((Config.labs[value].hammerAnim[1]-3.074814), (Config.labs[value].hammerAnim[2]-1.76955), (Config.labs[value].hammerAnim[3])-0.9934), vector3(GetEntityRotation(ped)) -- 353200l 
    local netScene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animName, 1.5, -4.0, 1, 16, 1148846080, 0)

    local hammer = CreateObjectNoOffset("w_me_hammer", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(hammer, netScene, animDict, "break_weigh_hammer", 4.0, -8.0, 1)
    local methtray1 = CreateObjectNoOffset("bkr_prop_meth_tray_01a", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(methtray1, netScene, animDict, "break_weigh_tray01", 4.0, -8.0, 1)
    local methtray2 = CreateObjectNoOffset("bkr_prop_meth_smashedtray_01_frag_", targetPosition, 1, 1, 0)
    NetworkAddEntityToSynchronisedScene(methtray2, netScene, animDict, "break_weigh_tray01", 4.0, -8.0, 1)
    SetEntityVisible(methtray2, false)

    NetworkStartSynchronisedScene(netScene)
    Citizen.CreateThread(function() lib.progressBar({duration = 14200, label = localSet.ProgSmash, disable = {combat = true, move =  true}}) end)

    Wait(4200)
    SetEntityVisible(methtray1, false)
    SetEntityVisible(methtray2, true)
    Wait(10000)

    NetworkStopSynchronisedScene(netScene)
    DeleteObject(hammer)
    DeleteObject(methtray1)
    DeleteObject(methtray2)
    FreezeEntityPosition(ped, false)
    RemoveAnimDict(animDict)
    isBusy = false
end)
------------------------------------------------------------
-- Cooking Cheap --
------------------------------------------------------------
RegisterNetEvent('sharkmeth:cheapAnim')
AddEventHandler("sharkmeth:cheapAnim", function(type)
    isBusy = true
    local ped = PlayerPedId()

    if type == 'meth' then
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, vector3(Config.cheapMeth.animCoords1))
        SetEntityHeading(ped, Config.cheapMeth.animHeading1)
        lib.progressBar({
            duration = Config.CheapCookTime,
            label = localSet.ProgCook,
            disable = {
                move = true,
                combat = true,
            },
            anim = {
                dict = 'mp_car_bomb',
                clip = 'car_bomb_mechanic'
            },
        })
        FreezeEntityPosition(ped, false)
        isBusy = false
    elseif type =='sudo' then
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, vector3(Config.cheapMeth.animCoords2))
        SetEntityHeading(ped, Config.cheapMeth.animHeading2)
        lib.progressBar({
            duration = Config.CheapCookTime,
            label = localSet.ProgExt,
            disable = {
                move = true,
                combat = true,
                mouse = false
            },
            anim = {
                dict = 'mp_car_bomb',
                clip = 'car_bomb_mechanic'
            },
        })
        FreezeEntityPosition(ped, false)
        isBusy = false
    end
end)
------------------------------------------------------------
-- Stealing --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:stealAcid")
AddEventHandler("sharkmeth:stealAcid", function()
    isBusy = true
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, vector3(2663.6753, 1623.3765, 23.6703))
    SetEntityHeading(ped, 90)
    lib.progressCircle({
        duration = 10000,
        label = localSet.ProgSteal,
        anim = {
            dict = 'timetable@gardener@filling_can',
            clip = 'gar_ig_5_filling_can'
        },
        prop = {
            model = 'bkr_prop_meth_sacid',
            pos = vector3(0, 0, 0.45),
            rot = vector3(0, -180, -90),
        },
    })
    FreezeEntityPosition(ped, false)
    isBusy = false
    local BurnChance = math.random(100)
    if BurnChance <= Config.StealChance then
        lib.notify({title = localSet.NotifStealBurn[1], description = localSet.NotifStealBurn[2], type = localSet.NotifStealBurn[3]})
        TriggerServerEvent('sharkmeth:stealAlert')
    end
end)
------------------------------------------------------------
-- Grab Street --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:getStreet")
AddEventHandler("sharkmeth:getStreet", function(x, y, z, item)
    local  street = GetStreetNameAtCoord(x,y,z)
    local  streetname = GetStreetNameFromHashKey(street)
    local postal = exports.postal:getPostal()
    TriggerServerEvent('sharkmeth:buyAlert', streetname, postal, item)
end)