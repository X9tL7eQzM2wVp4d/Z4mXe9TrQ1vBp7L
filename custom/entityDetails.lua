local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local scriptEnabled = true
local clickDetectors = {}

local function getFullPath(instance)
    local path = instance.Name
    local parent = instance.Parent
    while parent do
        path = parent.Name .. "/" .. path
        parent = parent.Parent
    end
    return path
end

local function getEntityInfo(entity)
    local info = {}
    table.insert(info, "Name: " .. entity.Name)
    table.insert(info, "Class: " .. entity.ClassName)
    table.insert(info, "Path: " .. getFullPath(entity))
    if entity:IsA("BasePart") then
        table.insert(info, "Position: " .. tostring(entity.Position))
        table.insert(info, "Size: " .. tostring(entity.Size))
        table.insert(info, "Material: " .. tostring(entity.Material))
        table.insert(info, "Color: " .. tostring(entity.Color))
    end

    -- Attributes
    local attributes = entity:GetAttributes()
    if next(attributes) then
        table.insert(info, "Attributes:")
        for key, value in pairs(attributes) do
            table.insert(info, "  - " .. key .. ": " .. tostring(value))
        end
    end

    return table.concat(info, "\n")
end

local function onEntityClicked(player, entity)
    if not scriptEnabled then return end
    local infoText = getEntityInfo(entity)

    print("Entity clicked by " .. player.Name .. ":\n" .. infoText)

    StarterGui:SetCore("SendNotification", {
        Title = "🔍 Entity Info",
        Text = "Check the console for full details.",
        Duration = 5
    })
end

-- Ajouter ClickDetectors à tous les objets
for _, entity in pairs(workspace:GetDescendants()) do
    if entity:IsA("BasePart") then
        local clickDetector = Instance.new("ClickDetector")
        clickDetector.Parent = entity
        clickDetectors[clickDetector] = clickDetector.MouseClick:Connect(function(player)
            if scriptEnabled then
                onEntityClicked(player, entity)
            end
        end)
    end
end

-- Toggle ON/OFF avec la touche H
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        scriptEnabled = not scriptEnabled
        print("🔁 Script is now " .. (scriptEnabled and "ENABLED ✅" or "DISABLED ❌"))

        for clickDetector, connection in pairs(clickDetectors) do
            if scriptEnabled then
                clickDetector.MaxActivationDistance = 32
                if not connection.Connected then
                    clickDetectors[clickDetector] = clickDetector.MouseClick:Connect(function(player)
                        onEntityClicked(player, clickDetector.Parent)
                    end)
                end
            else
                clickDetector.MaxActivationDistance = 0
                connection:Disconnect()
            end
        end
    end
end)
