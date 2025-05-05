if game.PlaceId == 18680867089 then
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
Name = "mScript | UMT [PAID] | .gg/mScript",
Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
LoadingTitle = "mScript | .gg/mScript",
LoadingSubtitle = "by mScript",
Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

DisableRayfieldPrompts = false,
DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

ConfigurationSaving = {
    Enabled = false,
    FolderName = nil, -- Create a custom folder for your hub/game
    FileName = "UMTScript"
},

Discord = {
    Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
    Invite = "6Nmj8K9ehq", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
    RememberJoins = true -- Set this to false to make them join the discord every time they load it up
},

KeySystem = false, -- Set this to true to use our key system
KeySettings = {
    Title = "UMT Key System",
    Subtitle = "Link in the discord",
    Note = "Join server from misc tab", -- Use this to tell the user how to get a key
    FileName = "UMTScriptKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
    SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
    GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
    Key = {"https://pastebin.com/raw/96UNptFE"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
}
})

PlayerSlot = nil

local function getPlayerSlot()
    for i = 1, 8 do
        local success, prompt = pcall(function()
            return game.Workspace.Placeables[tostring(i)].VehicleSpawner.ScreenPart.ProximityPrompt
        end)

        if success and prompt then
            PlayerSlot = i
            return
        end
    end

    PlayerSlot = nil
end

getPlayerSlot()


    local MainTab = Window:CreateTab("🛠️ Main", nil)
    local MainSection = MainTab:CreateSection("📋 General Utilities")


    local TeleportTab = Window:CreateTab("📍 Teleport", nil)


    local MiscTab = Window:CreateTab("🎲 Misc", nil)


    local FarmTab = Window:CreateTab("🚜 Farm", nil)

    local MobileTab = Window:CreateTab("📱 Mobile", nil)
    local MobileSection = MobileTab:CreateSection("📱 For phone user")

    ------------------------------------------------- MAIN TAB -------------------------------------------------
    ------------------------------------------------- MAIN TAB -------------------------------------------------
    ------------------------------------------------- MAIN TAB -------------------------------------------------
    ------------------------------------------------- MAIN TAB -------------------------------------------------
    ------------------------------------------------- MAIN TAB -------------------------------------------------

    local Toggle = MainTab:CreateToggle({
        Name = "💥 Infinite Jump",
        CurrentValue = false,
        Flag = "InfiniteJumpToggle",
        Callback = function(Value)
             _G.infinjump = Value
     
             Rayfield:Notify({
                 Title = Value and "🚀 Infinite Jump Enabled!" or "🛑 Infinite Jump Disabled",
                 Content = Value and "You can now jump infinitely! 🌌" or "Infinite jump has been turned off.",
                 Duration = 5,
                 Image = 4483362458,
             })
     
             if _G.infinJumpStarted == nil then
                 _G.infinJumpStarted = true
     
                 local plr = game:GetService("Players").LocalPlayer
                 local m = plr:GetMouse()
     
                 m.KeyDown:Connect(function(k)
                     if _G.infinjump and k:byte() == 32 then -- Space key
                         local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                         if humanoid then
                             humanoid:ChangeState("Jumping")
                             task.wait()
                             humanoid:ChangeState("Seated")
                         end
                     end
                 end)
             end
        end,
     })
     
    
    local Slider = MainTab:CreateSlider({
        Name = "⚡ WalkSpeed Input",
        Range = {16, 300},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 16,
        Flag = "Slider1",

        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
     })

    ------------------------------------------------- TELEPORT TAB -------------------------------------------------
    ------------------------------------------------- TELEPORT TAB -------------------------------------------------
    ------------------------------------------------- TELEPORT TAB -------------------------------------------------
    ------------------------------------------------- TELEPORT TAB -------------------------------------------------
    ------------------------------------------------- TELEPORT TAB -------------------------------------------------

    local TeleportSection = TeleportTab:CreateSection("🧭 Teleport To Player")

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local playerNames = {}
    local teleportDropdown
    local currentSelection = nil
    
    -- Fonction pour actualiser la liste de joueurs
    local function updatePlayerList()
        playerNames = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
    
        -- Mise à jour du dropdown
        if teleportDropdown then
            teleportDropdown:Refresh(playerNames)
    
            -- Si la sélection actuelle n'existe plus, on la reset
            if currentSelection and not table.find(playerNames, currentSelection) then
                teleportDropdown:Set({})
                currentSelection = nil
            end
        end
    end
    
    -- Crée le dropdown
    teleportDropdown = TeleportTab:CreateDropdown({
        Name = "🚀 Teleport to Player",
        Options = playerNames,
        CurrentOption = {},
        MultipleOptions = false,
        Flag = "TeleportToPlayerDropdown",
        Callback = function(Options)
            local targetName = Options[1]
            currentSelection = targetName
    
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                end
            else
                Rayfield:Notify({
                    Title = "⚠️ Teleport Failed",
                    Content = "The target player is no longer available.",
                    Duration = 4,
                    Image = 4483362458,
                })
            end
        end,
    })
    
    -- Écoute les connexions et déconnexions
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    
    -- Initialisation
    updatePlayerList()

    local Divider = TeleportTab:CreateDivider()
    local TeleportSection = TeleportTab:CreateSection("🧭 Quick Travel Options")

    local DropdownStaticTP = TeleportTab:CreateDropdown({
        Name = "📍 Static Teleport Locations",
        Options = {
            "⛏️ Pickaxe Man",
            "🎒 Backpack Shop",
            "💣 Explosive Trader",
            "🔁 Rebirth Store",
            "⛏️ Mine Entrance"
        },
        CurrentOption = {"Choose location"},
        MultipleOptions = false,
        Flag = "StaticTeleports",
        Callback = function(selectedOption)
            local plr = game.Players.LocalPlayer.Name
            local hrp = game.Workspace[plr]:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
    
            local destinations = {
                ["⛏️ Pickaxe Man"] = Vector3.new(-1542.52, 9.99, 35.40),
                ["🎒 Backpack Shop"] = Vector3.new(-1543.13, 9.998, 6.05),
                ["💣 Explosive Trader"] = Vector3.new(391.80, 78.23, -752.38),
                ["🔁 Rebirth Store"] = Vector3.new(-1474.44, 9.998, 241.91),
                ["⛏️ Mine Entrance"] = Vector3.new(-1853.72, 4.88, -194.68),
            }
    
            local pos = destinations[selectedOption[1]]
            if pos then
                hrp.CFrame = CFrame.new(pos)
    
                -- Add notification to inform the player about the teleport
                Rayfield:Notify({
                    Title = "📡 Teleporting",
                    Content = selectedOption[1] .. " 🚀",
                    Duration = 5,
                    Image = 4483362458,  -- You can change this image ID
                })
            end
        end,
    })
    
    local Divider = TeleportTab:CreateDivider()
    local TeleportSection = TeleportTab:CreateSection("🧭 Plot Teleport Options")

    local DropdownJsp = TeleportTab:CreateDropdown({
        Name = "📍 Teleport to a Custom Plot [1-8]",
        Options = {
            "1️⃣ Plot 1", "2️⃣ Plot 2", "3️⃣ Plot 3", "4️⃣ Plot 4",
            "5️⃣ Plot 5", "6️⃣ Plot 6", "7️⃣ Plot 7", "8️⃣ Plot 8"
        },
        CurrentOption = {"Select a plot"},
        MultipleOptions = false,
        Flag = "teleportPlots",
        Callback = function(selectedOption)
            local plr = game.Players.LocalPlayer.Name
            local hrp = game.Workspace[plr]:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
    
            local plotPositions = {
                ["1️⃣ Plot 1"] = Vector3.new(-224.79, 4.98, -345.75),
                ["2️⃣ Plot 2"] = Vector3.new(-91.20, 4.98, -453.21),
                ["3️⃣ Plot 3"] = Vector3.new(93.34, 4.98, -451.38),
                ["4️⃣ Plot 4"] = Vector3.new(230.96, 4.98, -335.90),
                ["5️⃣ Plot 5"] = Vector3.new(233.72, 4.98, -57.35),
                ["6️⃣ Plot 6"] = Vector3.new(83.24, 4.97, 54.54),
                ["7️⃣ Plot 7"] = Vector3.new(-98.54, 4.98, 48.83),
                ["8️⃣ Plot 8"] = Vector3.new(-238.49, 4.98, -70.66),
            }
    
            local destination = plotPositions[selectedOption[1]]
            if destination then
                hrp.CFrame = CFrame.new(destination)
    

                Rayfield:Notify({
                    Title = "🚀 Teleporting to " .. selectedOption[1],
                    Content = "You have been teleported to " .. selectedOption[1] .. " 🌍",
                    Duration = 5,
                    Image = 4483362458,  
                })
            end
        end,
    })

    local Button = TeleportTab:CreateButton({
        Name = "🔑 Teleport to Your Slot",
        Callback = function()
            local plr = game.Players.LocalPlayer.Name
    
            local slotPos = game.Workspace.Plots[PlayerSlot].Centre.Position
            local slotPosX = slotPos.X
            local slotPosY = slotPos.Y + 10
            local slotPosZ = slotPos.Z
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(slotPosX, slotPosY, slotPosZ)
    
            -- Notify the player about teleportation
            Rayfield:Notify({
                Title = "🚀 Teleportation Successful",
                Content = "You have been teleported to your slot! 🏠",
                Duration = 5,
                Image = 4483362458,  -- Change this to your preferred image ID
            })
        end,
    })

    ------------------------------------------------- MISC TAB -------------------------------------------------
    ------------------------------------------------- MISC TAB -------------------------------------------------
    ------------------------------------------------- MISC TAB -------------------------------------------------
    ------------------------------------------------- MISC TAB -------------------------------------------------
    ------------------------------------------------- MISC TAB -------------------------------------------------

    local MiscSection = MiscTab:CreateSection("🧰 Buy Tools & Extras")

    local Button = MiscTab:CreateButton({
        Name = "🛒 Buy Vehicle (TPs to your slot)",
        Callback = function()
            local plr = game.Players.LocalPlayer.Name
            local vehicleSpawnerPos = game.Workspace.Placeables[PlayerSlot].VehicleSpawner.ScreenPart.Position
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(vehicleSpawnerPos)
    
            local prox = game.Workspace.Placeables[PlayerSlot].VehicleSpawner.ScreenPart.ProximityPrompt
            fireproximityprompt(prox)
        end,
    })

    local DropDownBackpack = MiscTab:CreateDropdown({

        Name = "🎒 Buy & Equip Backpack",
        Options = {
            "🟩 Small Backpack | 100$",
            "🟨 Medium Backpack | 5000$",
            "🟥 Large Backpack | 100k$",
            "🔷 XL Backpack | 1500K$"
        },
        CurrentOption = {"Buy Backpack"},
        MultipleOptions = false,
        Flag = "backpackShop",
        Callback = function(selectedOption)
            local plr = game.Players.LocalPlayer.Name
            local plrOriginalPos = game.Workspace[plr].HumanoidRootPart.Position
            local shopPos = Vector3.new(-1543.1331787109375, 9.99802303314209, 6.049820899963379)
    
            local backpackData = {
                ["🟩 Small Backpack | 100$"] = {buy = "SmallBackpack", equip = "SmallBackpack"},
                ["🟨 Medium Backpack | 5000$"] = {buy = "MediumBackpack", equip = "MediumBackpack"},
                ["🟥 Large Backpack | 100k$"] = {buy = "LargeBackpack", equip = "LargeBackpack"},
                ["🔷 XL Backpack | 1500K$"] = {buy = "XLBackpack", equip = "XLBackpack"},
            }
    
            local data = backpackData[selectedOption[1]]
            if not data then return end
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(shopPos)
    
            local argsBuy = { [1] = 7, [2] = data.buy }
            game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("5").BuyItem:FireServer(unpack(argsBuy))
            wait(0.1)
    
            local argsEquip = { [1] = 426, [2] = "Backpack", [3] = data.equip }
            game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("3").EquipItem:FireServer(unpack(argsEquip))
            wait(0.1)
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(plrOriginalPos)
        end,        
    })

    local DropDownPickaxe = MiscTab:CreateDropdown({
        Name = "⛏️ Buy & Equip Pickaxe",
        Options = {
            "Cooper Pickaxe | 40$",
            "Iron Pickaxe | 500$",
            "Steel Pickaxe | 5000$",
            "Platinum Pickaxe | 25000$",
            "Titanium Pickaxe | 100k$",
            "Infernum Pickaxe | 1000k$",
            "Diamond Pickaxe | 2500k$",
            "Mithril Pickaxe | 5000k$",
            "Adamantium Pickaxe | 10M$",
            "Unobtainium Pickaxe | 25M$"
            
        },
        CurrentOption = {"Buy Pickaxe"},
        MultipleOptions = false,
        Flag = "pickaxeShop",
        Callback = function(selectedOption)
            local selected = selectedOption[1]
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            if not selected or not char then return end
    
            local pickaxeData = {
                ["Cooper Pickaxe | 40$"] = { buy = "CopperPick", equip = "CopperPick" },
                ["Iron Pickaxe | 500$"] = { buy = "IronPick", equip = "IronPick" },
                ["Steel Pickaxe | 5000$"] = { buy = "SteelPick", equip = "SteelPick" },
                ["Platinum Pickaxe | 25000$"] = { buy = "PlatinumPick", equip = "PlatinumPick" },
                ["Titanium Pickaxe | 100k$"] = { buy = "TitaniumPick", equip = "TitaniumPick" },
                ["Infernum Pickaxe | 1000k$"] = { buy = "InfernumPick", equip = "InfernumPick" },
                ["Diamond Pickaxe | 2500k$"] = { buy = "DiamondPick", equip = "DiamondPick" },
                ["Mithril Pickaxe | 5000k$"] = { buy = "MithrilPick", equip = "MithrilPick" },
                ["Adamantium Pickaxe | 10M$"] = { buy = "AdamantiumPick", equip = "AdamantiumPick" },
                ["Unobtainium Pickaxe | 25M$"] = { buy = "UnobtainiumPick", equip = "UnobtainiumPick" }
            }
    
            local data = pickaxeData[selected]
            if not data then return end
    
            local originalPos = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
            if not originalPos then return end
    
            local shopPos = Vector3.new(-1542.52, 9.99, 35.40)
    
            char.HumanoidRootPart.CFrame = CFrame.new(shopPos)
            wait(0.1)
    
            local argsBuy = { [1] = 7, [2] = data.buy }
            game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("5").BuyItem:FireServer(unpack(argsBuy))
            wait(0.1)
    
            local argsEquip = { [1] = 426, [2] = "Backpack", [3] = data.equip }
            game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("3").EquipItem:FireServer(unpack(argsEquip))
            wait(0.1)
    
            char.HumanoidRootPart.CFrame = CFrame.new(originalPos)
    
        end,
    })

    local Divider = MiscTab:CreateDivider()
    local MiscSection = MiscTab:CreateSection("🧰 Open Tools & Extras")

    local Button = MiscTab:CreateButton({
        Name = "🚗 Open Vehicle Shop",
        Callback = function()
            local prox = game.Workspace.Placeables[PlayerSlot].VehicleSpawner.ScreenPart.ProximityPrompt
            fireproximityprompt(prox)
        end,
    })

    local Button = MiscTab:CreateButton({
        Name = "🎒 Open Backpack Shop",
        Callback = function()
            local plr = game.Players.LocalPlayer.Name
            local plrOriginalPos = game.Workspace[plr].HumanoidRootPart.Position
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(-1543.1331787109375, 9.99802303314209, 6.049820899963379)
    
            local prox = game.Workspace.BackpackStore.ActivationPoint.ProximityPrompt
            fireproximityprompt(prox)
    
            wait(5)
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(plrOriginalPos)
        end,
    })

    local Button = MiscTab:CreateButton({
        Name = "⛏️ Open Pickaxe Shop",
        Callback = function()
            local plr = game.Players.LocalPlayer.Name
            local plrOriginalPos = game.Workspace[plr].HumanoidRootPart.Position
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(-1542.52, 9.99, 35.40)
    
            local prox = game.Workspace["Pick Store"].ActivationPoint.ProximityPrompt
            fireproximityprompt(prox)
    
            wait(5)
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(plrOriginalPos)
        end,
    })
    

    ------------------------------------------------- FARM TAB -------------------------------------------------
    ------------------------------------------------- FARM TAB -------------------------------------------------
    ------------------------------------------------- FARM TAB -------------------------------------------------
    ------------------------------------------------- FARM TAB -------------------------------------------------
    ------------------------------------------------- FARM TAB -------------------------------------------------

    local FarmSection = FarmTab:CreateSection("🤖 Farming Keybind")


    local Keybind = FarmTab:CreateKeybind({
        Name = "📦 Store Everything",
        CurrentKeybind = "U",
        HoldToInteract = false,
        Flag = "Keybind1",
        Callback = function()
            local originalPlayerPos = nil
    
            local plr = game.Players.LocalPlayer.Name
            local originalPlayerPos = game.Workspace[plr].HumanoidRootPart.Position
    
            Rayfield:Notify({
                Title = "🚚 Heading to Unloader",
                Content = "Moving to the unloader to store your cargo...",
                Duration = 4,
                Image = 4483362458,
            })
    
            local promptCargo = game.Workspace.Placeables[PlayerSlot].UnloaderSystem.Unloader.CargoVolume.CargoPrompt
            local promptPostion = game.Workspace.Placeables[PlayerSlot].UnloaderSystem.Unloader.CargoVolume.Position
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(promptPostion)
            wait(0.4)
            fireproximityprompt(promptCargo)
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(originalPlayerPos)
    
            Rayfield:Notify({
                Title = "✅ Stored Successfully",
                Content = "📦 Your cargo has been unloaded and stored!",
                Duration = 6.5,
                Image = 4483362458,
            })
        end,
    })

    local Keybind = FarmTab:CreateKeybind({
        Name = "💥 Explosive Exploit",
        CurrentKeybind = "Y",
        HoldToInteract = false,
        Flag = "Keybind1",
        Callback = function()
            task.spawn(function()
                local correspondances = {
                    ["Dynamite Level 1"] = "TNT1",
                    ["Dynamite Level 2"] = "TNT2",
                    ["Dynamite Level 3"] = "TNT3",
                    ["Dynamite Bundle Level 1"] = "TNTBundle1",
                    ["Dynamite Bundle Level 2"] = "TNTBundle2",
                    ["Dynamite Bundle Level 3"] = "TNTBundle3",
                    ["C4 Level 1"] = "C41",
                    ["C4 Level 2"] = "C42",
                    ["C4 Level 3"] = "C43",
                    ["C4 Level 4"] = "C44",
                    ["C4 Level 5"] = "C45",
                }
    
                local correspondancesPioche = {
                    ["Rusty Pickaxe"] = "RustyPick",
                    ["Iron Pickaxe"] = "IronPick",
                    ["Steel Pickaxe"] = "SteelPick",
                    ["Platinum Pickaxe"] = "PlatinumPick",
                    ["Titanium Pickaxe"] = "TitaniumPick",
                    ["Infernum Pickaxe"] = "InfernumPick",
                    ["Diamond Pickaxe"] = "DiamondPick",
                    ["Mithril Pickaxe"] = "MithrilPick",
                    ["Adamantium Pickaxe"] = "AdamantiumPick",
                    ["Unobtainium Pickaxe"] = "UnobtainiumPick",
                }
    
                local player = game.Players.LocalPlayer
                local backpack = player:FindFirstChild("InnoBackpack")
                local character = player.Character or player.CharacterAdded:Wait()
                if not backpack or not character then return end
    
                -- 1. Déséquiper tous les explosifs
                for name, _ in pairs(correspondances) do
                    local tool = character:FindFirstChild(name) or backpack:FindFirstChild(name)
                    if tool and tool:FindFirstChild("EquipRemote") then
                        pcall(function()
                            tool.EquipRemote:FireServer(false)
                        end)
                    end
                end
    
                -- 2. Pioche : équiper/déséquiper
                for _, item in ipairs(backpack:GetChildren()) do
                    if correspondancesPioche[item.Name] and item:FindFirstChild("EquipRemote") then
                        pcall(function()
                            item.EquipRemote:FireServer(true)
                            wait(0.1)
                            item.EquipRemote:FireServer(false)
                        end)
                        break
                    end
                end
    
                wait(0.1)
    
                -- 3. Trouver l'explosif à équiper
                local explosiveId
                for _, item in ipairs(backpack:GetChildren()) do
                    local id = correspondances[item.Name]
                    if id then
                        explosiveId = id
                        break
                    end
                end
    
                -- 4. Envoyer les RemoteEvents pour changer d'explosif
                if explosiveId then
                    local equipTool = game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("4"):FindFirstChild("EquipTool")
                    if equipTool then
                        pcall(function()
                            equipTool:FireServer(23, "Explosive", "TNT1")
                            wait(0.05)
                            equipTool:FireServer(23, "Explosive", explosiveId)
                        end)
                    end
                end    
            end)
        end,
    })

    
    LocalLastPosition = nil
    
    local Keybind = FarmTab:CreateKeybind({
        Name = "📍 Save Current Position",
        CurrentKeybind = "T",
        HoldToInteract = false,
        Flag = "Keybind1",
        Callback = function()
        local plr = game.Players.LocalPlayer.Name
        LocalLastPosition = game.Workspace[plr].HumanoidRootPart.Position
    
        Rayfield:Notify({
            Title = "✅ Position Saved",
            Content = "Your current position has been successfully saved.",
            Duration = 6.5,
            Image = 4483362458,
        })
    
        print("✅ Position saved:", LocalLastPosition)
    end,
    })
    
    local Keybind = FarmTab:CreateKeybind({
        Name = "🚀 Teleport to Saved Position",
        CurrentKeybind = "R",
        HoldToInteract = false,
        Flag = "Keybind1",
    Callback = function()
        local plr = game.Players.LocalPlayer.Name
        if LocalLastPosition then
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(LocalLastPosition)
    
            Rayfield:Notify({
                Title = "🛸 Teleported",
                Content = "You have been teleported to your saved position.",
                Duration = 6.5,
                Image = 4483362458,
            })
    
            print("🛸 Teleported to:", LocalLastPosition)
        else
            Rayfield:Notify({
                Title = "⚠️ No Saved Position",
                Content = "Please save a position before trying to teleport.",
                Duration = 6.5,
                Image = 4483362458,
            })
    
            warn("⚠️ No position saved yet! Use 'Save Current Position' first.")
        end
    end,
    })


    local selectedGroups = {}
    local visibleTags = {}
    local showDistance = false
    local maxDistance = 250 
    
    local groupColors = {
        ["CrystallineMetalOre"] = Color3.fromRGB(0, 255, 255),
        ["CubicBlockMetal"] = Color3.fromRGB(255, 255, 255),
        ["GemBlockMesh"] = Color3.fromRGB(255, 0, 255),
        ["OreMesh"] = Color3.fromRGB(255, 170, 0),
        ["ShaleMetalBlock"] = Color3.fromRGB(150, 75, 0),
    }
    
    local function createOreTag(ore)
        local mineId = ore:GetAttribute("MineId")
        if not mineId then return end
    
        local groupColor = groupColors[ore.Name] or Color3.new(1, 1, 1)
    
        -- Billboard tag
        local tag = Instance.new("BillboardGui")
        tag.Name = "OreTag"
        tag.Adornee = ore
        tag.Size = UDim2.new(0, 100, 0, 30)
        tag.StudsOffset = Vector3.new(0, ore.Size.Y / 2 + 0.5, 0)
        tag.AlwaysOnTop = true
        tag.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        tag.Parent = ore
    
        -- Label du minerai
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = mineId
        label.TextColor3 = groupColor
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Code
        label.ZIndex = 2
        label.Parent = tag
    
        local distanceLabel
        if showDistance then
            distanceLabel = Instance.new("TextLabel")
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextScaled = true
            distanceLabel.Font = Enum.Font.Code
            distanceLabel.ZIndex = 2
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.Parent = tag
        end
    
        -- Overlay simple
        local overlay = Instance.new("BoxHandleAdornment")
        overlay.Name = "OreOverlay"
        overlay.Adornee = ore
        overlay.Size = ore.Size * 0.90
        overlay.Color3 = groupColor
        overlay.Transparency = 0.8
        overlay.ZIndex = 1
        overlay.AlwaysOnTop = true
        overlay.Parent = ore
    
        -- Suivi de distance + gestion mort / tp
        task.spawn(function()
            while tag and tag.Parent and overlay and overlay.Parent do
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - ore.Position).Magnitude
                    if dist > maxDistance then
                        tag.Enabled = false
                        overlay.Visible = false
                    else
                        tag.Enabled = true
                        overlay.Visible = true
                        if distanceLabel then
                            distanceLabel.Text = string.format("%.1f studs", dist)
                        end
                    end
                else
                    tag.Enabled = false
                    overlay.Visible = false
                end
                task.wait(0.3)
            end
        end)
    
        table.insert(visibleTags, tag)
        table.insert(visibleTags, overlay)
    end
    
    local function clearTags()
        for _, tag in ipairs(visibleTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        visibleTags = {}
    end
    
    local function showOresByGroup()
        clearTags()
        if #selectedGroups == 0 then return end
    
        for _, group in ipairs(selectedGroups) do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj:GetAttribute("MineId") and obj.Name == group then
                    createOreTag(obj)
                end
            end
        end
    end
    
    local displayToReal = {
        ["🔷 Crystalline Metal Ore"] = "CrystallineMetalOre",
        ["🧊 Cubic Block Metal"] = "CubicBlockMetal",
        ["💎 Gem Block Mesh"] = "GemBlockMesh",
        ["⛏️ Ore Mesh"] = "OreMesh",
        ["🌑 Shale Metal Block"] = "ShaleMetalBlock"
    }
    
    local Divider = FarmTab:CreateDivider()
    local Section = FarmTab:CreateSection("🤖 Esp")

    local Dropdown = FarmTab:CreateDropdown({
        Name = "🧱 View Ore Groups",
        Options = {
            "🔷 Crystalline Metal Ore",
            "🧊 Cubic Block Metal",
            "💎 Gem Block Mesh",
            "⛏️ Ore Mesh",
            "🌑 Shale Metal Block"
        },
        CurrentOption = {},
        MultipleOptions = true,
        Flag = "OreGroupDropdown",
        Callback = function(Options)
            -- Convert selected display names to real group names
            local realOptions = {}
            for _, option in ipairs(Options) do
                local real = displayToReal[option]
                if real then
                    table.insert(realOptions, real)
                end
            end
            selectedGroups = realOptions
            showOresByGroup()
        end,
    })
    
    
    -- Toggle pour voir la distance
    local Toggle = FarmTab:CreateToggle({
       Name = "📏 Show distance between ore",
       CurrentValue = false,
       Flag = "ShowDistanceToggle",
       Callback = function(Value)
            showDistance = Value
            showOresByGroup()
       end,
    })
    
    -- Slider pour régler la distance max
    local Slider = FarmTab:CreateSlider({
       Name = "📡 Max ore distance",
       Range = {10, 500},
       Increment = 10,
       Suffix = "studs",
       CurrentValue = maxDistance,
       Flag = "OreMaxDistanceSlider",
       Callback = function(Value)
            maxDistance = Value
            showOresByGroup()
       end,
    })
    
    -- Support de mise à jour dynamique si des minerais apparaissent
    workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") and obj:GetAttribute("MineId") and table.find(selectedGroups, obj.Name) then
            task.wait(0.2)
            createOreTag(obj)
        end
    end)
    

    ------------------------------------------------- MOBILE TAB -------------------------------------------------
    ------------------------------------------------- MOBILE TAB -------------------------------------------------
    ------------------------------------------------- MOBILE TAB -------------------------------------------------
    ------------------------------------------------- MOBILE TAB -------------------------------------------------
    ------------------------------------------------- MOBILE TAB -------------------------------------------------

    local toogleMobileTab = MobileTab:CreateButton({
        Name = "📦 Store Everything",
        Callback = function()
            local originalPlayerPos = nil
    
            local plr = game.Players.LocalPlayer.Name
            local originalPlayerPos = game.Workspace[plr].HumanoidRootPart.Position
    
            Rayfield:Notify({
                Title = "🚚 Heading to Unloader",
                Content = "Moving to the unloader to store your cargo...",
                Duration = 4,
                Image = 4483362458,
            })
    
            local promptCargo = game.Workspace.Placeables[PlayerSlot].UnloaderSystem.Unloader.CargoVolume.CargoPrompt
            local promptPostion = game.Workspace.Placeables[PlayerSlot].UnloaderSystem.Unloader.CargoVolume.Position
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(promptPostion)
            wait(0.4)
            fireproximityprompt(promptCargo)
    
            game.Workspace[plr].HumanoidRootPart.CFrame = CFrame.new(originalPlayerPos)
    
            Rayfield:Notify({
                Title = "✅ Stored Successfully",
                Content = "📦 Your cargo has been unloaded and stored!",
                Duration = 6.5,
                Image = 4483362458,
            })
        end,
     })

     local Button = MobileTab:CreateButton({
        Name = "💥 Explosive Exploit",
        Callback = function(Keybind)
            local correspondances = {
                ["Dynamite Level 1"] = "TNT1",
                ["Dynamite Level 2"] = "TNT2",
                ["Dynamite Level 3"] = "TNT3",
                ["Dynamite Bundle Level 1"] = "TNTBundle1",
                ["Dynamite Bundle Level 2"] = "TNTBundle2",
                ["Dynamite Bundle Level 3"] = "TNTBundle3",
                ["C4 Level 1"] = "C41",
                ["C4 Level 2"] = "C42",
                ["C4 Level 3"] = "C43",
                ["C4 Level 4"] = "C44",
                ["C4 Level 5"] = "C45",
            }
    
            local correspondancesPioche = {
                ["Rusty Pickaxe"] = "RustyPick",
                ["Iron Pickaxe"] = "IronPick",
                ["Steel Pickaxe"] = "SteelPick",
                ["Platinum Pickaxe"] = "PlatinumPick",
                ["Titanium Pickaxe"] = "TitaniumPick",
                ["Infernum Pickaxe"] = "InfernumPick",
                ["Diamond Pickaxe"] = "DiamondPick",
                ["Mithril Pickaxe"] = "MithrilPick",
                ["Adamantium Pickaxe"] = "AdamantiumPick",
                ["Unobtainium Pickaxe"] = "UnobtainiumPick",
            }
    
            --// Variables
            local player = game.Players.LocalPlayer
            local backpack = player.InnoBackpack
            local character = player.Character
    
            for name, _ in pairs(correspondances) do
                local tool = character:FindFirstChild(name) or backpack:FindFirstChild(name)
                if tool then
                    local args = { [1] = false }
                    tool.EquipRemote:FireServer(unpack(args))
                end
            end
    
            local piocheName = nil
            for _, item in ipairs(backpack:GetChildren()) do
                if correspondancesPioche[item.Name] then
                    piocheName = item.Name
                    break
                end
            end
    
            if piocheName then
                local tool = backpack:FindFirstChild(piocheName)
                if tool then
                    tool.EquipRemote:FireServer(true)
                    wait(0.1)
                    tool.EquipRemote:FireServer(false)
                end
            end
    
            wait(0.1)
    
            local explosiveId = nil
            local c4ToReequip = nil
    
            for _, item in ipairs(backpack:GetChildren()) do
                local correspondance = correspondances[item.Name]
                if correspondance then
                    explosiveId = correspondance
                    c4ToReequip = item
                    break
                end
            end
    
            if explosiveId then
                local equipTool = game:GetService("ReplicatedStorage").MadCommEvents:FindFirstChild("4").EquipTool
                equipTool:FireServer(23, "Explosive", "TNT1")
                wait(0.05)
                equipTool:FireServer(23, "Explosive", explosiveId)
            end
    
            if c4ToReequip then
                wait(0.1)
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    c4ToReequip.Parent = player.Backpack
                    humanoid:EquipTool(c4ToReequip)
                else
                    warn("Humanoid non trouvé pour rééquiper le C4.")
                end
            end
    
            end,
     })

end