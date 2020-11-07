
RegisterCommand('saveskinPed',function(source,args)
    local modelo = args[1]
    print(modelo)
    if modelo == nil then
        TriggerEvent("vorp:TipBottom", "~COLOR_RED~ERROR~q~: Usa /loadskinPed [skin/ped]", 5000)
    else
        TriggerServerEvent('vorp_skinPed:saveSkinPed', source,args)
    end
end,false)



RegisterCommand('loadskinPed',function(source)
    TriggerServerEvent('vorp_skinPed:loadSkinPed',source)
end,false)

RegisterNetEvent('vorp_skinPed:setSkinPed')
AddEventHandler('vorp_skinPed:setSkinPed', function(clientId,model)
    local hashModel = GetHashKey(model)

    if not IsModelValid(hashModel) then return end
	PerformRequest(hashModel)
	
	if HasModelLoaded(hashModel) then
		-- SetPlayerModel(player, model, false)
        Citizen.InvokeNative(0xED40380076A31506, PlayerId(), hashModel, true)
        SetModelAsNoLongerNeeded(hashModel)
    end

end)

function PerformRequest(hash)
    RequestModel(hash, 0) -- RequestModel
    local times = 1
    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do -- HasModelLoaded
        Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0) -- RequestModel
        times = times + 1
        Citizen.Wait(0)
        if times >= 100 then break end
    end
end

RegisterCommand('pedtest',function(source, args)
    local player = PlayerPedId()
    local variation = tonumber(args[1])
    print(player)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4,PlayerPedId(),variation,0)

    --Para cambiar el walking style hay que desactivar el walking anterior
    --De todas formas no arregla el bug de los skins npcs que no pueden recargar
    --Citizen.InvokeNative(0xCB9401F918CB0F75, PlayerPedId(), "default",0,-1)
    --Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), "john_marston")
end,false)