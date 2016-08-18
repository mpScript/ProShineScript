-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 6 (near Vermilion)"
author = "Silv3r"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Vermilion City and Route 6.]]

useSwipe = false

function onPathAction() 
	if hasMove(1, "False Swipe") and getRemainingPowerPoints(1, "False Swipe") > 0 then
		if getMapName() == "Pokecenter Vermilion" then
			moveToMap("Vermilion City")
		elseif getMapName() == "Vermilion City" then
			useSwipe = false
			moveToRectangle(26, 31, 32, 31)
		end
	else
		if getMapName() == "Route 6" then
			moveToMap("Vermilion City")
		elseif getMapName() == "Vermilion City" then
			moveToMap("Pokecenter Vermilion")
		elseif getMapName() == "Pokecenter Vermilion" then
			usePokecenter()
		end
	end
end

function onBattleAction()
	log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
	log("Remain False Swipe PP: "..getRemainingPowerPoints(1, "False Swipe"))
	
	if not useSwipe then
		useSwipe = true
		return useMove("False Swipe") or attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	end

	if isWildBattle() then
		if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
			return
		end
	end
	
	if getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end
