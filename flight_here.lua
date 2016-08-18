-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Victory Road (near Indigo Plateau)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between the exit of the Victory Road and the Indigo Plateau.]]
checkedItem = false
train_first_X_pokemon = 4
weakAttackCount = 0

city_name = "Ecruteak City"
poke_name = "Pokecenter Ecruteak"
route_name = "Route 37"

function onPathAction()
	if false or not checkedItem then -- remove item if the first pokemon bring item
		checkedItem = true
		if getPokemonHeldItem(1) then
			takeItemFromPokemon(1)
		end
	--elseif isPokemonUsable(1) then
	elseif getUsablePokemonCount() > 6-train_first_X_pokemon then
		if getMapName() == poke_name then
			moveToMap(city_name)
		elseif getMapName() == city_name then
			moveToMap(route_name)
		elseif getMapName() == route_name then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToGrass()
			end
		end
	else
		if getMapName() == route_name then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap(city_name)
			end
		elseif getMapName() == city_name then
			moveToMap(poke_name)
		elseif getMapName() == poke_name then
			usePokecenter()
		end
	end
end

function onBattleAction()
	checkedItem = false -- reset check item, it will check in next walking
	if isWildBattle() and isOpponentShiny() then -- catch shiny
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getActivePokemonNumber() == 1 and (isOpponentEffortValue("Attack") or isOpponentEffortValue("Speed")) then -- first pokemon is active
		return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	else -- swap or run
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end