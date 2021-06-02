ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(500)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('playerSpawned', function()
TriggerEvent("kaves_gangs:SpawnGangMembers")
end)

RegisterCommand("kaves", function()
TriggerEvent("kaves_gangs:SpawnGangMembers")
end)

RegisterNetEvent("kaves_gangs:SpawnGangMembers")
AddEventHandler("kaves_gangs:SpawnGangMembers", function()
    AddRelationshipGroup("ballas")
    AddRelationshipGroup("grove")
    AddRelationshipGroup("vagos")
    AddRelationshipGroup("others")
    SetRelationshipBetweenGroups(3, GetHashKey("ballas"), GetHashKey("others"))
    SetRelationshipBetweenGroups(3, GetHashKey("grove"), GetHashKey("others"))
    SetRelationshipBetweenGroups(3, GetHashKey("vagos"), GetHashKey("others"))
    if PlayerData.job.name == "ballas" then
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("ballas"))
    elseif PlayerData.job.name == "grove" then
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("grove"))
    elseif PlayerData.job.name == "vagos" then
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("vagos"))
    else
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("others"))
    end
    for k,v in pairs(Config) do
        for a = 1, #v.Vehicles, 1 do
            if v.Vehicles[a].created == false then
                RequestModel(v.Vehicles[a].model)
                while not HasModelLoaded(v.Vehicles[a].model) do Citizen.Wait(10) end
                v.Vehicles[a].handle = CreateVehicle(v.Vehicles[a].model, v.Vehicles[a].coords.x, v.Vehicles[a].coords.y, v.Vehicles[a].coords.z-1.0, v.Vehicles[a].heading, true, false) -- elleme
                v.Vehicles[a].created = true 
                SetVehicleModColor_1(v.Vehicles[a].handle, 1, v.Vehicles[a].color)
                SetVehicleModColor_2(v.Vehicles[a].handle, 1, v.Vehicles[a].color)
                SetVehicleColours(v.Vehicles[a].handle, v.Vehicles[a].color, v.Vehicles[a].color) 
                SetModelAsNoLongerNeeded(v.Vehicles[a].model) 
                SetVehicleDoorsLocked(v.Vehicles[a].handle, 2) 
                SetVehicleDirtLevel(v.Vehicles[a].handle, 0.0)
                SetVehicleDoorOpen(Config.Ballas.Vehicles[1].handle, 4, false, false) 
                FreezeEntityPosition(v.Vehicles[a].handle, true) 
            end
        end
        for i = 1, #v.Peds, 1 do
            if v.Peds[i].created == false then
                local model = v.PedModels[math.random(1, #v.PedModels)]
                RequestModel(model)
                while not HasModelLoaded(model) do Citizen.Wait(10) end
                v.Peds[i].handle = CreatePed(26, model, v.Peds[i].coords.x, v.Peds[i].coords.y, v.Peds[i].coords.z-1.0, v.Peds[i].heading, false, false)  
                v.Peds[i].created = true 
                SetPedRelationshipGroupHash(v.Peds[i].handle, v.GroupHash) 
                GiveWeaponToPed(v.Peds[i].handle, v.Peds[i].weapon, 9999, false, true) 
                SetPedArmour(v.Peds[i].handle, 3000) 
                SetPedCombatAttributes(v.Peds[i].handle, 1, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 2, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 5, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 16, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 26, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 46, true) 
                SetPedCombatAttributes(v.Peds[i].handle, 52, true) 
                SetPedCombatRange(v.Peds[i].handle, 2)
                SetPedCombatAbility(v.Peds[i].handle, 2)
                SetPedFleeAttributes(v.Peds[i].handle, 0, 0) 
                SetPedDiesWhenInjured(v.Peds[i].handle, false) 
                SetPedAccuracy(v.Peds[i].handle, 100) 
                SetPedToInformRespectedFriends(v.Peds[i].handle, 200, 100) 
                SetPedSeeingRange(v.Peds[i].handle, 200)
                Citizen.CreateThreadNow(function()
                    Citizen.Wait(500)
                    if v.Peds[i].anim ~= nil then
                        if v.Peds[i].type == 1 then
                            RequestAnimDict(v.Peds[i].anim.dict)
                            while not HasAnimDictLoaded(v.Peds[i].anim.dict) do Citizen.Wait(10) end
                            TaskPlayAnim(v.Peds[i].handle, v.Peds[i].anim.dict, v.Peds[i].anim.name, 2.0, 2.0, -1, 1, 0, false)
                            if v.Peds[i].prop ~= nil then
                                RequestModel(v.Peds[i].prop.model)
                                while not HasModelLoaded(v.Peds[i].prop.model) do Citizen.Wait(10) end
                                local obje = CreateObject(GetHashKey(v.Peds[i].prop.model), v.Peds[i].coords, true, true, true)
                                AttachEntityToEntity(obje, v.Peds[i].handle, GetPedBoneIndex(v.Peds[i].handle, v.Peds[i].prop.bone), v.Peds[i].prop.placement[1], v.Peds[i].prop.placement[2], v.Peds[i].prop.placement[3], v.Peds[i].prop.placement[4], v.Peds[i].prop.placement[5], v.Peds[i].prop.placement[6], true, true, false, true, 1, true)
                            end
                        elseif v.Peds[i].type == 2 then
                            TaskStartScenarioInPlace(v.Peds[i].handle, v.Peds[i].anim.name, 0,  true)
                        end
                        RemoveAnimDict(v.Peds[i].anim.dict)
                    end
                    local combat = false
                    while true do
                        if not IsEntityDead(v.Peds[i].handle) then
                            if GetPedAlertness(v.Peds[i].handle) ~= 0 then
                                combat = true
                                while combat do
                                    Citizen.Wait(30000)
                                    combat = false
                                    SetPedAlertness(v.Peds[i].handle, 0)
                                end
                                if v.Peds[i].type == 1 then
                                    TaskGoStraightToCoord(v.Peds[i].handle, v.Peds[i].coords, 20.0, -1, v.Peds[i].heading, 0.0)
                                    while GetDistanceBetweenCoords(GetEntityCoords(v.Peds[i].handle), v.Peds[i].coords, true) > 1.5 do
                                        Citizen.Wait(1000)
                                        TaskGoStraightToCoord(v.Peds[i].handle, v.Peds[i].coords, 20.0, -1, v.Peds[i].heading, 0.0)
                                    end
                                    RequestAnimDict(v.Peds[i].anim.dict)
                                    while not HasAnimDictLoaded(v.Peds[i].anim.dict) do Citizen.Wait(10) end
                                    TaskPlayAnim(v.Peds[i].handle, v.Peds[i].anim.dict, v.Peds[i].anim.name, 2.0, 2.0, -1, 1, 0, false)
                                    if v.Peds[i].prop ~= nil then
                                        RequestModel(v.Peds[i].prop.model)
                                        while not HasModelLoaded(v.Peds[i].prop.model) do Citizen.Wait(10) end
                                        local obje = CreateObject(GetHashKey(v.Peds[i].prop.model), v.Peds[i].coords, true, true, true)
                                        AttachEntityToEntity(obje, v.Peds[i].handle, GetPedBoneIndex(v.Peds[i].handle, v.Peds[i].prop.bone), v.Peds[i].prop.placement[1], v.Peds[i].prop.placement[2], v.Peds[i].prop.placement[3], v.Peds[i].prop.placement[4], v.Peds[i].prop.placement[5], v.Peds[i].prop.placement[6], true, true, false, true, 1, true)
                                    end
                                    RemoveAnimDict(v.Peds[i].anim.dict)
                                elseif v.Peds[i].type == 2 then
                                    TaskGoStraightToCoord(v.Peds[i].handle, v.Peds[i].coords, 20.0, -1, v.Peds[i].heading, 0.0)
                                    while GetDistanceBetweenCoords(GetEntityCoords(v.Peds[i].handle), v.Peds[i].coords, true) > 1.5 do
                                        Citizen.Wait(1000)
                                        TaskGoStraightToCoord(v.Peds[i].handle, v.Peds[i].coords, 20.0, -1, v.Peds[i].heading, 0.0)
                                    end
                                    TaskStartScenarioInPlace(v.Peds[i].handle, v.Peds[i].anim.name, 0,  true)
                                end
                            else
                                Citizen.Wait(5000)
                            end
                        else
                            break
                        end
                        Citizen.Wait(0)
                    end
                end)
            end
        end
    end
end)
