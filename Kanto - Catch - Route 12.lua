-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 6 (near Vermilion)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Vermilion City and Route 6.]]


thiefItemArray = {}
killPokemonArray = {}
checkedItem = false
useSwipe = false
sendScizor = false
goToCenterFlag = false
switchMode = true

function onPathAction() 
	if isSurfing() then
		log("Surfing...")
	end

	if not goToCenterFlag and not checkedItem then
	log("check item")
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
	elseif switchMode and not goToCenterFlag and not isPokemonUsable(1) then
		log("swap pokemon")
		isSwaped = false
		for i = 1, getTeamSize() - 1 do
			if isPokemonUsable(i) then
				isSwaped = true
				swapPokemon(1, i)
				break
			end
		end
		if not isSwaped then
			goToCenterFlag = true
		end
	elseif isPokemonUsable(1) and hasMove(6, "False Swipe") and getRemainingPowerPoints(6, "False Swipe") > 0 then
	log("walking")
		if getMapName() == "Pokecenter Lavender" then
			moveToMap("Lavender Town")
		elseif getMapName() == "Lavender Town" then
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Route 12")
			end
		elseif getMapName() == "Route 12" then
			useSwipe = false
			sendScizor = false
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToRectangle(4, 81, 8, 81)
			end
		end
	else
		if getMapName() == "Route 12" then
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Lavender Town")
			end
		elseif getMapName() == "Lavender Town" then
			if not isSurfing() and not isMounted() and hasItem("Bicycle") then
				useItem("Bicycle")
			else
				moveToMap("Pokecenter Lavender")
			end
		elseif getMapName() == "Pokecenter Lavender" then
			pcVisits = pcVisits + 1
			usePokecenter()
		end
	end
end

function onBattleAction()
	checkedItem = false
	log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
	log("Remain False Swipe PP: "..getRemainingPowerPoints(6, "False Swipe"))
	
	if isWildBattle() and (not isAlreadyCaught() or getOpponentName() == "Snorlax") then
		for i = 1, 30 do
			log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		end
		if not sendScizor then
			sendScizor = true
			return sendPokemon(6)
		end
	
		if not useSwipe then
			useSwipe = true
			return useMove("False Swipe") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		end

		if isWildBattle() then
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
				return
			end
		end
	end
	
	if getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
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
	--log("\tMap name: "..getMapName())
	--log("\tPlayer: x="..getPlayerX()..", y="..getPlayerY())
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