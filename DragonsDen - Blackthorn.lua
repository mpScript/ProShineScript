-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Dragon's Den (near Blackthorn)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Blackthorn City and the Dragon's Den.
You need a pokémon with surf to reach the cave.]]

trainWeakMode = true
idSwaped = false

function onPathAction()
	if getPokemonLevel(1) >= 95 then
		if not isTeamSortedByLevelDescending() then
			sortTeamByLevelDescending()
		else
			for i = 2, 6 do
				if isPokemonUsable(i) and getPokemonLevel(i) < 95 then
					swapPokemon(1, i)
					break
				end
			end
		end
	elseif not isPokemonUsable(1) and getUsablePokemonCount() > 3 then
		if not isPokemonUsable(1) then
			for i = 2, 6 do
				if isPokemonUsable(i) then
					swapPokemon(1, i)
					break
				end
			end
		end
	elseif isPokemonUsable(1) then
		if getMapName() == "Pokecenter Blackthorn" then
			moveToMap("Blackthorn City")
		elseif getMapName() == "Blackthorn City" then
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Dragons Den Entrance")
			end
		elseif getMapName() == "Dragons Den Entrance" then
			moveToMap("Dragons Den")
		elseif getMapName() == "Dragons Den" then
			--moveNearExit("Dragons Den Entrance")
			idSwaped = false
			moveToWater()
		end
	else
		if getMapName() == "Dragons Den" then
			moveToMap("Dragons Den Entrance")
		elseif getMapName() == "Dragons Den Entrance" then
			moveToMap("Blackthorn City")
		elseif getMapName() == "Blackthorn City" then
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Pokecenter Blackthorn")
			end
		elseif getMapName() == "Pokecenter Blackthorn" then
			usePokecenter()
		end
	end
end

function onBattleAction()
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	
	-- catch the following pokemon
	if isWildBattle() and getOpponentName() == "Dratini" or getOpponentName() == "Dragonair" then
		log(">>> OpponentHealth="..getOpponentHealth())
		if getOpponentHealth() > 70 then
			return weakAttack() or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
				return
			end
		end
	end
	
	if not idSwaped and getPokemonLevel(1) < 50 then
		idSwaped = true
		return sendUsablePokemon() or sendAnyPokemon() or attack() or run()
	end
	
	if getActivePokemonNumber() == 1 then
		if getOpponentName() == "Quagsire" or getOpponentName() == "Golduck"  then
			return useMove("Crunch") or useMove("Ice Fang") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		end
	else
		return attack() or run() or sendUsablePokemon() or sendAnyPokemon()
	end
end
