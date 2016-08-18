name = "thief item in dragons den - blackthorn"
author = "mkytap"
description = [[]]

checkedItem = false
thiefUsed = false
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
	thiefUsed = false
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
	elseif not goToCenterFlag and getPokemonName(1) == "Scizor" and getPokemonHealth(1) < 80 and getPokemonHealth(1) > 0 and hasItem("Fresh Water") then
	log("onPathAction - drink water")
		log(getPokemonName(1) .. " drinking Fresh Water...")
		useItemOnPokemon("Fresh Water", 1)
	elseif not goToCenterFlag and (not isPokemonUsable(1) --[[or (hasMove(1, "Thief") and getRemainingPowerPoints(1, "Thief") == 0)]]) then
	log("swap pokemon")
		isSwaped = false
		for i = 1, getTeamSize() do
			if isPokemonUsable(i) --[[and hasMove(i, "Thief") and getRemainingPowerPoints(i, "Thief") > 0]] then
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
			--moveToRectangle(10, 0, 60, 30)
			--moveNearExit("Dragons Den")
			--moveNearExit("Dragons Den Entrance")
			--moveNearExit("Blackthorn City")
			--moveToMap("Dragons Den Entrance") --default location
			moveToWater()
		else
			moveToMap("Dragons Den")
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
	log("onBattleAction - shiny")
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	if (not isAlreadyCaught() or getOpponentName() == "Gyarados") and getOpponentHealthPercent() > 20 and hasMove(getActivePokemonNumber(), "False Swipe") then
	log("onBattleAction - False Swipe")
		return useMove("False Swipe") or weakAttack() or attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	end
	if getOpponentHealthPercent() < 20 and (not isAlreadyCaught() or getOpponentName() == "Gyarados" or getOpponentName() == "Dragonair") then
	log("onBattleAction - catching")
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	if not thiefUsed and getActivePokemonNumber() == 1 then
	log("onBattleAction - thief")
		thiefUsed = true
		return useMove("Thief") or attack() or sendUsablePokemon() or sendAnyPokemon() or run()
	else
	log("onBattleAction - kill")
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
