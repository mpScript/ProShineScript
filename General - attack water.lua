name = ""
author = "Silv3r"
description = [[]]


function onPathAction() 
	moveToWater()
end

function onBattleAction()
	return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
end
