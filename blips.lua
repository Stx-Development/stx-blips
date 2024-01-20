local blips_enable = false
local Debug = true


local blips_generated = {}

-- Functions Do Not Edit Unless You Know What To Do :)
local function LoadBlips()
    for k , v in pairs(Config.BlipSettings) do
        local blip = AddBlipForCoord(v.blip_coordinates)
        blips_generated[#blips_generated + 1] = {
            enabled = true,
            name = v.blip_label,
            number = blip
        }
        SetBlipSprite(blip, v.blip_sprite)
        SetBlipScale(blip, v.blip_size)
        SetBlipColour(blip, v.blip_colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip_label)
        EndTextCommandSetBlipName(blip)
        print(' Blips Created ID : '..blip)
        blips_enable = true
    end
end

local function LoadAllBlips()
    for k , v in pairs(blips_generated) do
        SetBlipDisplay(v.number, 6)
        blips_generated[k] = {
            enabled = true,
            name = v.name,
            number = v.number
        }
    end
end

local function RemoveIndividualBlip(id, name, enable, k)
    SetBlipDisplay(id, 0)
    blips_generated[k] = {
        enabled = enable,
        name = name,
        number = id
    }
    print('Blips Removed ' ..id)
end

local function AddIndividualBlip(id, name, enable, k)
    SetBlipDisplay(id, 6)
    blips_generated[k] = {
        enabled = enable,
        name = name,
        number = id
    }
    print('Blips Added '..id)
end

local function RemoveBlips()
    for k , v in pairs(blips_generated) do
        SetBlipDisplay(v.number, 0)
        print(' Blips Deleted ')
        blips_generated[k] = {
            enabled = false,
            name = v.name,
            number = v.number
        }
    end
end

AddEventHandler('playerSpawned', function()
    LoadBlips()
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        LoadBlips()
    end
end)


RegisterCommand(Config.Command, function()
    TriggerEvent('stx-blips:client:open_blip_menu')
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/'..Config.Command, 'Use this command to enable/disable blips')
end)

-- Events

RegisterNetEvent('stx-blips:client:open_blip_menu', function()
    local menus = {}

    for _, v in pairs(blips_generated) do
        menus[#menus + 1] = {
            title = 'Blip Name : '..v.name.. ' | Enabled : '..tostring(v.enabled),
            onSelect = function()
                if v.enabled then
                    RemoveIndividualBlip(v.number, v.name, false, _)
                else
                    AddIndividualBlip(v.number, v.name, true, _)
                end
            end,
        }
    end
    menus[#menus + 1] = {
        title = 'Load All Blips',
        onSelect = function()
            blips_enable = true
            LoadAllBlips()
        end,
    }
    menus[#menus + 1] = {
        title = 'Remove All Blips',
        onSelect = function()
            RemoveBlips()
            blips_enable = false
        end,
    }
    lib.registerContext({
        id = 'stx_blips_menu',
        title = 'Blips Menu',
        menu = 'some_menu_blips',
        options = menus
    })
    lib.showContext('stx_blips_menu')
end)

