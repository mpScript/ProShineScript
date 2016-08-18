-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 6 (near Vermilion)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Vermilion City and Route 6.]]

moveY = 31
useSwipe = false

function onPathAction()
	if getPokemonHealth(1) < 20 and hasItem("Fresh Water") then
		log("Drink water...")
		useItemOnPokemon("Fresh Water", 1)
	elseif isPokemonUsable(1) then
		if getMapName() == "Pokecenter Vermilion" then
			moveToMap("Vermilion City")
		elseif getMapName() == "Vermilion City" then
			useSwipe = false
			log("moveing in y="..moveY)
			moveToRectangle(26, moveY, 32, moveY)
		end
	else
		if getMapName() == "Vermilion City" then
			moveToMap("Pokecenter Vermilion")
		elseif getMapName() == "Pokecenter Vermilion" then
			moveY = math.random(30, 32)
			usePokecenter()
		end
	end
end

function onBattleAction()
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
