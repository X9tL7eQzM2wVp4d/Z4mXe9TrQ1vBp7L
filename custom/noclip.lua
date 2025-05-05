local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local flying = false
local baseSpeed = 150
local boostedSpeed = 500
local currentSpeed = baseSpeed

local control = {
    Forward = 0,
    Backward = 0,
    Left = 0,
    Right = 0,
    Up = 0,
    Down = 0
}

-- Fonction utilitaire pour trouver la base part correcte
local function getFlyTarget()
    character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid and humanoid.SeatPart then
        return humanoid.SeatPart
    else
        return character:FindFirstChild("HumanoidRootPart")
    end
end

local function updateMovement(key, value)
    if key == Enum.KeyCode.W then control.Forward = value end
    if key == Enum.KeyCode.S then control.Backward = value end
    if key == Enum.KeyCode.A then control.Left = value end
    if key == Enum.KeyCode.D then control.Right = value end
    if key == Enum.KeyCode.Space then control.Up = value end
    if key == Enum.KeyCode.LeftControl then control.Down = value end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.V then
        flying = not flying
        if flying then
            startFlying()
        end
    end

    if input.KeyCode == Enum.KeyCode.LeftShift then
        currentSpeed = boostedSpeed
    end

    updateMovement(input.KeyCode, 1)
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        currentSpeed = baseSpeed
    end

    updateMovement(input.KeyCode, 0)
end)

-- Fonction de vol principale
function startFlying()
    local flyingPart = getFlyTarget()

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyingVelocity"
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = flyingPart

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not flying then
            bodyVelocity:Destroy()
            conn:Disconnect()
            return
        end

        -- En cas de changement (respawn, changement de siège)
        local newTarget = getFlyTarget()
        if newTarget ~= flyingPart then
            bodyVelocity.Parent = newTarget
            flyingPart = newTarget
        end

        -- Calcul direction
        local cam = workspace.CurrentCamera
        local direction = Vector3.zero
        direction += cam.CFrame.LookVector * (control.Forward - control.Backward)
        direction += cam.CFrame.RightVector * (control.Right - control.Left)
        direction += Vector3.new(0, control.Up - control.Down, 0)

        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * currentSpeed
        else
            bodyVelocity.Velocity = Vector3.zero
        end
    end)
end

-- Mise à jour sur respawn
player.CharacterAdded:Connect(function(char)
    character = char
end)
