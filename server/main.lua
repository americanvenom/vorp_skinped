local VORPCore = {}
VORP = exports.vorp_core:vorpAPI()


RegisterServerEvent('vorp_skinPed:saveSkinPed')
AddEventHandler('vorp_skinPed:saveSkinPed', function(clientId,args)
    local _source = source
    local user = VORP.getCharacter(_source)
    local group = user.group
    local ident = user.identifier
    local model = args[1]

    if group == 'admin' or group == 'mod' then
        exports.ghmattimysql:execute('UPDATE characters SET skinPed = @model WHERE identifier = @identifier',{['@identifier'] = ident, ['@model'] = model},
        function(result)
            TriggerClientEvent("chat:addMessage", _source, {
                color = {255,0,0},
                multiline = true,
                args = {"System", "Modelo ped "..model.." guardado"}
            })
        end)
        TriggerClientEvent('vorp_skinPed:setSkinPed',_source, clientId, model)
    else
        TriggerClientEvent("vorp:TipBottom", _source,  "~COLOR_RED~ERROR~q~: No tienes suficiente persmisos para hacer esto", 5000)
    end

end)


RegisterServerEvent('vorp_skinPed:loadSkinPed')
AddEventHandler('vorp_skinPed:loadSkinPed', function(clientId)
    local _source = source
    local user = VORP.getCharacter(_source)
    local ident = user.identifier
    exports.ghmattimysql:execute('SELECT skinPed FROM characters WHERE identifier = @identifier',{['@identifier'] = ident},
    function(result)
         local skinPed = result[1].skinPed
        TriggerClientEvent('vorp_skinPed:setSkinPed',_source, clientId, skinPed)
    end)
end)