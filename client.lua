--setup
local ox_inventory = exports.ox_inventory
local interiorHash4 = GetInteriorAtCoordsWithType(963.7479,3632.5056,25.761,"int_stock")

-- Citizen.CreateThread(function()
--     BikerMethLab = exports['bob74_ipl']:GetBikerMethLabObject()
--         BikerCounterfeit.Ipl.Interior.Load()
--         BikerMethLab.Style.Set(BikerMethLab.Style.basic)
--         BikerMethLab.Security.Set(BikerMethLab.Security.none)
--         BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)

--         RefreshInterior(BikerCounterfeit.interiorId)
-- end)
  --target zones
exports.ox_target:addBoxZone({
    coords = vec3(442.5363, -1017.666, 28.85637),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'prepcook',
            onSelect = function() TriggerServerEvent('sharkmeth:prepcook') end,
            icon = 'fa-solid fa-clipboard',
            label = 'Prep Lab Equipment',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(442.5363, -1017.666, 28.85637),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:startcook')end,
            icon = 'fa-solid fa-kitchen-set',
            label = 'Start Cooking',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(442.5363, -1017.666, 28.85637),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            onSelect = function() TriggerServerEvent('sharkmeth:smash')end,
            icon = 'fa-solid fa-hammer',
            label = 'Break Meth',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(442.5363, -1017.666, 28.85637),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'ox:option1',
            icon = 'fa-solid fa-tablet-screen-button',
            label = 'Collect Pure Meth',
            onSelect = function() TriggerServerEvent('sharkmeth:collect') end
        } 
    }
})

 -- notifications
RegisterNetEvent("sharkmeth:notify", function(type)
    local notification = {
        ['prepfail'] = lib.notify({title = 'Equipment Prepped', description = 'The equipment is already prepared.', type = 'error'}),
        ['prepfail2'] = lib.notify({title = 'Equipment Prepped', description = 'Prep failed.', type = 'error'}),
        ['prepsuccess'] = lib.notify({title = 'Equipment Ready', description = 'Ready to cook.', type = 'success'}),
        ['cookfail'] = lib.notify({title = 'Missing Ingrediants', description = 'Your missing something.', type = 'error'}),
        ['cooksuccess'] = lib.notify({title = 'Cook Complete', description = 'Meth is ready to collect.', type = 'success'}),
        ['smashfail1'] = lib.notify({title = 'Can\t break', description = 'You need something to smash.', type = 'error'}),
        ['smashfail2'] = lib.notify({title = 'Can\'t break', description = 'You need something to smash with.', type = 'error'}),
    }
    return notification[type]
end
)
 --Cooking meth
RegisterNetEvent("sharkmeth:cook")
AddEventHandler("sharkmeth:cook", function()
    local animDict, animName = "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_long_cooker"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(1005.773, -3200.402, -38.524))
    Citizen.Wait(1)
    local targetPosition = GetEntityCoords(ped)
    local animDuration = GetAnimDuration(animDict, animName) * 1000
    FreezeEntityPosition(ped, true)
    local scenePos, sceneRot = vector3(1010.656, -3198.445, -38.925), vector3(0.0, 0.0, 0.0) -- 353200l
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
    Citizen.Wait(animDuration)
    lib.progressBar({duration = animDuration, label = "Cooking Methamphetamine"})
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
AddEventHandler("sharkmeth:smashy", function()
    lib.progressBar({duration = 10000, label = "Breaking up Methamphetamine"})
end)