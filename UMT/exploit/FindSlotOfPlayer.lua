-- Variable globale
PlayerIsland = nil

local function getPlayerIsland()
	for i = 1, 8 do
		local success, prompt = pcall(function()
			return game.Workspace.Placeables[tostring(i)].UnloaderSystem.Unloader.CargoVolume.CargoPrompt
		end)

		if success and prompt then
			-- On a trouvé l'île du joueur
			print("Le joueur possède l'île :", i)
			PlayerIsland = i
			return
		end
	end

	print("Aucune île trouvée pour ce joueur.")
	PlayerIsland = nil
end

-- Appel au démarrage
getPlayerIsland()
