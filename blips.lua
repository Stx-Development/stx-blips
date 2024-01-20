local blips_enable = false
local Debug = true


local blips_generated = {}

-- Functions Do Not Edit Unless You Know What To Do :)
function LoadBlips()
    for k , v in pairs(Config.BlipSettings) do
        local blip = AddBlipForCoord(v.blip_coordinates)
        blips_generated[#blips_generated + 1] = {
            number = blip
        }
        SetBlipSprite(blip, v.blip_sprite)
        SetBlipScale(blip, v.blip_size)
        SetBlipColour(blip, v.blip_colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip_label)
        EndTextCommandSetBlipName(blip)
    end
end

function RemoveBlips()
    for k , v in pairs(blips_generated) do
        RemoveBlip(v.number)
    end
end

AddEventHandler('playerSpawned', function()
    blips_enable = true
    LoadBlips()
end)


RegisterCommand(Config.Command, function()
    if blips_enable then
        RemoveBlips()
        blips_enable = false
    else
        blips_enable = true
        LoadBlips()
    end
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/'..Config.Command, 'Use this command to enable/disable blips')
end)