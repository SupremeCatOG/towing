local whitelist = {
    'FLATBED',
    'BENSON',
    'WASTLNDR',
    'MULE',
    'MULE2',
    'MULE3',
    'MULE4',
    'TRAILER',
    'ARMYTRAILER',
    'BOATTRAILER'
}

local offsets = {
    {model = 'FLATBED', offset = {x = 0.0, y = -9.0, z = -1.25}},
    {model = 'BENSON', offset = {x = 0.0, y = 0.0, z = -1.25}},
    {model = 'WASTLNDR', offset = {x = 0.0, y = -7.2, z = -0.9}},
    {model = 'MULE', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE2', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE3', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'MULE4', offset = {x = 0.0, y = -7.0, z = -1.75}},
    {model = 'TRAILER', offset = {x = 0.0, y = -9.0, z = -1.25}},
    {model = 'ARMYTRAILER', offset = {x = 0.0, y = -9.5, z = -3.0}},
}

local rampHash = 'imp_prop_flatbed_ramp'

RegisterCommand('deployramp', function ()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local radius = 5.0

    local vehicle = nil

    if IsAnyVehicleNearPoint(playerCoords, radius) then
        vehicle = GetClosestVehicle(playerCoords, radius, 0, 70)
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

        drawNotification("Trying to deploy a ramp for: " .. vehicleName)

        if contains(vehicleName, whitelist) then
            local vehicleCoords = GetEntityCoords(vehicle)

            local ramp = CreateObject(rampHash, vector3(vehicleCoords), true, false, false)
            for _, value in pairs(offsets) do
                if vehicleName == value.model then
                    AttachEntityToEntity(ramp, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), value.offset.x, value.offset.y, value.offset.z , 180.0, 180.0, 0.0, 0, 0, 1, 0, 0, 1)
                end
            end

            drawNotification("Ramp has been deployed.")
            return
        end
        drawNotification("You can't deploy a ramp for this vehicle.")
        return
    end
end)

RegisterCommand('ramprm', function()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)

    local object = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, rampHash, false, 0, 0)

    if not IsPedInAnyVehicle(player, false) then
        if GetHashKey(rampHash) == GetEntityModel(object) then
            DeleteObject(object)
            drawNotification("Ramp removed successfully.")
            return
        end
    end

    drawNotification("Get out of your vehicle or get closer to the ramp.")
end)

RegisterCommand('attach', function()
    local player = PlayerPedId()
    local vehicle = nil

    if IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
        if GetPedInVehicleSeat(vehicle, -1) == player then
            local vehicleCoords = GetEntityCoords(vehicle)
            local vehicleOffset = GetOffsetFromEntityInWorldCoords(vehicle, 1.0, 0.0, -1.5)
            local belowEntity = GetVehicleBelowMe(vehicleCoords, vehicleOffset)
            local vehicleBelowName = GetDisplayNameFromVehicleModel(GetEntityModel(belowEntity))

            local vehiclesOffset = GetOffsetFromEntityGivenWorldCoords(belowEntity, vehicleCoords)

            if contains(vehicleBelowName, whitelist) then
                if not IsEntityAttached(vehicle) then
                    AttachEntityToEntity(vehicle, belowEntity, GetEntityBoneIndexByName(belowEntity, 'chassis'), vehiclesOffset, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
                    return drawNotification('Vehicle attached properly.')
                end
                return drawNotification('Vehicle already attached.')
            end
            return drawNotification('Can\'t attach to this entity: ' .. vehicleBelowName)
        end
        return drawNotification('Not in driver seat.')
    end
    drawNotification('You\'re not in a vehicle.')
end)

RegisterCommand('detach', function()
    local player = PlayerPedId()
    local vehicle = nil

    if IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
        if GetPedInVehicleSeat(vehicle, -1) == player then
            if IsEntityAttached(vehicle) then
                DetachEntity(vehicle, false, true)
                return drawNotification('The vehicle has been successfully detached.')
            else
                return drawNotification('The vehicle isn\'t attached to anything.')
            end
        else
            return drawNotification('You are not in the driver seat.')
        end
    else
        return drawNotification('You are not in a vehicle.')
    end
end)

function GetVehicleBelowMe(cFrom, cTo) -- Function to get the vehicle under me
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, PlayerPedId(), 0) -- Sends raycast under me
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle) -- Stores the vehicle under me
    return vehicle -- Returns the vehicle under me
end

function contains(item, list)
    for _, value in ipairs(list) do
        if value == item then return true end
    end
    return false
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, false)
end
