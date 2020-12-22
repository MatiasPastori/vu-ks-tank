NetEvents:Subscribe('vu-ks-tank:Launch', function(player, position)
 -- Vehicles/T90/T90
 -- Vehicles/M1A2/M1Abrams
	position.y = position.y
	local yaw = player.input.authoritativeAimingYaw
	local launchTransform = player.soldier.worldTransform:Clone()
	launchTransform.trans = position
	local params = EntityCreationParams()
	params.transform = launchTransform
	params.networked = true
	vehicleName = "Vehicles/M1A2/M1Abrams"
	if player.teamId == 2 then
		vehicleName = "Vehicles/T90/T90"
	end
	blueprint = ResourceManager:SearchForDataContainer(vehicleName)
	vehicleEntityBus = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprint, params))
	for _,entity in pairs(vehicleEntityBus.entities) do
		entity = Entity(entity)
		entity:Init(Realm.Realm_ClientAndServer, true)
	end
end)