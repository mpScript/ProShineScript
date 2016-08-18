-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Victory Road (near Indigo Plateau)"
author = "Silv3r"
description = [[]]

switchMode = true
switchPokemon = false

checkedItem = false
thiefItemArray = {}
killPokemonArray = {}

goToCenterFlag = false

function moveWithMount(target)
	if not isSurfing() and not isMounted() and hasItem("Bicycle") then
		useItem("Bicycle")
	else
		moveToMap(target)
	end
end

function onPathAction()
	switchPokemon = false
	if not goToCenterFlag and not checkedItem then
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
	elseif not switchMode and not goToCenterFlag and not isPokemonUsable(1) then
		log("swap pokemon")
		isSwaped = false
		for i = 1, getTeamSize() do
			if isPokemonUsable(i) and getPokemonLevel(i) < 100 then
				isSwaped = true
				swapPokemon(1, i)
				break
			end
		end
		if not isSwaped then
			goToCenterFlag = true
		end
	elseif not goToCenterFlag and isPokemonUsable(1) then
	log("walking")
		if getMapName() == "Pokecenter Blackthorn" then
			moveToMap("Blackthorn City")
		elseif getMapName() == "Blackthorn City" then
			moveWithMount("Dragons Den Entrance")
		elseif getMapName() == "Dragons Den Entrance" then
			moveToMap("Dragons Den")
		elseif getMapName() == "Dragons Den" then
		--	moveToMap("Dragons Den B1F")
		--elseif getMapName() == "Dragons Den B1F" then
			--moveToRectangle(43, 13, 47, 13)
			--moveNearExit("Dragons Den")
			moveNearExit("Dragons Den Entrance")
			--moveToMap("Dragons Den Entrance") --default location
			--moveToWater()
		end
	else
		if getMapName() == "Dragons Den B1F" then
			moveToMap("Dragons Den")
		elseif getMapName() == "Dragons Den" then
			moveToMap("Dragons Den Entrance")
		elseif getMapName() == "Dragons Den Entrance" then
			moveToMap("Blackthorn City")
		elseif getMapName() == "Blackthorn City" then
			moveToMap("Pokecenter Blackthorn")
		elseif getMapName() == "Pokecenter Blackthorn" then
			goToCenterFlag = false
			pcVisits = pcVisits + 1
			usePokecenter()
		end
	end
end

function onBattleAction()
	checkedItem = false
	log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
	if isWildBattle() and isOpponentShiny() then
	log("onBattleAction - shiny catch")
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	if switchMode and not switchPokemon then
	log("onBattleAction - switchPokemon")
		switchPokemon = true
		return sendUsablePokemon() or sendAnyPokemon() or attack() or run()
	end
	if (not isAlreadyCaught() or getOpponentName() == "Gyarados") and getOpponentHealthPercent() > 20 and hasMove(getActivePokemonNumber(), "False Swipe") then
	log("onBattleAction - False Swipe")
		return useMove("False Swipe") or weakAttack() or attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	end
	if getOpponentHealthPercent() < 20 and (not isAlreadyCaught() or getOpponentName() == "Gyarados" or getOpponentName() == "Slowbro") then
	log("onBattleAction - catch")
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	if isPokemonUsable(getActivePokemonNumber()) then
	log("onBattleAction - kill")
		return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	else
	log("onBattleAction - run")
		for i = 2, 6 do
			if isPokemonUsable(i) then
				return sendPokemon(i) or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			end
		end
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
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
