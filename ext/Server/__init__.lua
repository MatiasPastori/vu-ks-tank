---@class KSTankServer
---@overload fun(): KSTankServer
KSTankServer = class("KSTankServer")

function KSTankServer:__init()
	self:RegisterVars()
	self:RegisterEvents()
end

function KSTankServer:RegisterVars()
	self.TanksEnabled = false
end

function KSTankServer:RegisterEvents()
	Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
	Events:Subscribe('Level:Destroy', self, self.OnLevelDestroy)
	self.playerSyncevent = NetEvents:Subscribe('KSTankServer:PlayerSync', self, self.OnPlayerSync)
	self.launchEvent = NetEvents:Subscribe('vu-ks-tank:Launch', function(player, position)
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
		for _, entity in pairs(vehicleEntityBus.entities) do
			entity = Entity(entity)
			entity:Init(Realm.Realm_ClientAndServer, true)
		end
	end)
end

function KSTankServer:OnLevelLoaded()
	local chopperUS = "Vehicles/M1A2/M1Abrams"
	local chopperRU = "Vehicles/T90/T90"
	local blueprintUS = ResourceManager:SearchForDataContainer(chopperUS)
	local blueprintRU = ResourceManager:SearchForDataContainer(chopperRU)
	local params = EntityCreationParams()
	params.networked = true
	-- This next 2 lines are known to cause issues for maps that don't have the requested vehicles.
	-- I don't really know how to avoid the erros but it works for our purpose of checking if the vehicle is available for the map.
	local vehicleEntityBusUS = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprintUS, params))
	local vehicleEntityBusRU = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprintRU, params))
	if vehicleEntityBusUS ~= nil and vehicleEntityBusRU ~= nil then
		print('Entities correctly created from blueprints!')
		self.TanksEnabled = true
	end
end

function KSTankServer:OnLevelDestroy()
	self:RegisterVars()
end

function KSTankServer:OnPlayerSync(player)
	print('|||||||||||||| KSTankServer: OnPlayerSync recieved!')
	NetEvents:SendTo("KSTankServer:Enabled", player, self.TanksEnabled)
end

KSTankServer = KSTankServer()



return KSTankServer
