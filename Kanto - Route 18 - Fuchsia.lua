-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 18 (near Fuchsia)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Fuchsia City and Route 18.]]

moveXmin = 30
moveXmax = 34
moveYmin = 20
moveYmax = 21
moveY = moveYmin
useSwipe = false
checkedItem = false
thiefItemArray = {}
killPokemonArray = {}

next_action_time = os.time() + math.random(0, 1)

function onPathAction()
	if os.time() < next_action_time then
		log("Waiting to "..next_action_time)
		return
	end
	if not goToCenterFlag and not checkedItem then
	log("onPathAction - checkItem")
		checkedItem = true
		pokemonItem = getPokemonHeldItem(1)
		if pokemonItem then
			for i = 1, 30 do
				if i == 15 then
					log("********Item stealed: " .. pokemonItem)
				else 
					log("**********************************************")
				end
			end
			if thiefItemArray[pokemonItem] then
				thiefItemArray[pokemonItem] = thiefItemArray[pokemonItem] + 1
			else
				thiefItemArray[pokemonItem] = 1
			end
			takeItemFromPokemon(1)
		end
	elseif getPokemonHealth(1) < 20 and hasItem("Fresh Water") then
		log("Drink water...")
		useItemOnPokemon("Fresh Water", 1)
	elseif isPokemonUsable(1) then
		if getMapName() == "Pokecenter Fuchsia" then
			moveToMap("Fuchsia City")
		elseif getMapName() == "Fuchsia City" then
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Route 18")
			end
		elseif getMapName() == "Route 18" then
			useSwipe = false
			log("moveing in y="..moveY)
			if not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToRectangle(moveXmin, moveY, moveXmax, moveY)
			end
		end
	else
		if getMapName() == "Route 18" then
			moveToMap("Fuchsia City")
		elseif getMapName() == "Fuchsia City" then
			moveToMap("Pokecenter Fuchsia")
		elseif getMapName() == "Pokecenter Fuchsia" then
			moveY = math.random(moveYmin, moveYmax)
			pcVisits = pcVisits + 1
			usePokecenter()
		end
	end
end

function onBattleAction()
	checkedItem = false
	moveY = math.random(moveYmin, moveYmax)
	next_action_time = os.time() + math.random(3, 7)
	log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getOpponentName() == "Murkrow" then
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


function onStart()
	startime = os.time()
	pcVisits = 0
	shinyCounter = 0
	wildCounter = 0
	startMoney = getMoney()
	log("\tYou have currently " .. getMoney() .. " Pokedollars.")
	showStatus()
end

function onPause()
	showStatus()
end

function onStop()
	showStatus()
end

function onResume()
	log("******************************************************************")
end

function onBattleMessage(wild)
	if stringContains(wild, "has fainted!") then
		if killPokemonArray[wild] then
			killPokemonArray[wild] = killPokemonArray[wild] + 1
		else
			killPokemonArray[wild] = 1
		end
	end
	if stringContains(wild, "A Wild SHINY ") then
		shinyCounter = shinyCounter + 1
	elseif stringContains(wild, "A Wild ") then
		wildCounter = wildCounter + 1
	end
end

function showStatus()
log("**********************************************************************")
	log("\tMap name: "..getMapName())
	log("\tPlayer: x="..getPlayerX()..", y="..getPlayerY())
	log("\tYou have earned ".. tostring(getMoney() - startMoney) .." PokeDollars!")
	log("\tShinies Caught: " .. shinyCounter)
	log("\tPokemons encountered: " .. wildCounter)
	log("\tYou have visited the PokeCenter ".. pcVisits .." times.")
	endtime = os.time()
	log(string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/3600 ).. " hours | ".."or"..string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/60 ).. " minutes")
	log("\tYou have thief:")
	for k, v in pairs(thiefItemArray) do
		log(v .. "\t" .. k)
	end
	log("\tYou have killed:")
	for k, v in pairs(killPokemonArray) do
		log(v .. "\t" .. k)
	end
	log("------------------------------------------------------------------")
end
