-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 6 (near Celadon)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Celadon City and Route 6.]]

moveY = 37
useSwipe = false

function onPathAction()
	if getPokemonHealth(1) < 20 and hasItem("Fresh Water") then
		log("Drink water...")
		useItemOnPokemon("Fresh Water", 1)
	elseif isPokemonUsable(1) then
		if getMapName() == "Pokecenter Celadon" then
			moveToMap("Celadon City")
		elseif getMapName() == "Celadon City" then
			useSwipe = false
			log("moveing in y="..moveY)
			moveToRectangle(30, moveY, 34, moveY)
		end
	else
		if getMapName() == "Celadon City" then
			moveToMap("Pokecenter Celadon")
		elseif getMapName() == "Pokecenter Celadon" then
			moveY = math.random(36, 38)
			usePokecenter()
		end
	end
end

function onBattleAction()
	moveY = math.random(36, 38)
	log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getOpponentName() == "Squirtle" then
		if getPokemonName(getActivePokemonNumber()) == "Scizor" then
			if not useSwipe then
				useSwipe = true
				return useMove("False Swipe") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			end
		else 
			return sendPokemon(5) or attack() or sendUsablePokemon() or run() or sendAnyPokemon() --target to Scizor
		end

		if isWildBattle() then
			if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
				return
			end
		end
	else
		if getActivePokemonNumber() == 1 then
			return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
		end
	end
end
