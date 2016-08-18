-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Dragon's Den Water (near Blackthorn)"
author = "Silv3r"
description = [[]]
--Route 30 - city : 8, 96
--city - Route 30: 35, 0
--city - pokeCenter: 51, 6
--pokeCenter - city: 10, 19

cityName = "Cherrygrove City"
pokeCenter = "Pokecenter Cherrygrove City"
route = "Route 30" --8, 96

function onPathAction()
	if getPokemonHealth(1) < 10 then
		useItem("Fresh Water")
	elseif isPokemonUsable(1) then
		if getMapName() == pokeCenter then
			--moveToCell(10, 19)
			moveNearExit(cityName)
		elseif getMapName() == cityName then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToCell(35, 0)
			end
		elseif getMapName() == route then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToGrass()
			end
		end
	else
		if getMapName() == route then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToCell(8, 96)
			end
		elseif getMapName() == cityName then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToCell(51, 6)
			end
		elseif getMapName() == pokeCenter then
			talkToNpcOnCell(10, 11)
		end
	end
end

function onBattleAction()
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end
