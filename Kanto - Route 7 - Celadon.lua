-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 7 (near Celadon)"
author = "Silv3r"
description = [[]]

mountItem = "Arcanine Mount"
isWeakAttack = false

goToFlight = true


function onPathAction()
	if isPokemonUsable(1) and goToFlight then
		if getMapName() == "Pokecenter Celadon" then
			moveToMap("Celadon City")
		elseif getMapName() == "Celadon City" then
			moveToMap("Route 7")
		elseif getMapName() == "Route 7" then
			isWeakAttack = false --reset
			if not isMounted() and hasItem(mountItem) then
				useItem(mountItem)
			else
				moveToGrass()
			end
		end
	else
		if getMapName() == "Route 7" then
			moveToMap("Celadon City")
		elseif getMapName() == "Celadon City" then
			moveToMap("Pokecenter Celadon")
		elseif getMapName() == "Pokecenter Celadon" then
			usePokecenter()
		end
	end
end

function onBattleAction()
	if isWildBattle() and getOpponentName() == "Abra" then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end 

	if isWildBattle() and (not isAlreadyCaught() or isOpponentShiny() or getOpponentName() == "Vulpix") then
		if hasPokemonInTeam("Scizor") and getPokemonName(getActivePokemonNumber()) == "Scizor" then
			if not isWeakAttack and hasMove(getActivePokemonNumber(), "False Swipe") then
				isWeakAttack = true
				return useMove("False Swipe") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			end
		else
			--send Scizor
			return sendPokemon(5) or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		end
		
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
end
