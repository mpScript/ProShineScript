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
train_first_X_pokemon = 1
weakAttackCount = 0
thiefItemCount = 0

function onPathAction()
	if not checkedItem then -- remove item if the first pokemon bring item
		checkedItem = true
		if getPokemonHeldItem(1) then
			thiefItemCount = thiefItemCount + 1
			takeItemFromPokemon(1)
		end
	elseif isPokemonUsable(1) and weakAttackCount < 50 then
		--if getMapName() == "Indigo Plateau Center" and isShopOpen() and getItemQuantity("Ultra Ball") < 50 then -- in the center, buy ultra ball until >= 50
		--	buyItem("Ultra Ball", 10)
		--[[if getMapName() == "Indigo Plateau Center" then -- go outside of center
			moveToMap("Indigo Plateau")
		elseif getMapName() == "Indigo Plateau" then -- go to cave
			moveToMap("Victory Road Kanto 3F")
		elseif getMapName() == "Victory Road Kanto 3F" then -- walking
			moveToRectangle(46, 14, 46, 17)
		else
			moveToMap("Indigo Plateau")
		end]]
		if getMapName() == "Pokecenter Cinnabar" then
			moveToMap("Cinnabar Island")
		elseif getMapName() == "Cinnabar Island" then
			moveToMap("Route 21")
		elseif getMapName() == "Route 21" then
			moveToWater()
		end
	--[[elseif getUsablePokemonCount() > 6 - train_first_X_pokemon then -- swap another if it exists
		for i = 2, 6 do
			if isPokemonUsable(i) then
				swapPokemon(1, i)
				break
			end
		end]]
	else -- when remain one pokemon left, go to heal
		--[[if getMapName() == "Victory Road Kanto 3F" then
			moveToMap("Indigo Plateau")
		--elseif getMapName() == "Indigo Plateau" and not isSortTeamByLeveAscending() then
		--	sortTeamByLevelAscending()
		elseif getMapName() == "Indigo Plateau" then
			moveToMap("Indigo Plateau Center")
		elseif getMapName() == "Indigo Plateau Center" then
			weakAttackCount = 0
			talkToNpcOnCell(4, 22)
		end]]
		if getMapName() == "Route 21" then
			moveToMap("Cinnabar Island")
		elseif getMapName() == "Cinnabar Island" then
			moveToMap("Pokecenter Cinnabar")
		elseif getMapName() == "Pokecenter Cinnabar" then
			weakAttackCount = 0
			pcVisits = pcVisits + 1
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
	if getActivePokemonNumber() == 1 then -- first pokemon is active
		weakAttackCount = weakAttackCount + 1
		return useMove("Thief") or attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	else -- swap or run
		weakAttackCount = weakAttackCount + 1
		return useMove("Thief") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	end
end

function onStart()
	startime = os.time()
	pcVisits = 0
	shinyCounter = 0
	wildCounter = 0
	startLevel = {}
	for i = 1,6 do
		startLevel[getPokemonName(i)] = getPokemonLevel(i)
	end
	startMoney = getMoney()
	--for i = 1,6 do
	--	sortTeamByLevelAscending()
	--end
	log("***********************************START - SESSION STATS***********************************")
	log("\tYou have currently " .. getMoney() .. " Pokedollars.")
	for i = 1,6 do
		log("\tYour " .. getPokemonName(i) .. " is Level " .. startLevel[getPokemonName(i)] .. ".")
	end
	log("*********************************************************************************************")
end

function onPause()
	log("***********************************PAUSED - SESSION STATS***********************************")
	--log("Pokemon 1 holding "..getPokemonHeldItem(1))
	log("\tMap name: "..getMapName())
	log("\tPlayer: x="..getPlayerX()..", y="..getPlayerY())
	log("\tWeakattack count="..weakAttackCount)
	log("\tThief items count="..thiefItemCount)
	for i = 1,6 do
		log("\tYour Pokemon, ".. getPokemonName(i) ..", has gained ".. (getPokemonLevel(i) - startLevel[getPokemonName(i)]) .." levels!")
	end
	log("\tYou have earned ".. tostring(getMoney() - startMoney) .." PokeDollars!")
	log("\tShinies Caught: " .. shinyCounter)
	log("\tPokemons encountered: " .. wildCounter)
	log("\tYou have visited the PokeCenter ".. pcVisits .." times.")
	endtime = os.time()
	log(string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/3600 ).. " hours | ".."or"..string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/60 ).. " minutes")
	log("*********************************************************************************************")
end

function onStop()
	log("***********************************PAUSED - SESSION STATS***********************************")
	for i = 1,6 do
		log("\tYour Pokemon, ".. getPokemonName(i) ..", has gained ".. (getPokemonLevel(i) - startLevel[getPokemonName(i)]) .." levels!")
	end
	log("\tYou have earned ".. tostring(getMoney() - startMoney) .." PokeDollars!")
	log("\tShinies Caught: " .. shinyCounter)
	log("\tPokemons encountered: " .. wildCounter)
	log("\tYou have visited the PokeCenter ".. pcVisits .." times.")
	endtime = os.time()
	log(string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/3600 ).. " hours | ".."or"..string.format("\tBot running time: %.2f", os.difftime(endtime,startime)/60 ).. " minutes")
	log("*********************************************************************************************")
end

function onResume()
	log("***********************************SESSION RESUMED***********************************")
end

function onBattleMessage(wild)
	if stringContains(wild, "A Wild SHINY ") then
		shinyCounter = shinyCounter + 1
	elseif stringContains(wild, "A Wild ") then
		wildCounter = wildCounter + 1
	end
end
