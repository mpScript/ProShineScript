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

isSwaped = false

city_name = "Fuchsia City"
poke_name = "Pokecenter Fuchsia"
stop_name = "Fuchsia City Stop House"
route_name = "Route 19"


function onPathAction()
	if false or not checkedItem then -- remove item if the first pokemon bring item
		checkedItem = true
		if getPokemonHeldItem(1) then
			takeItemFromPokemon(1)
		end
	--elseif isPokemonUsable(1) then
	elseif isPokemonUsable(1) and getPokemonHealth(1) < 50 then
		useItemOnPokemon("Fresh Water", 1)
	elseif isPokemonUsable(1) and getUsablePokemonCount() > getTeamSize() - train_first_X_pokemon then
		if getMapName() == poke_name then
			moveToMap(city_name)
		elseif getMapName() == city_name then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap(stop_name)
			end
		elseif getMapName() == stop_name then
			moveToMap(route_name)
		elseif getMapName() == route_name then
			if false and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				isSwaped = false
				moveToWater()
				--moveToGrass()
			end
		else
			moveToMap(route_name)
		end
	else
		if getMapName() == route_name then
			if false and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap(stop_name)
				--moveToMap(city_name)
			end
		elseif getMapName() == stop_name then
			moveToMap(city_name)
		elseif getMapName() == city_name then
			moveToMap(poke_name)
		elseif getMapName() == poke_name then
			usePokecenter()
		else
			moveToMap(route_name)
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
	if 
		isOpponentEffortValue("Health") or 
		--isOpponentEffortValue("Attack") or 
		--isOpponentEffortValue("Defence") or 
		--isOpponentEffortValue("SpAttack") or 
		isOpponentEffortValue("SpDefence") 
		--isOpponentEffortValue("Speed")
		 then -- first pokemon is active
		
		if not isSwaped then
			isSwaped = true
			return sendUsablePokemon() or sendAnyPokemon() or attack() or run()
		end
		return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	else -- swap or run
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end