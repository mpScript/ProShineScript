name = ""
author = "Silv3r"
description = [[]]


function onPathAction() 
	moveToGrass()
end

function onBattleAction()
	return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
end
