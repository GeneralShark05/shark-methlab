---@diagnostic disable: undefined-global
local ox_inventory = exports.ox_inventory
    ------------------------------------------------------------
    -- Lab  Startup --
    -----------------------------------------------------------

Citizen.CreateThread(function()
    local interiorHash = GetInteriorAtCoordsWithType(-1262.992,-1123.942,7.6170,"int_stock")
    RefreshInterior(interiorHash)
    DisableInteriorProp(interiorHash, "light_stock")
    DisableInteriorProp(interiorHash, "meth_app")
    DisableInteriorProp(interiorHash, "meth_staff_01")
    DisableInteriorProp(interiorHash, "meth_staff_02")
    DisableInteriorProp(interiorHash, "meth_update_lab_01")
    DisableInteriorProp(interiorHash, "meth_update_lab_02")
    DisableInteriorProp(interiorHash, "meth_update_lab_01_2")
    DisableInteriorProp(interiorHash, "meth_update_lab_02_2")

    DisableInteriorProp(interiorHash, "meth_stock")

    RefreshInterior(interiorHash)
    EnableInteriorProp(interiorHash, "light_stock")
    EnableInteriorProp(interiorHash, "meth_app")
    EnableInteriorProp(interiorHash, "meth_staff_01")
    EnableInteriorProp(interiorHash, "meth_staff_02")
    EnableInteriorProp(interiorHash, "meth_update_lab_01")
    EnableInteriorProp(interiorHash, "meth_update_lab_02")
    EnableInteriorProp(interiorHash, "meth_update_lab_01_2")
    EnableInteriorProp(interiorHash, "meth_update_lab_02_2")

    EnableInteriorProp(interiorHash, "meth_stock")

end)

    ------------------------------------------------------------
    -- Real Lab --
    ------------------------------------------------------------
for k,v in ipairs(Config.labs.meth) do
    exports.ox_target:addBoxZone({
        coords = vector3(Config.labs.meth[k].PrepTarget),
        size = vector3(0.5, 0.5, 0.7),
        rotation = Config.labs.meth[k].PrepRotate,
        debug = Config.Debug,
        options = {
            {
                name = 'prepcook',
                onSelect = function()
                    TriggerEvent('ultra-voltlab', 45, function(result)
                        if result == 1 then
                            Citizen.Wait(2000)
                            TriggerEvent('sharkmeth:notify', 'prepsuccess')
                            TriggerServerEvent('sharkmeth:localset', 1, k)
                        else
                            Citizen.Wait(2000)
                            TriggerEvent('sharkmeth:notify', 'prepfail')
                        end
                end) end,
                icon = 'fa-solid fa-clipboard',
                label = 'Prep Lab Equipment',
            },
            {
                name = 'ox:option1',
                onSelect = function() TriggerServerEvent('sharkmeth:collect', k) end,
                icon = 'fa-solid fa-hard-drive',
                label = 'Collect Product',
            } 
        }
    })

    exports.ox_target:addBoxZone({
        coords = vector3(Config.labs.meth[k].CookTarget),
        size = vector3(0.5, 0.5, 0.5),
        rotation = Config.labs.meth[k].CookRotate,
        debug = Config.Debug,
        options = {
            {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:extractsudo', k) end,
            icon = 'fa-solid fa-vial',
            label = 'Extract Sudoepherine',
            },
            {
                name = 'ox:option2',
                onSelect = function() TriggerServerEvent('sharkmeth:extractphos', k) end,
                icon = 'fa-solid fa-flask',
                label = 'Extract Phosphorus',
            },
            {
                name = 'ox:option3',
                onSelect = function() TriggerServerEvent('sharkmeth:cookmeth', k)end,
                icon = 'fa-solid fa-flask-vial',
                label = 'Cook Crystal Meth',
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = vector3(Config.labs.meth[k].HammerTarget),
        size = vector3(2, 1, 0.5),
        rotation = Config.labs.meth[k].HammerRotate,
        debug = Config.Debug,
        options = {
            {
                name = 'ox:option1',
                onSelect = function() TriggerServerEvent('sharkmeth:smash', k)end,
                icon = 'fa-solid fa-hammer',
                label = 'Break Meth',
            }
        }
    })
end
------------------------------------------------------------
-- Cheap Lab --
------------------------------------------------------------
exports.ox_target:addBoxZone({
    coords = vector3(1391, 3605.5710, 38.9),
    size = vector3(0.8, 0.8, 0.8),
    rotation = 20,
    debug = Config.Debug,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:cheapcook') end,
            icon = 'fa-solid fa-vial',
            label = 'Cook Crystal Meth',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vector3(1390.50, 3603.8, 38.9418),
    size = vector3(1, 1.5, 0.5),
    rotation = 20,
    debug = Config.Debug,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:cheapsudo') end,
            icon = 'fa-solid fa-flask-vial',
            label = 'Extract Sudo',
        }
    }
})

------------------------------------------------------------
-- Gathering  --
------------------------------------------------------------
exports.ox_target:addSphereZone({
coords = vector3(2662.9579, 1623.7253, 24.7603),
radius = 0.3,
debug = Config.Debug,
options = {
    {
        name = 'ox:option1',
        onSelect = function() TriggerServerEvent('sharkmeth:stealSulph')end,
        icon = 'fa-solid fa-faucet-drip',
        label = 'Steal Sulphuric Acid',
    }
}
})
------------------------------------------------------------
-- Notifs --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:notify", function(type)
    local notification = {
        ['prepfail'] = {title = 'Equipment Not Prepped', description = 'Prep failed, try again? Has the equipment already bene prepped?', type = 'error'},
        ['prepsuccess'] = {title = 'Equipment Ready', description = 'Ready to cook.', type = 'success'},
        ['cookfail'] = {title = 'Can\'t Cook', description = 'You\'re missing something, an ingredient? Is the equipment ready?', type = 'error'},
        ['cooksuccess'] = {title = 'Cook Complete', description = 'Your product is ready to collect.', type = 'success'},
        ['smashfail'] = {title = 'Can\'t Break', description = 'You\'re missing something...', type = 'error'},
        ['collecterror'] = {title = 'Can\'t Collect', description = 'Nothing to collect', type = 'error'},
        ['stealfail'] = {title = 'Can\t Steal', description = '...You can\'t just pour sulphuric acid in your pocket', type = 'error'}
    } 
    return lib.notify({title = notification[type].title, description = notification[type].description, type = notification[type].type})
end
)

------------------------------------------------------------
-- Cooking Main --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:cook")
AddEventHandler("sharkmeth:cook", function(value)
    local animDict, animName = "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_long_cooker"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(Config.labs.meth[value].CookAnim))
    Citizen.Wait(1)
    local targetPosition = GetEntityCoords(ped)
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3((Config.labs.meth[value].CookAnim[1] +4.883), (Config.labs.meth[value].CookAnim[2]+1.957), (Config.labs.meth[value].CookAnim[3]-0.401)), vector3(0.0, 0.0, 0.0) -- 353200l 
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
    lib.progressBar({duration = 80000, label = "Cooking..."})
    NetworkStopSynchronisedScene(netScene)
    DeleteObject(sacid)
    DeleteObject(ammonia)
    DeleteObject(clipboard)
    DeleteObject(pencil)
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end)


------------------------------------------------------------
-- Smashing Lab --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:smashy")
AddEventHandler("sharkmeth:smashy", function(value)
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(Config.labs.meth[value].HammerAnim))
    SetEntityHeading(ped, Config.labs.meth[value].HammerH)
    FreezeEntityPosition(ped, true)
    lib.progressBar({
        duration = 5000,
        label = 'Breaking up Meth',
        anim = {
            dict = 'anim@amb@business@meth@meth_smash_weight_check@',
            clip = 'break_weigh_char02'
        },
        prop = {
            model = 'prop_tool_hammer',
            pos = vector3(0.07, 0.05, 0.01),
            rot = vector3(60.0, 0.0, 165.00),
            bone = 6286,
        },
    })
    FreezeEntityPosition(ped, false)
end)

------------------------------------------------------------
-- Cooking Cheap --
------------------------------------------------------------
RegisterNetEvent('sharkmeth:cookcheap')
AddEventHandler("sharkmeth:cookcheap", function(type)
    local ped = PlayerPedId()

    if type == 'meth' then
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, vector3(1391.8817, 3605.8767, 38))
        SetEntityHeading(ped, 103.0970)
        lib.progressBar({
            duration = 20000,
            label = 'Cooking Meth',
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

    elseif type =='sudo' then
        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, vector3(1389.7385, 3603.3762, 38))
        SetEntityHeading(ped, 292.2780)
        lib.progressBar({
            duration = 20000,
            label = 'Extracting Sudo',
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
    end
end)


------------------------------------------------------------
-- Stealing --
------------------------------------------------------------
RegisterNetEvent("sharkmeth:stealAcid")
AddEventHandler("sharkmeth:stealAcid", function()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, vector3(2663.6753, 1623.3765, 23.6703))
    SetEntityHeading(ped, 90)
    lib.progressBar({
        duration = 10000,
        label = 'Stealing Sulphuric Acid',
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
    if math.random(5) == 5 then
        lib.notify({title = 'Ouch!', description = 'You burned your hand and yelled in pain!', type = 'error'})
        TriggerServerEvent('sharkmeth:powerplant')
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
    TriggerServerEvent('sharkmeth:buyalert', streetname, postal, item)
end)