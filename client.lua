--setup
local ox_inventory = exports.ox_inventory

local labs = {
    [1] = {
        CookX = 593.4044, CookY = -426.5631, CookZ = 18.1196, CookH = 0.00, 
        HammerX = 596.6482, HammerY = -416.2458, HammerZ = 16.6237, HammerH = 360.0000, 
        PrepX = 595.1400, PrepY = -420.8869, PrepZ = 18.1
    }
    -- [2] = {
    --       CookX = 593.4044, CookY = -426.5631, CookZ = 18.1196, CookH = {0.00, 0.00, 0.00},
    --       HammerX = 596.6482, HammerY = -416.2458, HammerZ = 16.6237, HammerH = 546,
    --        PrepX = 595.1400, PrepY = -420.8869, PrepZ = 18.1,
    --       },
    -- [3] = {
    --     CookX = 593.4044, CookY = -426.5631, CookZ = 18.1196, CookH = {0.00, 0.00, 0.00},
    --     HammerX = 596.6482, HammerY = -416.2458, HammerZ = 16.6237, HammerH = 546,
    --        PrepX = 595.1400, PrepY = -420.8869, PrepZ = 18.1,
    --     },
}  --+4.883, -1.957, 0.401
-- ox target

-- INSIDE LAB INSIDE LAB \/\/
exports.ox_target:addBoxZone({
    coords = vec3(595.1400, -420.8869, 18.1),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'prepcook',
            onSelect = function()
                TriggerEvent('ultra-voltlab', 45, function(result)
                    if result == 1 then
                        Citizen.Wait(2000)
                        TriggerEvent('sharkmeth:notify', 'prepsuccess')
                        TriggerServerEvent('sharkmeth:localset', 1, 1)
                    else
                        Citizen.Wait(2000)
                        TriggerEvent('sharkmeth:notify', 'prepfail')
                    end
            end) end,
            icon = 'fa-solid fa-clipboard',
            label = 'Prep Lab Equipment',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(593.2789, -427.2405, 18.1199),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
         name = 'ox:option1',
         onSelect = function() TriggerServerEvent('sharkmeth:extractsudo', 1) end,
         icon = 'fa-solid fa-vial',
         label = 'Extract Sudoepherine',
        },
        {
            name = 'ox:option2',
            onSelect = function() TriggerServerEvent('sharkmeth:extractphos', 1) end,
            icon = 'fa-solid fa-flask',
            label = 'Extract Phosphorus',
           },
        {
            name = 'ox:option3',
            onSelect = function() TriggerServerEvent('sharkmeth:cookmeth', 1)end,
            icon = 'fa-solid fa-flask-vial',
            label = 'Cook Crystal Meth',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(596.2152, -415.6101, 17.6237),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:smash', 1)end,
            icon = 'fa-solid fa-hammer',
            label = 'Break Meth',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(595.2357, -428.0095, 17.8757),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:collect', 1) end,
            icon = 'fa-solid fa-hard-drive',
            label = 'Collect Product',
        } 
    }
})
  -- INSIDE LAB INSIDE LAB ^^^^
exports.ox_target:addBoxZone({
    coords = vec3(2662.9579, 1623.7253, 24.7603),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:stealsulph')end,
            icon = 'fa-solid fa-faucet-drip',
            label = 'Steal Sulphuric Acid',
        }
    }
})

 -- notifications
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

 --Cooking meth
RegisterNetEvent("sharkmeth:cook")
AddEventHandler("sharkmeth:cook", function(value)
    local animDict, animName = "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_long_cooker"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    -- SetEntityCoords(ped, vector3(labs[value].CookX, labs[value].CookY, labs[value].CookZ))
    SetEntityCoords(ped, vector3(593.4044, -426.5631, 18.1196))
    Citizen.Wait(1)
    local targetPosition = GetEntityCoords(ped)
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3(598.2874, -424.6061, 17.7186), vector3(0.0, 0.0, 0.0) -- 353200l
    --local scenePos, sceneRot = vector3(labs[value].CookX, (labs[value].CookY), (labs[value].CookZ)), vector3(0.0, 0.0, 0.0) -- 353200l
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

    local time = animDuration - 30000
    NetworkStartSynchronisedScene(netScene)
    lib.progressBar({duration = (time), label = "Cooking..."})
    NetworkStopSynchronisedScene(netScene)
    DeleteObject(sacid)
    DeleteObject(ammonia)
    DeleteObject(clipboard)
    DeleteObject(pencil)
    RemoveAnimDict(animDict)
    FreezeEntityPosition(ped, false)
end)

--Smashing meth
RegisterNetEvent("sharkmeth:smashy")
AddEventHandler("sharkmeth:smashy", function(value)
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(labs[value].HammerX, labs[value].HammerY, labs[value].HammerZ))
    SetEntityHeading(ped, labs[value].HammerH)
    FreezeEntityPosition(ped, true)
    lib.progressBar({
        duration = 10000,
        label = 'Breaking up Methamphetamine',
        anim = {
            dict = 'anim@amb@business@meth@meth_smash_weight_check@',
            clip = 'break_weigh_char02'
        },
        prop = {
            model = 'prop_tool_hammer',
            pos = vec3(0.07, 0.05, 0.01),
            rot = vec3(60.0, 0.0, 165.00),
            bone = 6286,
        },
    })
    FreezeEntityPosition(ped, false)
end)

--Smashing meth
RegisterNetEvent("sharkmeth:stealy")
AddEventHandler("sharkmeth:stealy", function()
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
            pos = vec3(0, 0, 0.45),
            rot = vec3(0, -180, -90),
        },
    })
    FreezeEntityPosition(ped, false)
end)