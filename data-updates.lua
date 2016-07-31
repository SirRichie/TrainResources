require "config"

-- use richness to disable resources, since 0 peaks throws an error on game start
function disable_resource_generation(entity)
	if entity and entity.autoplace then
	entity.autoplace.richness_multiplier = 0
	entity.autoplace.richness_base = 0
	end
end

-- adds a peak to an entity so that it is not generated by the autoplace system
-- parameter: the entity to disable for the autoplace system
function disable_enemy_generation(entity)
  if entity and entity.autoplace then
    -- entity.autoplace.peaks[#entity.autoplace.peaks+1] = {influence=-1000}
	entity.autoplace.peaks = {}
  end
end

for resource_name, resource in pairs(data.raw.resource) do
	-- do not spawn the resource naturally
	disable_resource_generation(resource)

	-- make resource infinite
	data.raw.resource[resource_name].infinite = true
	if resource.category and resource.category == "basic-fluid" then
		data.raw.resource[resource_name].minimum  = to.config.liquid_min
		data.raw.resource[resource_name].normal   = to.config.liquid_normal
	else
		data.raw.resource[resource_name].minimum  = to.config.resource_min
		data.raw.resource[resource_name].normal   = to.config.resource_normal
	end
end

for _, spawner in pairs(data.raw["unit-spawner"]) do
	-- do not spawn enemies naturally
	disable_enemy_generation(spawner)
end

for _, turret in pairs(data.raw.turret) do
	-- do not spawn (enemy) turrets naturally
	if turret.subgroup == "enemies" then
		disable_enemy_generation(turret)
	end
end

data.raw["recipe"]["rail"].result_count = 20
--data.raw["recipe"]["straight-rail"].result_count = 20
--data.raw["recipe"]["curved-rail"].result_count = 20